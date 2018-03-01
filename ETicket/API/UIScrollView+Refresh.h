//
//  UIScrollView+Refresh.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Refresh)

/*
 创建一个 MJRefreshNormalHeader，下拉后触发 [command execute:nil]
 */
- (RACSignal *)showHeaderWithCommand:(RACCommand *)command;
- (RACSignal *)showHeaderAndFooterWithCommand:(RACCommand *)command;

@end

