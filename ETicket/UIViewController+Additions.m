//
//  UIViewController+EmptyBackButton.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "SwizzleMethod.h"

@implementation UIViewController (Additions)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SwizzleMethod swizzleMethod:[self class] originalSelector:@selector(viewDidLoad) swizzledSelector:@selector(emptyBackButton_viewDidLoad)];
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


@end
