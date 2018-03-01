//
//  UIViewController+Query.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "UIViewController+Query.h"
#import "UIScrollView+Refresh.h"
static NSString * const kCommandList = @"__commond_list__";

@interface UIViewController(query)

@end

@implementation UIViewController (Query)

#pragma mark -
- (void)reload {
    [[self _scrollView].mj_header beginRefreshing];
}

- (void)reloadIfNeeded {
    NSDate *lastRefresh = objc_getAssociatedObject(self, _cmd);
    if (!lastRefresh || [lastRefresh timeIntervalSinceNow] < -30) { // 0.5 minitues
        [self reload];
        objc_setAssociatedObject(self, _cmd, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void (^)(NSError *))errorHandler {
    return ^(NSError *error) {
        if (error.code == kNetworkErrorCode) {
            return ;
        }
        [DSPopover showFailureWithContent:[error message]];
    };
}

// private
- (UIScrollView *)_scrollView {
    if ([self respondsToSelector:@selector(tableView)]) {
        return [(id)self tableView];
    }
    if ([self respondsToSelector:@selector(collectionView)]) {
        return [(id)self collectionView];
    }
    if ([self respondsToSelector:@selector(scrollView)]) {
        return [(id)self scrollView];
    }
    NSAssert(NO, @"not supported");
    return nil;
}

- (void)setCommandList:(NSMutableArray *)commandList {
    if (commandList) {
        objc_setAssociatedObject(self, &kCommandList, commandList, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    }
}

- (NSMutableArray *)commandList {
    NSMutableArray * commandList  = objc_getAssociatedObject(self, &kCommandList);
    if (commandList == nil) {
        commandList = [NSMutableArray new];
    }
    return commandList;
}

#pragma mark - 使用缺省错误处理
- (RACCommand *)showHeaderWithQuery:(Query *)query contentHandler:(void (^)(id))contentHandler {
    return [self showHeaderWithQuery:query contentHandler:contentHandler errorHandler:self.errorHandler];
}

- (RACCommand *)showHeaderAndFooterWithQuery:(Query *)query contentHandler:(void (^)(id))contentHandler {
    return [self showHeaderAndFooterWithQuery:query contentHandler:contentHandler errorHandler:self.errorHandler];
}

- (RACCommand *)showHeaderWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id))contentHandler {
    return [self showHeaderWithQueries:queries contentHandler:contentHandler errorHandler:self.errorHandler];
}

- (RACCommand *)showHeaderAndFooterWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id))contentHandler {
    return [self showHeaderAndFooterWithQueries:queries contentHandler:contentHandler errorHandler:self.errorHandler];
}

#pragma mark - 定制错误处理
- (RACCommand *)showHeaderWithQuery:(Query *)query contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    return [self showHeaderWithCommand:[RACCommand commandWithQuery:query until:self.rac_willDeallocSignal] contentHandler:contentHandler errorHandler:errorHandler];
}

- (RACCommand *)showHeaderAndFooterWithQuery:(Query *)query contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    return [self showRefreshWithCommand:[RACCommand commandWithQuery:query until:self.rac_willDeallocSignal] contentHandler:contentHandler errorHandler:errorHandler];
}

- (RACCommand *)showHeaderWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    return [self showHeaderWithCommand:[RACCommand commandWithQueries:queries until:self.rac_willDeallocSignal] contentHandler:contentHandler errorHandler:errorHandler];
}

- (RACCommand *)showHeaderAndFooterWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    return [self showRefreshWithCommand:[RACCommand commandWithQueries:queries until:self.rac_willDeallocSignal] contentHandler:contentHandler errorHandler:errorHandler];
}

#pragma mark - 实现
- (RACCommand *)showHeaderWithCommand:(RACCommand *)cmd contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    [[[self _scrollView] showHeaderWithCommand:cmd] subscribeNext:contentHandler];
    [cmd.errors subscribeNext:errorHandler];
    return cmd;
}

- (RACCommand *)showRefreshWithCommand:(RACCommand *)cmd contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    [[[self _scrollView] showHeaderAndFooterWithCommand:cmd] subscribeNext:contentHandler];
    [cmd.errors subscribeNext:errorHandler];
    return cmd;
}

@end
