//
//  ETPlatformView.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETPlatformView : UIView

+ (instancetype)viewWithBlock:(void(^)(SSDKPlatformType platform))completeBlock;

@end
