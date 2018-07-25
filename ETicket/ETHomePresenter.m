//
//  ETHomePresenter.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETHomePresenter.h"

@implementation ETHomePresenter

- (void)setupRequestWithController:(UIViewController *)controller {
    @weakify(self);
    [controller showHeaderWithQueries:@[[APICenter getBanner:nil],[APICenter getAnnounces:nil]] contentHandler:^(RACTuple *content) {
        @strongify(self);
        self.banners = ((NSDictionary *)content.first).items;
        self.announces = [(NSDictionary *)content.second items];
    }];
}

@end
