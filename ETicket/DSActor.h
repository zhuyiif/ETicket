//
//  DSActor.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, DSLoginType) {
    DSLoginTypeUnknow = 1,
    DSLoginTypeInline = 2, //内部
    DSLoginTypeFacebook = 3,
    DSLoginTypeQQ = 4,
    DSLoginTypeWeChat = 5,
    DSLoginTypeWeiBo = 6,
    DSLoginTypeTwitter = 7,
};

@class DSSignupItem;

@interface DSActor : NSObject

@property (nonatomic, assign) DSLoginType loginType;
@property (nonatomic, strong) NSString *token;
@property (nonatomic) BOOL login;

+ (instancetype)instance;

- (BOOL)isLogin;

- (NSString *)currentAccessType;

- (void)logoutWithBlock:(void (^)(void))completeBlock;

- (RACSignal *)loginWithAccount:(NSString *)account
                       password:(NSString *)password;

- (RACSignal *)thirdPlatformLogin:(SSDKPlatformType)platform;

- (RACSignal *)signupWithItem:(DSSignupItem *)item;

@end
