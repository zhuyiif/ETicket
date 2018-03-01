//
//  DSAlertView.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSAlertView.h"

@implementation DSAlertView

+ (instancetype)noticeAlertView {
    DSAlertView *alertView = [[DSAlertView alloc] initWithNewWindowWidth:kScreenWidth * .75];
    alertView.backgroundViewColor = [UIColor drColorC1];
    alertView.customViewColor = [UIColor drColorC7];
    alertView.horizontalButtons = YES;
    return alertView;
}

+ (instancetype)successAlertView {
    DSAlertView *alertView = [[DSAlertView alloc] initWithNewWindowWidth:kScreenWidth * .75];
    alertView.backgroundViewColor = [UIColor drColorC1];
    alertView.customViewColor = [UIColor drColorC8];
    alertView.horizontalButtons = YES;
    [alertView removeTopCircle];
    return alertView;
}

+ (instancetype)errorAlertView {
    DSAlertView *alertView = [[DSAlertView alloc] initWithNewWindowWidth:kScreenWidth * .75];
    alertView.backgroundViewColor = [UIColor drColorC1];
    alertView.customViewColor = [UIColor drColorC15];
    alertView.horizontalButtons = YES;
    return alertView;
}

@end
