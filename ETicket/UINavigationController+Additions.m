//
//  UINavigationController+Additions.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "UINavigationController+Additions.h"
#import "SwizzleMethod.h"

@implementation UINavigationController (Additions)

+ (void)load {
    [SwizzleMethod swizzleMethod:self originalSelector:@selector(pushViewController:animated:) swizzledSelector:@selector(swizzle_pushViewController:animated:)];
}

- (void)swizzle_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) { // avoid TabController's subViewControllers hidesTabBar
        viewController.hidesBottomBarWhenPushed = YES;
        if ([viewController isKindOfClass:[RTContainerController class]]) {
            [(RTContainerController *)viewController contentViewController].hidesBottomBarWhenPushed = YES;
        }
    }
    [self swizzle_pushViewController:viewController animated:animated];
}

@end
