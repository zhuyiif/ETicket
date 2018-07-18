//
//  UITextField+CLValidator.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UITextField+CLValidator.h"
#import <objc/runtime.h>

static char validatorArrayKey;
static char validatorFailureBlockKey;

@implementation UITextField (CLValidator)

#pragma property

- (NSMutableArray *)validatorArray {
    NSMutableArray *array = objc_getAssociatedObject(self, &validatorArrayKey);
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &validatorArrayKey, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

- (FailureBlock)failureBlock {
    return objc_getAssociatedObject(self, &validatorFailureBlockKey);
}

#pragma public method

- (void)addFailureMessage:(NSString *)message testBlock:(TestBlock)block {
    if (!message || !block) {
        return;
    }
    [[self validatorArray] addObject:@{message:block}];
}

- (void)resetValidator {
    [[self validatorArray] removeAllObjects];
}

- (void)setValidatorFailureBlock:(FailureBlock)failure{
    if (!failure) {
        return;
    }
    objc_setAssociatedObject(self, &validatorFailureBlockKey, failure, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)validate {
    for (NSDictionary *data in [self validatorArray]) {
        NSArray *messages = [data allKeys];
        NSString *msg = messages.firstObject;
        TestBlock testBlock = data[msg];
        if (!testBlock(self)) {
            FailureBlock failureBlock = [self failureBlock];
            if (failureBlock) {
                failureBlock(msg);
            }
            return NO;
        };
    }
    return YES;
}

+ (BOOL)validateTextFields:(NSArray <UITextField *>*)textFields failureBlock:(FailureBlock)failure {
    for (UITextField *textView in textFields) {
        [textView setValidatorFailureBlock:^(NSString *message) {
            if (failure) failure(message);
        }];
        if (![textView validate]) return NO;
    }
    return YES;
}

@end
