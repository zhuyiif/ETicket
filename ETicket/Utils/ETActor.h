//
//  ETActor.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETUser.h"

typedef NS_OPTIONS(NSUInteger, ETLoginType) {
    ETLoginTypeUnknow = 1,
    ETLoginTypeInline = 2, //内部
    ETLoginTypeFacebook = 3,
    ETLoginTypeQQ = 4,
    ETLoginTypeWeChat = 5,
    ETLoginTypeWeiBo = 6,
    ETLoginTypeTwitter = 7,
};

@class ETSignupItem;

@interface ETActor : NSObject

@property (nonatomic) ETLoginType loginType;
@property (nonatomic) ETUser *user;
@property (nonatomic) NSString *token;
@property (nonatomic) BOOL notifyVoice;

+ (instancetype)instance;

- (BOOL)isLogin;

- (void)logoutWithBlock:(void (^)(void))completeBlock;

- (RACSignal *)loginWithAccount:(NSString *)account
                       password:(NSString *)password;

- (RACSignal *)showLoginIfNeeded;

- (RACSignal *)showLogin;

- (RACSignal *)refreshSeed;

- (RACSignal *)refreshSeedIfNeeded;

@end
