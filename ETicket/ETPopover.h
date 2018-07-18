//
//  ETPopover.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETPopover : NSObject

+ (void)alertError:(NSError *)error;
+ (void)showLoading:(BOOL)show;
+ (void)showLoading:(BOOL)show withText:(NSString *)text;
+ (void)showLoading:(BOOL)show withText:(NSString *)text immediate:(BOOL)now;
+ (void)showLoading:(BOOL)show withText:(NSString *)text completion:(void(^)(void))completion;
+ (void)showLoading:(BOOL)show withText:(NSString *)text immediate:(BOOL)now completion:(void(^)(void))completion;

+ (void)showWithContent:(NSString *)content;
+ (void)showSuccessWithContent:(NSString *)content;
+ (void)showFailureWithContent:(NSString *)content;

+ (void)showSuccessWithContent:(NSString *)content finishBlock:(void (^)(void))block;
+ (void)showFailureWithContent:(NSString *)content finishBlock:(void (^)(void))block;

+ (void)showSuccessWithContent:(NSString *)content duration:(double)duration finishBlock:(void (^)(void))block;
+ (void)showFailureWithContent:(NSString *)content duration:(double)duration finishBlock:(void (^)(void))block;

@end
