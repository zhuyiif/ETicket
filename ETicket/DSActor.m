//
//  DSActor.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSActor.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "DSSignupItem.h"

@interface DSActor ()

@property (nonatomic) NSString *source;
@property (nonatomic) NSString *platformToken; //三方平台授权token
@property (nonatomic) NSString *openId;
@property (nonatomic) NSString *expiresIn;
@property (nonatomic, strong) RACSubject *platformLogin;
@property (nonatomic) NSInteger userId;

@end

static DSActor *instance = nil;

@implementation DSActor

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DSActor new];
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
        self.loginType = DSLoginTypeUnknow;
        
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
    return [[RACSignal return:@YES] delay:3];
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
    
    DSLoginType loginType = DSLoginTypeWeChat;
    switch (type) {
        case SSDKPlatformTypeQQ: {
            self.source = @"QQ";
            loginType = DSLoginTypeQQ;
        }
            break;
        case SSDKPlatformTypeFacebook: {
            self.source = @"Facebook";
            loginType = DSLoginTypeFacebook;
        }
            break;
        case SSDKPlatformTypeSinaWeibo: {
            self.source = @"WB";
            loginType = DSLoginTypeWeiBo;
        }
            break;
        case SSDKPlatformTypeTwitter: {
            self.source = @"Twitter";
            loginType = DSLoginTypeTwitter;
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
//    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    NSDictionary *platformLoginParams = @{ @"accessType":accessType,
//                                           @"username": self.openId,
//                                           @"rememberMe": @(YES),
//                                           @"uuid": uuid,
//                                           @"source": @"P" };
//    return [[APICenter postUserLogin:platformLoginParams] execute];
    return  [[RACSignal return:@YES] delay:2];
}

- (void)didLogin {
//    @weakify(self);
//    [[[APICenter getUser:nil] execute] subscribeNext:^(BSPersional *x) {
//        @strongify(self);
//        self.user = x;
//        self.userId = x.id;
//        [[NSNotificationCenter defaultCenter] postNotificationName:KUserUpdateNotification
//                                                            object:nil];
//    }];
}

- (RACSignal *)signupWithItem:(DSSignupItem *)item {
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
