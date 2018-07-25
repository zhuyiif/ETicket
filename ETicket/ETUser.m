//
//  ETUser.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/25.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETUser.h"

@implementation ETUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"id":@"user.id",
             @"phone":@"user.phone",
             @"isBlack":@"user.isBlack",
             @"appToken":@"app_token"
             };
}

@end
