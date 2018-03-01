//
//  DSHomePresenter.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSHomePresenter.h"

@implementation DSHomePresenter

- (void)setupRequestWithController:(UIViewController *)controller {
    @weakify(self);
    [controller showHeaderWithQueries:@[[APICenter getBanner:@{@"type": @"appV4Homepage1"}]] contentHandler:^(RACTuple *content) {
        @strongify(self);
        self.banners = ((NSDictionary *)content.first).items;
    }];
}

@end
