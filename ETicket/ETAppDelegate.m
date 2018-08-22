//
//  ETAppDelegate.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETAppDelegate.h"
#import "ETMenusViewController.h"
#import "APIHosts.h"
#import <SDImageCache.h>
#import "ETAppHelper.h"
#import "ETGuideViewController.h"
#import "ETHomeViewController.h"
#import "RSAUtil.h"
#import <Security/Security.h>

@interface ETAppDelegate ()

@property (nonatomic) ETMenusViewController *menu;
@property (nonatomic) NSDictionary *pushInfo;

@end

@implementation ETAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [Query setConfig:[APIHosts sharedInstance]];
    [application setApplicationIconBadgeNumber:0];
    if (launchOptions != nil) {
        self.pushInfo = [launchOptions objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    }
    [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:32 * 1024 * 1024 diskCapacity:64 * 1024 * 1024 diskPath:nil]];
    [ETAppHelper configTheme];
    [ETAppHelper configPopoverController];
    @weakify(self);
    [[self showGuideIfNeeded] subscribeNext:^(id x) {
        @strongify(self);
        [self enterMainWithTransition:[x boolValue]];
        [[[ETActor instance] refreshSeed] subscribeNext:^(id x) {
            
        }];
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[[ETActor instance] refreshSeed] subscribeNext:^(id x) {
        
    }];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [ETAppHelper application:application openURL:url];
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    [ETAppHelper application:app openURL:url];
    return YES;
}

#pragma private
- (RACSignal *)showGuideIfNeeded {
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) {
        return [RACSignal return:@NO];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 显示版本新特性界面
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        UIViewController *guide = [[ETGuideViewController alloc] initWithCompleteBlock:^{
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        }];
        
        if (!self.window.rootViewController.view) {
            self.window.rootViewController = guide;
        } else {
            [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.window.rootViewController = guide;
            } completion:nil];
        }
        return nil;
    }];
}

- (void)enterMainWithTransition:(BOOL)transition {
    if (!_menu) {
        _menu = [[ETMenusViewController alloc] init];
        _menu.hidesBottomBarWhenPushed = YES;
    } else {
        [_menu.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
    
    UIView *fromView = self.window.rootViewController.view;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:_menu];
    navi.navigationBarHidden = YES;
    
    if (fromView && transition) {
        [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.window.rootViewController = navi;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.window.rootViewController = navi;
    }
}

#pragma mark - Some shortcuts
+ (ETAppDelegate *)delegate {
    return (ETAppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (ETMenusViewController *)menuViewController {
    ETAppDelegate *appDelegate = [self delegate];
    return (ETMenusViewController *)appDelegate.menu;
}

- (void)resetRootController {
    self.menu = nil;
    [self enterMainWithTransition:NO];
}

+ (void)showHomeController {
    ETMenusViewController *menuController = [self menuViewController];
    UINavigationController *vc = menuController.selectedViewController;
    for (UIViewController *controller in vc.viewControllers) {
        if ([controller presentedViewController]) {
            [controller dismissViewControllerAnimated:NO completion:nil];
        }
    }
    [vc popToRootViewControllerAnimated:YES];
    [menuController setShowViewController:[ETHomeViewController new]];
}

@end
