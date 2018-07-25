//
//  APICenter.m
//  read
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//
#import "APICenter.h"
#import "APIHosts.h"
#import "ETBannerInfo.h"
#import "ETAnouncementInfo.h"

@implementation APICenter

+ (Query *)getBanner:(NSDictionary *)parameters {
    return [Query GET:[self packageCMSHost:@"api/slides"] parameters:parameters listKey:@"list" modelClass:[ETBannerInfo class]];
}

+ (Query *)getAnnounces:(NSDictionary *)parameters {
    return [Query GET:[self packageCMSHost:@"api/notifications"] parameters:parameters listKey:@"list" modelClass:[ETAnouncementInfo class]];
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
    return [Query POST:@"api/users/sms_code" parameters:parameters];
}

+ (Query *)putPaymentConfirmation:(NSDictionary *)parameters {
    return [Query PUT:@"/api/users/recharge" parameters:parameters];
}

+ (Query *)postLogin:(NSDictionary *)parameters {
    return [Query POST:@"/api/users/login" parameters:parameters listKey:nil modelClass:[ETUser class]];
}

+ (NSString *)packageCMSHost:(NSString *)apiPath {
    return [NSString stringWithFormat:@"%@/%@",[APIHosts cmsURL],apiPath];
}

@end
