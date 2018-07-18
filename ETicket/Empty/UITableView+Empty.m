//
//  UITableView+Empty.m
//  ETicket
//
//  Created by chunjian wang on 2018/5/17.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "UITableView+Empty.h"
#import "UIViewController+Empty.h"
#import "SwizzleMethod.h"

#define kDisableEmptyView @"__kDisableEmptyView__"

@implementation UITableView (Empty)

- (void)setDisableEmptyView:(BOOL)disableEmptyView {
    [self bk_associateValue:@(disableEmptyView) withKey:kDisableEmptyView];
}

- (BOOL)disableEmptyView {
    return [[self bk_associatedValueForKey:kDisableEmptyView] boolValue];
}

- (void)swizzle_reloadData {
    [self swizzle_reloadData];
    if (self.disableEmptyView) {
        [self.viewController hideEmptyView];
        return;
    }
    
    NSInteger totalCount = 0;
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        totalCount += [self numberOfRowsInSection:section];
    }
    
    if (self.viewController.isNodata && totalCount == 0) {
        if (![self.viewController isLoading]) {
            [self.viewController showEmptyView];
        }
        return;
    }
    [self.viewController hideEmptyView];
}

+ (void)load {
    [SwizzleMethod swizzleMethod:[self class] originalSelector:@selector(reloadData) swizzledSelector:@selector(swizzle_reloadData)];
}

@end
