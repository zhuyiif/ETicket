//
//  APICenter.m
//  read
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//
#import "APICenter.h"
#import "ETBannerInfo.h"


@implementation APICenter

+ (Query *)getBanner:(NSDictionary *)parameters {
    return [Query GET:@"https://www-demo.dianrong.com/feapi/banners" parameters:parameters listKey:@"list" modelClass:[ETBannerInfo class]];
}

+ (Query *)getAgreementProtocol:(NSDictionary *)parameters {
    return [Query GET:@"" parameters:parameters];
}

+ (Query *)getUserProfile:(NSDictionary *)parameters {
    return [Query GET:@"/api/users/my" parameters:parameters];
}

+ (Query *)getPaymentSN:(NSDictionary *)parameters {
    return [Query GET:@"http://www.baidu.com" parameters:parameters];
}

+ (Query *)getCaptcha:(NSDictionary *)parameters {
    return nil;
}

+ (Query *)getCountryCodes:(NSDictionary *)paramters {
    return nil;
}

+ (Query *)postSMS:(NSDictionary *)parameters {
    return [Query POST:@"" parameters:parameters];
}

+ (Query *)postForgetPassword:(NSDictionary *)parameters {
    return [Query POST:@"" parameters:parameters];
}

+ (Query *)putPaymentConfirmation:(NSDictionary *)parameters {
    return [Query PUT:@"/api/users/recharge" parameters:parameters];
}

+ (Query *)postLogin:(NSDictionary *)parameters {
    return [Query POST:@"/api/users/login" parameters:parameters];
}

+ (Query *)postGetCode:(NSDictionary *)parameters {
    return [Query POST:@"/api/users/get-code" parameters:parameters];
}

@end
