//
//  UITableView+iOS11.m
//  ETicket
//
//  Created by xiaomang on 2017/9/19.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import "UITableView+iOS11.h"
#import "SwizzleMethod.h"

@implementation UITableView (iOS11)

- (instancetype)swizzle_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    UITableView *tableView = [self swizzle_initWithFrame:frame style:style];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.estimatedSectionHeaderHeight = 0.0f;
        self.estimatedSectionFooterHeight = 0.0f;
    }
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    return tableView;
}

+ (void)load {
    [SwizzleMethod swizzleMethod:[self class] originalSelector:@selector(initWithFrame:style:) swizzledSelector:@selector(swizzle_initWithFrame:style:)];
}

@end
