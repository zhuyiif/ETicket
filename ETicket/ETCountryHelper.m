//
//  ETCountryHelper.m
//  ETicket
//
//  Created by chunjian wang on 2018/5/10.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETCountryHelper.h"
#import "ETCountryCode.h"

@interface ETCountryHelper ()


@end

static ETCountryHelper *instance = nil;

@implementation ETCountryHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ETCountryHelper new];
    });
    return instance;
}

- (RACSignal *)syncIfNeeded {
    if (self.countryCodes.count > 0) {
        return [RACSignal return:nil];
    }
    [ETPopover showLoading:YES];
    @weakify(self);
    return [[[[APICenter getCountryCodes:nil] execute] doNext:^(NSDictionary *x) {
        @strongify(self);
        self.countryCodes = x.items;
        [ETPopover showLoading:NO];
    }] doError:^(NSError *error) {
        [ETPopover alertError:error];
    }];
}

@end
