//
//  UIScrollView+iOS11.m
//  ETicket
//
//  Created by chunjian wang on 2017/9/19.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import "UIScrollView+iOS11.h"
#import "SwizzleMethod.h"

@implementation UIScrollView (iOS11)

- (instancetype)swizzle_init {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    return [self swizzle_init];
}

+ (void)load {
    [SwizzleMethod swizzleMethod:[self class] originalSelector:@selector(init) swizzledSelector:@selector(swizzle_init)];
}

@end
