//
//  ETAlertView.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAlertView : SCLAlertView


+ (instancetype)noticeAlertView;
+ (instancetype)successAlertView;
+ (instancetype)errorAlertView;

@end
