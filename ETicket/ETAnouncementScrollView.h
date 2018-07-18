//
//  ETAnouncementScrollView.h
//  ETicket
//
//  Created by chunjian wang on 2017/4/20.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAnouncementInfo.h"

@interface ETAnouncementScrollView : UIView

- (void)invalidate;
- (void)setAnouncements:(NSArray<ETAnouncementInfo *> *)items;

@end
