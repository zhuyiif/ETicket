//
//  ETAppDelegate.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ETMenusViewController;

@interface ETAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (ETAppDelegate *)delegate;
+ (ETMenusViewController *)menuViewController;
- (void)resetRootController;

@end

