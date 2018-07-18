//
//  ETPopover.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//
#import "ETLoadingView.h"
#import "ETToastView.h"

#define kToastHideCompletionBlock @"kToastHideCompletionBlock"

@interface ETPopover ()

@end

static ETLoadingView *loadingView = nil;
static ETToastView *toastView = nil;
static BOOL isShow;
static const double defaultDuration = 2.2;

@implementation ETPopover

+ (void)alertError:(NSError *)error {
    [self showLoading:NO];
    //    if (error.code == 0 || error.code == -1008 || error.code == kBindChanceIsInvalidCode) {
    //        return;
    //    }
    [self showFailureWithContent:error.message ?: [error localizedDescription]];
}

+ (void)showLoading:(BOOL)show {
    [self showLoading:(BOOL)show withText:nil];
}

+ (void)showLoading:(BOOL)show withText:(NSString *)text {
    [self showLoading:show withText:text immediate:NO completion:nil];
}

+ (void)showLoading:(BOOL)show withText:(NSString *)text completion:(void(^)(void))completion {
    [self showLoading:show withText:text immediate:NO completion:completion];
}

+ (void)showLoading:(BOOL)show withText:(NSString *)text immediate:(BOOL)now {
    [self showLoading:show withText:text immediate:now completion:nil];
}

+ (void)showLoading:(BOOL)show withText:(NSString *)text immediate:(BOOL)now completion:(void(^)(void))completion {
    isShow = show;
    if (!text) {
        text = NSLocalizedString(@"加载中",nil);
    }
    
    if (show && loadingView.superview) {
        loadingView.textLabel.text = text;
        completion ? completion() : nil;
        return;
    }
    
    
    if (loadingView.superview) {
        if (now) {
            [loadingView hide:^{
                [self showLoading:show withText:text immediate:now completion:completion];
            } isAnimate:NO];
        } else {
            [self bk_performBlock:^{
                if (isShow) {
                    return;
                }
                [loadingView hide:^{
                    [self showLoading:show withText:text immediate:now completion:completion];
                } isAnimate:NO];
            } afterDelay:.3];
        }
        return;
    }
    
    if (!show) {
        return;
    }
    
    loadingView = [[ETLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadingView.textLabel.text = text;
    @weakify(self);
    [[loadingView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoading:NO withText:nil];
    }];
    [self addViewToWindow:loadingView];
    [loadingView show:completion];
}

+ (void)showFailureWithContent:(NSString *)content {
    [self showWithStyle:ETToastFailure content:content duration:defaultDuration completion:nil];
}

+ (void)showSuccessWithContent:(NSString *)content {
    [self showWithStyle:ETToastSuccess content:content duration:defaultDuration completion:nil];
}

+ (void)showWithContent:(NSString *)content {
    [self showWithStyle:ETToastText content:content duration:defaultDuration completion:nil];
}

+ (void)showFailureWithContent:(NSString *)content finishBlock:(void (^)(void))block {
    [self showWithStyle:ETToastFailure content:content duration:defaultDuration completion:block];
}

+ (void)showSuccessWithContent:(NSString *)content finishBlock:(void (^)(void))block {
    [self showWithStyle:ETToastSuccess content:content duration:defaultDuration completion:block];
}

+ (void)showSuccessWithContent:(NSString *)content duration:(double)duration finishBlock:(void (^)(void))block {
    [self showWithStyle:ETToastSuccess content:content duration:duration completion:block];
}

+ (void)showFailureWithContent:(NSString *)content duration:(double)duration finishBlock:(void (^)(void))block {
    [self showWithStyle:ETToastFailure content:content duration:duration completion:block];
}

+ (void)showWithStyle:(ETToastStyle)style content:(NSString *)content duration:(double)duration completion:(void (^)(void))completion {
    [self showLoading:NO withText:nil immediate:YES];
    if ([NSString isBlankString:content] || [content containsString:@"text/html"]) {
        completion ? completion() : nil;
        return;
    }
    
    static id wapperBlock = nil;
    if (wapperBlock) {
        [self bk_cancelBlock:wapperBlock];
        wapperBlock = nil;
    }
    
    if (toastView.superview) {
        [self removeFromWindow:toastView];
    }
    
    ETToastView *tempToastView = [[ETToastView alloc] initWithStyle:style content:content];
    tempToastView.layer.zPosition = 1;
    toastView = tempToastView;
    if (completion) {
        [toastView bk_atomicallyAssociateCopyOfValue:completion withKey:kToastHideCompletionBlock];
    }
    
    [self addViewToWindow:toastView];
    [toastView show];
    wapperBlock = [self bk_performBlock:^{
        if (tempToastView && tempToastView.superview) {
            [tempToastView hide:^{
                [self removeFromWindow:tempToastView];
            }];
        }
    } afterDelay:duration];
}

+ (void)removeFromWindow:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view removeFromSuperview];
    void (^finishBlock)(void) = [view bk_associatedValueForKey:kToastHideCompletionBlock];
    if (finishBlock) {
        finishBlock();
    }
    
    view = nil;
}

+ (void)addViewToWindow:(UIView *)view {
    view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

@end

