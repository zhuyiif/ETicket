//
//  ETMenusViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETMenusViewController.h"
#import "ETLoginViewController.h"
#import "ETHomeViewController.h"
#import "ETMineViewController.h"
#import "ETQRCodeViewController.h"
#import "ETNewsViewController.h"
#import "ETTravelViewController.h"
#import "UIImage+Draw.h"

@interface ETMenusViewController ()<UITabBarControllerDelegate>

@end

@implementation ETMenusViewController


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
            if ([vc.viewControllers.firstObject isKindOfClass:[ETMineViewController class]]) {
                [[ETLoginViewController showIfNeeded] subscribeNext:^(id x) {
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

    UIImage *image = [UIImage imageNamed:@"tabBg"];
    UIImageView *img = [[UIImageView alloc] initWithImage:image];
    img.frame = CGRectMake(0, self.tabBar.frame.size.height - image.size.height, self.tabBar.frame.size.width, image.size.height);
    img.contentMode = UIViewContentModeBottom;
    [[self tabBar] insertSubview:img atIndex:0];
    
    UIViewController *home = [ETHomeViewController new];
    home.tabBarItem.title = NSLocalizedString(@"首页", nil);
    home.tabBarItem.image = [[UIImage imageNamed:@"tabHomeNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabHomeHight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *homeNavi = [[RTRootNavigationController alloc] initWithRootViewController:home];
    
    UIViewController *travel = [ETTravelViewController new];
    travel.tabBarItem.title = NSLocalizedString(@"行程", nil);
    travel.tabBarItem.image = [[UIImage imageNamed:@"tabTravelNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    travel.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabTravelHight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *travelNavi = [[RTRootNavigationController alloc] initWithRootViewController:travel];
    
    UIViewController *scan = [ETQRCodeViewController new];
    scan.tabBarItem.title = @"";
    scan.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);

    scan.tabBarItem.image = [[UIImage imageNamed:@"tabScanNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    scan.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabScanNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *scanNavi = [[RTRootNavigationController alloc] initWithRootViewController:scan];
    
    UIViewController *news = [ETNewsViewController new];
    news.tabBarItem.title = @"资讯";
    news.tabBarItem.image = [[UIImage imageNamed:@"tabNewsNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    news.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabNewsHight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *newsNavi = [[RTRootNavigationController alloc] initWithRootViewController:news];
   
    UIViewController *mine = [ETMineViewController new];
    mine.tabBarItem.title = NSLocalizedString(@"我的", nil);
    mine.tabBarItem.image = [[UIImage imageNamed:@"tabMineNor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabMineHight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *mineNavi = [[RTRootNavigationController alloc] initWithRootViewController:mine];

    self.viewControllers = @[homeNavi,travelNavi,scanNavi,newsNavi,mineNavi];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav.viewControllers.firstObject isKindOfClass:[ETMineViewController class]]) {
        if ([ETActor instance].isLogin) {
            return YES;
        }
        
        [[ETLoginViewController showIfNeeded] subscribeNext:^(id x) {
            if ([x boolValue]) {
                [self setSelectedViewController:viewController];
            }
        }];
        return NO;
    }
    
    return YES;
}

@end
