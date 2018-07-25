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

@interface ETActor ()

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
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)logoutWithBlock:(void (^)(void))completeBlock {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        self.token = nil;
        self.loginType = ETLoginTypeUnknow;
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieJar deleteCookie:cookie];
        }
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

- (void)cleanUserInfos {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.token = nil;
    self.user = nil;
    self.loginType = ETLoginTypeUnknow;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
}

@end
