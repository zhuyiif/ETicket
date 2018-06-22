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
    }];
    
    // TODO test should remove later
    
    
    NSString *ekey = @"nTFhFGY9gbMY0Lx6XuqO3XEOFth4RhO3yJos0oPqdUcn0/i8BxQKt2fWVvU/qFWxzGnc7p59u+eRwQtGZc+kuRMkVtBrUeOnM55nffQ2sD5qm2/1RdSkUatpVH8MiLglHhcRGIaLxZvgzitj2FpGM+xQqXJxjxVtqXflaHIcddw=-ghWRbf2gUbwll/WktxFk/QxzwddqRENN6fMJOjl74ZNf7IfYpp7gpwckct4LCQvM0Y2kfsc87WU+JrFnwo4jr3JSsYURwRs4bhVs8Me52Bj+7pfmc3K7qtbIBcDjsrYXT9NfY19hZagZum7Hag8Xc3Fy3Pxzb8Pyvub1SnmtDRQ=-sRM1M7hev4gvQWUqTo5CIFg3MTgR0hHCraahmzTm5ayb1RlylifGSGIoytdtcDRsz/YJQ0ksnisFqPlGNC7KX5ybkVM9f9GYgTOIzTRR0da9D35yCv1iT0cXfCBOP3P1K5xgLC3VU0vsFVus+AGCX7w55clo1OVdGnvYS1x0XyE=-dszq5zuP1WVbQFbn3c45gy62OoTIwZ3k43SPOZXnF8KOSUqN43nYhFbvR+ZESH1zoIqCR74ZMKhxzthvqCcLlDz5ecvfaAEjWDiCmINi5Ua/sNJ9tV3UAMeog2qv0YMZidDV95gmHybGahL6QmT1USVtDqcwc+OX13mWTGaISa0=";
    
    NSString *privkey = @"-----BEGIN PRIVATE KEY-----\nMIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMjOlccsAZlNy/AO\nhzc79cOTopgynaP46wF9RhwoNxRtXWaQb0QhBCEd2jcmD96FumdkwAD/zYGNuHfG\nNUcZ7oSlurZS5ZHcJwoHdb6q3RrqtHKxUpuO0nkutC2jmbhwRU09Q3E3Z+NoSyJi\njzgBsTGL9f3kZk+5ssdksvHnAvtpAgMBAAECgYEAnZLWn5NdsdIFfVu5KVOo2A7q\n4Sme4EP9DY8jTAcWqbXkPA6M8VZDKkWFrg71FvWzP10k+ePBfK8cGQj1V9T2f8Zj\nNuEGdOrKph3G5gbUn+l1GAIc2rt2bcZyKLN2E2XqFv2KHUHvZKwtU6NzrRxxacOb\niPdNHF6IrGzw/wWDxQ0CQQDtXJ+0ZFdpfeK9QrzzykziJP+/iDeYOsWRG2+JJNtM\nX1VBQTXdcaCy+zOyCozKFDum2tWFeV6HUjrSMGwNG0abAkEA2JMlk58SP/e5v5Vv\nsFwmopzAsFOWhcMT/7jQja6HY/T1LHkrp9+O5cmN2FH4hNfVXnn6u+SbFJL194ox\nq/6kSwJBALjzZVXwodQHTTff2s+zoHjOD6G0iG1LzkolMKGSYHaACjRQlaI5Odh8\nuGlQoyeK4HhBKANa8PdMcZz6Mhd8W2UCQEpsXnhZLJNQ1MLyXlwzfo9Y4Jp3Tv2O\naPvyjbByblI6JlpvFUJt/5QVbCoPGSDFbqw1rKUOzQAH9IBpO+KH8fsCQQDEp784\nsiWk6kkuTOpOX//fjeW7KeGXBVLBSxw4GUVCU/rjvousThXv0Zj2oUMPwu2M+Vcy\n8Hr51jyfgRalMc4e\n-----END PRIVATE KEY-----\n";
    
    
    NSDictionary *dict = @{
                           @"username" : @"zackzhu",
                           @"time" : @"1529649138666",
                           };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"json:%@", jsonString);
    
    NSString *encrypted = [RSAUtil encryptString:jsonString privateKey:privkey];
    
    NSString *qrCode = [NSString stringWithFormat:@"%@ %@", ekey,
                        encrypted];
    
    NSLog(@"qr:%@", qrCode);
    
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
