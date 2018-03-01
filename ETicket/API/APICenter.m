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

+ (Query *)getPaymentSN:(NSDictionary *)parameters {
    return [Query emptyQuery];
}

+ (Query *)postSMS:(NSDictionary *)parameters {
    return [Query POST:@"" parameters:parameters];
}

+ (Query *)postForgetPassword:(NSDictionary *)parameters {
    return [Query POST:@"" parameters:parameters];
}

+ (Query *)postPaymentConfirmation:(NSDictionary *)parameters {
    return [Query emptyQuery];
}


@end
