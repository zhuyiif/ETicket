//
//  SLBannerAnouncementModel.m
//  ETicket
//
//  Created by chunjian wang on 1/12/17.
//
//

#import "ETAnouncementInfo.h"

@implementation ETAnouncementInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (MTLValueTransformer *)createTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[value longLongValue] / 1000];
    } reverseBlock:^id(NSDate *value, BOOL *success, NSError *__autoreleasing *error) {
        return @([value timeIntervalSince1970] * 1000);
    }];
}

+ (MTLValueTransformer *)updateTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[value longLongValue] / 1000];
    } reverseBlock:^id(NSDate *value, BOOL *success, NSError *__autoreleasing *error) {
        return @([value timeIntervalSince1970] * 1000);
    }];
}

@end
