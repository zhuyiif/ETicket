//
//  ETAppHelper.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETAppHelper : NSObject

+ (void)configTheme;
+ (void)configSNSPlatforms;
+ (void)configPopoverController;
+ (void)application:(UIApplication *)application openURL:(NSURL *)url;

@end
