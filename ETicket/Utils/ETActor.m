//
//  ETActor.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETActor.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "ETSignupItem.h"

@interface ETActor ()

@property (nonatomic) NSString *source;
@property (nonatomic) NSString *platformToken; //三方平台授权token
@property (nonatomic) NSString *openId;
@property (nonatomic) NSString *expiresIn;
@property (nonatomic, strong) RACSubject *platformLogin;
@property (nonatomic) NSInteger userId;

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

- (BOOL)isLogin {
    return _login;
}

- (NSString *)currentAccessType {
    return @"";
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
    NSDictionary *params =  @{ @"phoneNumber": account };
    return [[[[APICenter postGetCode:params] execute] flattenMap:^RACStream *(id value) {
        return [[APICenter postLogin:value] execute];
    }] flattenMap:^RACStream *(id x) {
        self.loginType = ETLoginTypeInline;
        self.token = [[x objectForKey:@"user"] objectForKey:@"token"];
        return [self didLogin];
    }];
}

- (RACSignal *)thirdPlatformLogin:(SSDKPlatformType)platform {
    _platformLogin = [RACSubject subject];
    @weakify(self);
    [SSEThirdPartyLoginHelper loginByPlatform:platform
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       associateHandler(user.uid,user,user);
                                       @strongify(self);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (user) {
                                               [self platformLogin:user platformType:platform];
                                               return ;
                                           }
                                           
                                           NSError *error = [NSError errorWithDomain:@"PlatformLogin"
                                                                                code:-100
                                                                            userInfo:@{ @"message": NSLocalizedString(@"获取三方用户信息失败", nil) }];
                                           [self.platformLogin sendError:error];
                                           
                                       });
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    @strongify(self);
                                    if (state != SSDKResponseStateSuccess) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.platformLogin sendError:error];
                                        });
                                    }
                                }];
    return _platformLogin;
}

- (void)platformLogin:(SSDKUser *)user platformType:(SSDKPlatformType)type {
    
    self.source = @"Wechat";
    self.openId = user.uid;
    
    ETLoginType loginType = ETLoginTypeWeChat;
    switch (type) {
        case SSDKPlatformTypeQQ: {
            self.source = @"QQ";
            loginType = ETLoginTypeQQ;
        }
            break;
        case SSDKPlatformTypeFacebook: {
            self.source = @"Facebook";
            loginType = ETLoginTypeFacebook;
        }
            break;
        case SSDKPlatformTypeSinaWeibo: {
            self.source = @"WB";
            loginType = ETLoginTypeWeiBo;
        }
            break;
        case SSDKPlatformTypeTwitter: {
            self.source = @"Twitter";
            loginType = ETLoginTypeTwitter;
        }
            break;
        default:
            break;
    }
    self.loginType = loginType;
    NSString *accessType = [self currentAccessType];
    NSDictionary *checkRegitsterParam = @{@"accessType":accessType , @"username": self.openId};

    [self.platformLogin sendNext:@YES];
    [self.platformLogin sendCompleted];
//    @weakify(self);
//    [[[[APICenter getCheckRegister:checkRegitsterParam] execute] flattenMap:^RACStream *(id x) {
//        @strongify(self);
//        return [x boolValue] ? [self doPlatformLogin:accessType] : [[self doPlatformSignup:user accessType:accessType] flattenMap:^RACStream *(id value) {
//            return [self doPlatformLogin:accessType];
//        }];
//    }] subscribeNext:^(id x) {
//        @strongify(self);
//        self.token = x[@"token"];
//        [self didLogin];
//        [self.platformLogin sendNext:x];
//        [self.platformLogin sendCompleted];
//    } error:^(NSError *error) {
//        @strongify(self);
//        [self.platformLogin sendError:error];
//        self.loginType = BSLoginTypeUnknow;
//    }];
}

- (RACSignal *)doPlatformSignup:(SSDKUser *)user accessType:(NSString *)accessType{
//    @weakify(self);
//    return [[[[APICenter getAgreementProtocol:nil] execute] flattenMap:^RACStream *(id x) {
//        [BSPopover showLoading:NO];
//        return [BSAlertView showWithHTML:x title:NSLocalizedString(@"瓢虫说免责声明",nil) leftButton:NSLocalizedString(@"不同意", nil) rightButton:NSLocalizedString(@"同意", nil)];
//    }] flattenMap:^RACStream *(id x) {
//        @strongify(self);
//        if ([x integerValue] == 1) {
//            NSDictionary *registerParam = @{@"accessType": accessType,
//                                            @"username": self.openId,
//                                            @"nickname": user.nickname?:@"nickname"};
//            return [[APICenter postUserRegister:registerParam] execute];
//        }
//        return [RACSignal error:nil];
//    }];
    return [[RACSignal return:@YES] delay:3];
}

- (RACSignal *)doPlatformLogin:(NSString *)accessType {
//    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIETtring];
//    NSDictionary *platformLoginParams = @{ @"accessType":accessType,
//                                           @"username": self.openId,
//                                           @"rememberMe": @(YES),
//                                           @"uuid": uuid,
//                                           @"source": @"P" };
//    return [[APICenter postUserLogin:platformLoginParams] execute];
    return  [[RACSignal return:@YES] delay:2];
}

- (RACSignal *)didLogin {
    
    return [[[APICenter getUserProfile:nil] execute] doNext:^(id x) {
        self.login = YES;
    }];
   
}

- (RACSignal *)signupWithItem:(ETSignupItem *)item {
    if (!item) {
        return [RACSignal empty];
    }
    return [[RACSignal return:@YES] delay:3];
//    item.accessType = @"SYS";
//    NSDictionary *checkParam = @{@"accessType": @"SYS",
//                                 @"username": item.username};
//    return [[[APICenter getCheckRegister:checkParam] execute] flattenMap:^RACStream *(id value) {
//        if ([value boolValue]) {
//            [BSPopover showFailureWithContent:NSLocalizedString(@"手机号已被注册", nil)];
//            NSError *error = [NSError errorWithDomain:@"register failed"
//                                                 code:999999
//                                             userInfo:@{ @"message": NSLocalizedString(@"手机号已被注册", nil)}];
//            return [RACSignal error:error];
//        }
//        NSDictionary *param = [MTLJSONAdapter JSONDictionaryFromModel:item error:nil];
//        return [[APICenter postUserRegister:param] execute];
//    }];
}

@end
