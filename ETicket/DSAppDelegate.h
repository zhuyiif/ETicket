//
//  DSAppDelegate.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSMenusViewController;

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (DSAppDelegate *)delegate;
+ (DSMenusViewController *)menuViewController;
- (void)resetRootController;

@end

