//
//  ETAlertView.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETAlertView.h"

@implementation ETAlertView

+ (instancetype)noticeAlertView {
    ETAlertView *alertView = [[ETAlertView alloc] initWithNewWindowWidth:kScreenWidth * .75];
    alertView.backgroundViewColor = [UIColor white];
    alertView.customViewColor = [UIColor white];
    alertView.horizontalButtons = YES;
    alertView.showAnimationType =  SCLAlertViewShowAnimationFadeIn;
    alertView.backgroundType = SCLAlertViewBackgroundShadow;
    alertView.labelTitle.textColor = [UIColor greyishBrown];
    alertView.buttonFormatBlock = ^NSDictionary *{
        //backgroundColor, borderWidth, borderColor, textColor
        return @{@"backgroundColor":[UIColor appleGreen],@"borderColor":[UIColor clearColor],@"borderWidth":@(2),@"textColor":[UIColor white2]};
    };
    alertView.completeButtonFormatBlock = ^NSDictionary *{
        return @{@"backgroundColor":[UIColor tomato],@"borderColor":[UIColor clearColor],@"borderWidth":@(2),@"textColor":[UIColor white2]};
    };
    
    alertView.attributedFormatBlock = ^NSAttributedString *(NSString *value) {
        if ([NSString isNotBlank:value]) {
            return [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName:[UIFont s04Font],NSForegroundColorAttributeName:[UIColor greyishBrown]}];
        }
        return nil;
    };
    [alertView removeTopCircle];
    return alertView;
}

+ (instancetype)successAlertView {
    ETAlertView *alertView = [[ETAlertView alloc] initWithNewWindowWidth:kScreenWidth * .75];
    alertView.backgroundViewColor = [UIColor drColorC1];
    alertView.customViewColor = [UIColor drColorC8];
    alertView.horizontalButtons = YES;
    [alertView removeTopCircle];
    return alertView;
}

+ (instancetype)errorAlertView {
    ETAlertView *alertView = [[ETAlertView alloc] initWithNewWindowWidth:kScreenWidth * .75];
    alertView.backgroundViewColor = [UIColor drColorC1];
    alertView.customViewColor = [UIColor drColorC15];
    alertView.horizontalButtons = YES;
    return alertView;
}

@end
