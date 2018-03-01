//
//  DSPopover.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSPopover : NSObject

+ (void)showLoading:(BOOL)show;
/*
 showLoading: will insert the loadingView into app's topView, which effectly
 block all user interactions.
 OTOH showLoadingInView: can be used to insert into current view and leave the
 navigation bar still touchable,
 users can navigate back to cancel this loading
 */
+ (void)showLoadingInView:(UIView *)parentView;

+ (void)showLoading:(BOOL)show parentView:(UIView *)parentView animate:(BOOL)animate;

+ (void)showWithContent:(NSString *)content;
+ (void)showSuccessWithContent:(NSString *)content;
+ (void)showFailureWithContent:(NSString *)content;
+ (void)showSuccessWithContent:(NSString *)content
                   finishBlock:(void (^)(void))block;
+ (void)showFailureWithContent:(NSString *)content
                   finishBlock:(void (^)(void))block;

@end
