//
//  ETActor.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETActor.h"
#import "ETLoginViewController.h"

#define kTokenKey @"tokenKey"
#define kUserKey @"userKey"
#define kSeedKey @"seedKey"
#define kNotifyVoice @"notifyVoice"

@interface ETActor ()

@property (nonatomic) NSDictionary *seed;

@end

static ETActor *instance = nil;

@implementation ETActor

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ETActor new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSData *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserKey];
        if (userDic) {
            _user = [MTLJSONAdapter modelOfClass:[ETUser class] fromJSONDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:userDic] error:nil];
        }
        
    }
    return self;
}

- (BOOL)isLogin {
    return [NSString isNotBlank:self.token];
}

- (void)setUser:(ETUser *)user {
    _user = user;
    if (!user) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKey];
    } else {
        NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:[MTLJSONAdapter JSONDictionaryFromModel:_user error:nil]];
        [[NSUserDefaults standardUserDefaults] setObject:archiver forKey:kUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setToken:(NSString *)token {
    if ([NSString isBlankString:token]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:kTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kTokenKey];
}

- (void)setNotifyVoice:(BOOL)notifyVoice {
    [[NSUserDefaults standardUserDefaults] setBool:notifyVoice forKey:kNotifyVoice];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)notifyVoice {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNotifyVoice];
}

- (void)setSeed:(NSDictionary *)seed {
    if (!seed) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSeedKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:seed forKey:kSeedKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)seed {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSeedKey];
}

- (void)logoutWithBlock:(void (^)(void))completeBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cleanUserInfos];
        if (completeBlock) {
            completeBlock();
        }
    });
}

- (RACSignal *)loginWithAccount:(NSString *)account password:(NSString *)password {
    NSDictionary *params =  @{ @"phone": account?:@"",@"code":password?:@""};
    return [[[APICenter postLogin:params] execute] doNext:^(ETUser *user) {
        self.user = user;
        self.token = user.appToken;
        [self refreshSeed];
    }];
    
}

- (RACSignal *)showLoginIfNeeded {
    return [[ETLoginViewController showIfNeeded] doNext:^(id x) {
        [x boolValue] ?:[self cleanUserInfos];
    }];
}

- (RACSignal *)showLogin {
    [self cleanUserInfos];
    return [ETLoginViewController show];
}

- (RACSignal *)refreshSeedIfNeeded {
    if (self.seed) {
        NSDictionary *x  = self.seed;
        NSString *key = x[@"key"];
        NSString *seed = x[@"seed"];
        NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
        if (count <= 0) {
            return [self refreshSeed];
        }
        
        count --;
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSData *privateKeyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *seedData = [[NSData alloc] initWithBase64EncodedString:seed options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if(seedData.length < 200) {
            return [self refreshSeed];
        }
        
        //获取过期时间并验证
        Byte byte[4] = {0x0};
        [seedData getBytes:byte range:NSMakeRange(191, 4)];
        NSInteger expired = ((byte[0] & 0xFF) << 24) | ((byte[1] & 0xFF) << 16) | ((byte[2] & 0xFF) << 8) | (byte[3] & 0xFF);
        NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
        if (expired -currentTime < 3600) {
            //强制刷新
            [[self refreshSeed] subscribeNext:^(id x) {
                
            }];
        }
        
        if (expired < currentTime) {
            return [self refreshSeed];
        }
        
        return [RACSignal return:@{@"key":privateKeyData,@"seed":seedData}];
    }
    return [self refreshSeed];
}

- (RACSignal *)refreshSeed {
    return [[[APICenter getSeed:nil] execute] map:^id(NSDictionary *x) {
        self.seed = x;
        NSString *key = x[@"key"];
        NSString *seed = x[@"seed"];
        [[NSUserDefaults standardUserDefaults] setInteger:20 forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSData *privateKeyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *seedData = [[NSData alloc] initWithBase64EncodedString:seed options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return @{@"key":privateKeyData,@"seed":seedData};
    }];
}

- (void)cleanUserInfos {
    self.token = nil;
    self.user = nil;
    self.seed = nil;
    self.loginType = ETLoginTypeUnknow;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
}

@end
