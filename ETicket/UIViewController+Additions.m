//
//  UIViewController+EmptyBackButton.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "SwizzleMethod.h"
#import "ETRechargeViewController.h"

@implementation UIViewController (Additions)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SwizzleMethod swizzleMethod:[self class] originalSelector:@selector(viewDidLoad) swizzledSelector:@selector(emptyBackButton_viewDidLoad)];
            [SwizzleMethod swizzleMethod:[self class] originalSelector:@selector(rt_customBackItemWithTarget:action:) swizzledSelector:@selector(swizzle_customBackItemWithTarget:action:)];
    });
}

- (void)emptyBackButton_viewDidLoad {
    [self emptyBackButton_viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
}

- (void)popController {
    [self.view endEditing:YES];
    if (1 < [[self.navigationController viewControllers] count]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES
                                                          completion:^{
                                                              
                                                          }];
    }
}

- (UIBarButtonItem *)swizzle_customBackItemWithTarget:(id)target action:(SEL)action {
    
    UIImage *backImage = [[UIImage imageNamed:@"navBack"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if ([self isKindOfClass:[ETRechargeViewController class]]) {
        backImage = [[UIImage imageNamed:@"ArrowBackWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return [[UIBarButtonItem alloc] initWithImage:backImage
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
}


@end
