//
//  DSMenusViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSMenusViewController.h"
#import "DSLoginViewController.h"
#import "DSHomeViewController.h"
#import "DSMineViewController.h"
#import "DSMaterialsViewController.h"

@interface DSMenusViewController ()<UITabBarControllerDelegate>

@end

@implementation DSMenusViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public
- (void)setShowViewController:(UIViewController *)viewController {
    for (UINavigationController *vc in self.viewControllers) {
        // 如果viewController是tab中的一个
        if ([vc.viewControllers.firstObject isMemberOfClass:[viewController class]]) {
            if ([vc.viewControllers.firstObject isKindOfClass:[DSMineViewController class]]) {
                [[DSLoginViewController showIfNeeded] subscribeNext:^(id x) {
                    [self setSelectedViewController:vc];
                }];
            } else {
                for (UIViewController *controller in vc.viewControllers) {
                    if ([controller presentedViewController]) {
                        [controller dismissViewControllerAnimated:NO completion:nil];
                    }
                }
                [vc popToRootViewControllerAnimated:YES];
                [self setSelectedViewController:vc];
            }
            return;
        }
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Private
- (void)setupUI {
    UIViewController *home = [DSHomeViewController new];
    home.tabBarItem.title = NSLocalizedString(@"首页", nil);
    home.tabBarItem.image = [[UIImage imageNamed:@"tabHomeNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabHomeHight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:home];
    
    UIViewController *lesson = [DSMaterialsViewController new];
    lesson.tabBarItem.title = NSLocalizedString(@"课程", nil);
    lesson.tabBarItem.image = [[UIImage imageNamed:@"tabRankNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    lesson.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabRankHight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *lessonNav = [[UINavigationController alloc] initWithRootViewController:lesson];
    
   
    UIViewController *mine = [DSMineViewController new];
    mine.tabBarItem.title = NSLocalizedString(@"我的", nil);
    mine.tabBarItem.image = [[UIImage imageNamed:@"tabMineNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabMineHight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *mineNavi = [[UINavigationController alloc] initWithRootViewController:mine];

    self.viewControllers = @[homeNavi, lessonNav,mineNavi];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav.viewControllers.firstObject isKindOfClass:[DSMineViewController class]]) {
        if ([DSActor instance].isLogin) {
            return YES;
        }
        
        [[DSLoginViewController showIfNeeded] subscribeNext:^(id x) {
            if ([x boolValue]) {
                [self setSelectedViewController:viewController];
            }
        }];
        return NO;
    }
    
    return YES;
}

@end
