//
//  DSSignupItem.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSSignupItem.h"
#import "NSDate+Formater.h"

@implementation DSSignupItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSValueTransformer *)genderJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if ([NSString isBlankString:value]) {
            return @(NO);
        }
        
        if ([value isEqualToString:@"Female"]) {
            return @(NO);
        }
        return @(YES);
        
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value boolValue]) {
            return @"Male";
        }
        
        return @"Female";
    }];
}

+ (NSValueTransformer *)birthDayJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithString:value format:@"YYYY-MM-dd HH:mm:ss"];
    } reverseBlock:^id(NSDate *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate formattedWithDate:value format:@"YYYY-MM-dd"];
    }];
}

@end
