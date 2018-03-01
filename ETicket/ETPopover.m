//
//  ETPopover.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#import "ETLoadingSpinner.h"
#import "ETPopover.h"
#import "UIView+ITTAdditions.h"

static UIView *loadingPopover;

@implementation ETPopover

#define kLoadingViewTag 0110
#define kSpinnerViewTag 0111

+ (void)showLoading:(BOOL)show parentView:(UIView *)parentView animate:(BOOL)animate {
    if (!show) {
        if (!loadingPopover && loadingPopover.superview) {
            return;
        }
        
        if (animate) {
            ETLoadingSpinner *spinner = [loadingPopover viewWithTag:kSpinnerViewTag];
            if (spinner) {
                [spinner stopAnimation];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [loadingPopover removeFromSuperview];
                loadingPopover = nil;
            });
        } else {
            [loadingPopover removeFromSuperview];
            loadingPopover = nil;
        }
        return;
    }
    
    if (loadingPopover && loadingPopover.superview) {
        [loadingPopover removeFromSuperview];
        loadingPopover = nil;
        return;
    }
    
    loadingPopover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadingPopover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    loadingPopover.tag = kLoadingViewTag;
    loadingPopover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (parentView) {
        [parentView addSubview:loadingPopover];
        [parentView bringSubviewToFront:loadingPopover];
    } else {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:loadingPopover];
                break;
            }
    }
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"delet"] forState:UIControlStateNormal];
    [loadingPopover addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.top.equalTo(loadingPopover).offset(10);
        make.right.equalTo(loadingPopover).offset(-10);
    }];
    
    @weakify(self);
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoading:NO];
    }];
    
    UIView *popover = [UIView new];
    [popover setBackgroundColor:[[UIColor drColorC5] colorWithAlphaComponent:0.5]];
    popover.layer.cornerRadius = 5.0f;
    popover.clipsToBounds = YES;
    popover.layer.borderColor = [UIColor clearColor].CGColor;
    popover.layer.borderWidth = 1.0f;
    [loadingPopover addSubview:popover];
    [popover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(loadingPopover);
        make.left.greaterThanOrEqualTo(loadingPopover).offset(50);
        make.right.lessThanOrEqualTo(loadingPopover).offset(-50);
    }];
    
    ETLoadingSpinner *spinner = [[ETLoadingSpinner alloc] initWithStrokeColor:[UIColor whiteColor] strokeWidth:2];
    spinner.tag = kSpinnerViewTag;
    [popover addSubview:spinner];
    [spinner startAnimation];
    [spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popover).offset(15);
        make.width.height.equalTo(@40);
        make.centerX.equalTo(popover);
        make.left.greaterThanOrEqualTo(popover).offset(25);
        make.right.lessThanOrEqualTo(popover).offset(-25);
        
    }];
    
    UILabel *loading = [UILabel new];
    loading.backgroundColor = [UIColor clearColor];
    loading.textAlignment = NSTextAlignmentCenter;
    loading.font = [UIFont s04Font];
    loading.text = NSLocalizedString(@"请稍等..", nil);
    loading.textColor = [UIColor whiteColor];
    [popover addSubview:loading];
    [loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spinner.mas_bottom).offset(10);
        make.bottom.equalTo(popover).offset(-15);
        make.centerX.equalTo(popover);
        make.left.greaterThanOrEqualTo(popover).offset(25);
        make.right.lessThanOrEqualTo(popover).offset(-25);
    }];
}

+ (void)showLoadingInView:(UIView *)parentView {
    [self showLoading:YES parentView:parentView animate:YES];
}

+ (void)showLoading:(BOOL)show {
    [self showLoading:show parentView:nil animate:YES];
}

+ (void)showWithContent:(NSString *)content {
    [self showLoading:NO parentView:nil animate:NO];
    UIView *parentView = [UIApplication topView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = content;
    hud.cornerRadius = 5;
    [hud hide:YES afterDelay:2];
}

+ (void)showSuccessWithContent:(NSString *)content {
    [self showSuccessWithContent:content finishBlock:nil];
}

+ (void)showFailureWithContent:(NSString *)content {
    [self showFailureWithContent:content finishBlock:nil];
}

+ (void)showSuccessWithContent:(NSString *)content finishBlock:(void (^)(void))block {
    [self showWithContent:content icon:@"IconPopDone" finishBlock:block];
}

+ (void)showFailureWithContent:(NSString *)content finishBlock:(void (^)(void))block {
    [self showWithContent:content icon:@"IconPopError" finishBlock:block];
}

+ (void)showWithContent:(NSString *)content icon:(NSString *)icon finishBlock:(void (^)(void))block {
    [self showLoading:NO parentView:nil animate:NO];
    UIView *parentView = [UIApplication topView];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:parentView];
    hud.removeFromSuperViewOnHide = YES;
    [parentView addSubview:hud];
    [hud show:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabelText = content;
    
    UIView *popover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 46)];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    iconView.image = [UIImage imageNamed:icon];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    [popover addSubview:iconView];
    hud.customView = popover;
    [hud hide:YES afterDelay:2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *parentView = [UIApplication topView];
        parentView.userInteractionEnabled = YES;
        [hud hide:YES];
        
        if (block) {
            block();
        }
    });
}

@end
