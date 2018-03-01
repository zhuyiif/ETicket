//
//  RACSignal+Retry.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "RACSignal+Parse.h"
#import "RACSignal+Retry.h"
#import "DSLoginViewController.h"

@interface DSLoginViewController ()
@end

@implementation RACSignal (Retry)

+ (RACSignal *)retrySignal {
    static RACSignal *retrySignal;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retrySignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[DSLoginViewController show] subscribe:subscriber];
            return nil;
        }];
    });
    return retrySignal;
}

@end
