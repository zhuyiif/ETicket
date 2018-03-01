//
//  UIApplication+Additions.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "UIApplication+Additions.h"
#import "ETAppDelegate.h"
#import "ETMenusViewController.h"

@implementation UIApplication (Additions)

+ (UIViewController *)topViewController {
    UIViewController *rootViewController = [self sharedApplication].delegate.window.rootViewController;
    while (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }
    return rootViewController;
}

+ (UIView *)topView {
    return [self topViewController].view;
}

+ (UIWindow *)topWindow {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    UIWindow *topWindow = nil;
    for (UIWindow *window in frontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            topWindow = window;
            break;
        }
    }
    return topWindow;
}

+ (void)pushViewController:(UIViewController *)viewController {
    UIViewController *topViewController = [self topViewController];
    if (![topViewController isKindOfClass:[UINavigationController class]]) {
        topViewController = topViewController.navigationController;
    }
    
    if(!topViewController) {
        topViewController = (ETMenusViewController *)[ETAppDelegate menuViewController].navigationController;
    }
    NSAssert(topViewController, @"can not push without UINavigationController");
    [(UINavigationController *)topViewController pushViewController:viewController animated:YES];
}

+ (void)presentViewController:(UIViewController *)viewController completion:(void (^)())completion {
    [[self topViewController] presentViewController:viewController animated:YES completion:completion];
}


@end
