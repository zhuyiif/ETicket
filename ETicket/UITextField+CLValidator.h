//
//  UITextField+CLValidator.h
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^TestBlock)(UITextField *textField);
typedef void (^FailureBlock)(NSString *message);

@interface UITextField (CLValidator)

// 添加验证的错误信息和验证Block
- (void)addFailureMessage:(NSString *)message testBlock:(TestBlock)block;
// 重置验证器
- (void)resetValidator;
// 验证错误回调
- (void)setValidatorFailureBlock:(FailureBlock)failure;
// 验证
- (BOOL)validate;
// 批量验证
+ (BOOL)validateTextFields:(NSArray <UITextField *>*)textFields failureBlock:(FailureBlock)failure;

@end
