//
//  UIApplication+Additions.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Additions)

+ (UIViewController *)topViewController;

+ (UIView *)topView;

+ (UIWindow *)topWindow;

+ (void)pushViewController:(UIViewController *)viewController;

+ (void)presentViewController:(UIViewController *)viewController completion:(void (^)())completion;

@end
