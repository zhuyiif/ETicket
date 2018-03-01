//
//  UIScrollView+Refresh.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)

- (RACSignal *)showHeaderWithCommand:(RACCommand *)command {
    MJRefreshNormalHeader *header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [command execute:@{kPageKey: @(1),kPageSize:@(21)}];
    }];
    header.lastUpdatedTimeLabel.textColor = [UIColor colorWithHex:0x6a2f0f];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    header.stateLabel.textColor = [UIColor colorWithHex:0x6a2f0f];
    self.mj_header = header;

    @weakify(self);
    [[command.executing skip:1] subscribeNext:^(id x) {
        @strongify(self);
        if (![x boolValue]) {
            [self.mj_header endRefreshing];
        }
    }];

    return [command.executionSignals concat];
}

- (RACSignal *)showHeaderAndFooterWithCommand:(RACCommand *)command {
    @weakify(command);
    @weakify(self);
    return [[[self showHeaderWithCommand:command] accumulated] doNext:^(NSDictionary *x) {
        @strongify(self);
        if ([x isKindOfClass:[RACTuple class]]) { // 对于对多个请求的组合，只考虑第一个请求的分页
            x = [(RACTuple *)x first];
        }

        if (x.items.count < x.totalRecords) {
            if (self.mj_footer) {
                [self.mj_footer endRefreshing];
            } else { // 无条件重新创建逻辑上 okay 但 UI 上高度有抖动
                MJRefreshAutoNormalFooter *footer = [[MJRefreshAutoNormalFooter alloc] init];
                footer.stateLabel.textColor = [UIColor whiteColor];
                footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                self.mj_footer = footer;
            }

            long nextPage = x.page + 1;
            self.mj_footer.refreshingBlock =^{
                @strongify(command);
                [command execute:@{kPageKey: @(nextPage),kPageSize:@(21)}];
            };
        } else {
            [self.mj_footer endRefreshingWithNoMoreData];
            self.mj_footer = nil;
        }
    }];
}

@end
