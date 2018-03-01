//
//  UIViewController+ErrorView.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ErrorView)

- (void)showAssistWithStatus:(NSString *)errorMessage;

- (void)hideAssist;

@end
