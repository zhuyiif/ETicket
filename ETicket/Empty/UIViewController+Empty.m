//
//  UIViewController+Empty.m
//  ETicket
//
//  Created by chunjian wang on 2018/5/17.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "ETEmptyView.h"
#import "UIViewController+Empty.h"

#define kEmptyView @"__emptyView__"
#define kEnableLoadingView @"__enableLoadingView_"
#define kEmptyLoadingView @"__loadingView__"
#define kEmptyErrorView @"__emptyErrorView__"

#define kEmptyViewPosition @"__emptyViewPosition__"
#define kEmptyTableViewHeader @"__emptyTableViewHeader__"
#define kEmptyTableViewFooter @"__emptyTableViewFooter__"

@interface UIViewController ()

// private
- (UIScrollView *)_scrollView;

@end

@implementation UIViewController (Empty)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(reload)), class_getInstanceMethod(self, @selector(swizzle_reload)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(showHeaderWithCommand:contentHandler:errorHandler:)), class_getInstanceMethod(self, @selector(swizzle_showHeaderWithCommand:contentHandler:errorHandler:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(showHeaderAndFooterWithCommand:contentHandler:errorHandler:)), class_getInstanceMethod(self, @selector(swizzle_showHeaderAndFooterWithCommand:contentHandler:errorHandler:)));
}

- (void)swizzle_reload {
    self.isLoading = YES;
    if ([self _scrollView].mj_header.refreshingBlock) {
        [self _scrollView].mj_header.refreshingBlock();
    }
}

- (RACCommand *)swizzle_showHeaderWithCommand:(RACCommand *)cmd contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    @weakify(self);
    [[cmd.executing skip:1] subscribeNext:^(id x) {
        @strongify(self);
        if (![x boolValue]) {
            self.isLoading = NO;
        }
        
    }];
    
    return [self swizzle_showHeaderWithCommand:cmd contentHandler:^(id content) {
        @strongify(self);
        [self processContent:content completeHandler:contentHandler];
    } errorHandler:^(NSError *error) {
        @strongify(self);
        [self processError:error completeHandler:errorHandler];
    }];
}

- (RACCommand *)swizzle_showHeaderAndFooterWithCommand:(RACCommand *)cmd contentHandler:(void (^)(id))contentHandler errorHandler:(void (^)(NSError *))errorHandler {
    @weakify(self);
    [[cmd.executing skip:1] subscribeNext:^(id x) {
        @strongify(self);
        if (![x boolValue]) {
            self.isLoading = NO;
        }
    }];
    
    return [self swizzle_showHeaderAndFooterWithCommand:cmd contentHandler:^(id content) {
        @strongify(self);
        [self processContent:content completeHandler:contentHandler];
    } errorHandler:^(NSError *error) {
        @strongify(self);
        [self processError:error completeHandler:errorHandler];
    }];
}

- (void)processContent:(id)content completeHandler:(void (^)(id))completeHandler {
    self.isLoading = NO;
    [self hideErrorView];
    if (completeHandler) {
        completeHandler(content);
    }
}

- (void)processError:(NSError *)error completeHandler:(void (^)(NSError *))completeHandler {
    NSError *innerError = error;
    self.isLoading = NO;
    if ([ETUtils isNetworkError:error.code] || [ETUtils isServiceError:error.code]) {
        [self showErrorView:error.code];
        innerError = nil;
    } else {
        [self hideErrorView];
    }
    
    if (completeHandler) {
        completeHandler(innerError);
    }
}

#pragma mark Getter And Setter
- (UIView *)emptyView {
    UIView *emptyView = [self bk_associatedValueForKey:kEmptyView];
    if (emptyView) {
        return emptyView;
    }
    
    @weakify(self);
    emptyView = [[ETEmptyView alloc] initWithClickBlock:^{
        @strongify(self);
        [self reload];
    }];
    [self setEmptyView:emptyView];
    return emptyView;
}

- (void)setEmptyView:(UIView *)emptyView {
    if (emptyView) {
        [self bk_associateValue:emptyView withKey:kEmptyView];
    }
}

- (BOOL)isLoading {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        [self setIsLoading:YES];
        number = @1;
    }
    return [number boolValue];
}

- (void)setIsLoading:(BOOL)isLoading {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isLoading))];
    objc_setAssociatedObject(self, @selector(isLoading), @(isLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(isLoading))];
}

- (returnBoolBlock)isNodataBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIsNodataBlock:(returnBoolBlock)isNodataBlock {
    objc_setAssociatedObject(self, @selector(isNodataBlock), isNodataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isNodata {
    //默认没有数据
    return !self.isNodataBlock || self.isNodataBlock();
}

#pragma mark functions
- (void)prepareForShow {
    [self hideEmptyView];
    [self hideErrorView];
}

- (void)showEmptyView {
    if (self.errorView) {
        return;
    }
    UIView *view = self.emptyView;
    [self prepareForShow];
    UIScrollView *anchorView = [self _contentView];
    if (anchorView) {
        if (self.position == ETEmptyViewPositionNone) {
            [anchorView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(anchorView);
                make.left.equalTo(anchorView);
                make.height.equalTo(anchorView);
                make.width.equalTo(anchorView).offset(-(anchorView.contentInset.left + anchorView.contentInset.right));
            }];
        } else if (self.position == ETEmptyViewPositionTableViewHeader && [anchorView isKindOfClass:UITableView.class]){
            UITableView *tableView = (UITableView *)anchorView;
            [self bk_associateValue:tableView.tableHeaderView withKey:kEmptyTableViewHeader];
            tableView.tableHeaderView = view;
        } else if (self.position == ETEmptyViewPositionTableViewFooter && [anchorView isKindOfClass:UITableView.class]){
            UITableView *tableView = (UITableView *)anchorView;
            [self bk_associateValue:tableView.tableFooterView withKey:kEmptyTableViewFooter];
            tableView.tableFooterView = view;
        }
        anchorView.mj_footer = nil;
    } else {
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (BOOL)hideEmptyView {
    if (self.position == ETEmptyViewPositionTableViewHeader) {
        UITableView *tableView = (UITableView *)[self _contentView];
        if ([tableView.tableHeaderView isKindOfClass:ETEmptyView.class]) {
            tableView.tableHeaderView = [self bk_associatedValueForKey:kEmptyTableViewHeader];
        }
    } else if (self.position == ETEmptyViewPositionTableViewFooter) {
        UITableView *tableView = (UITableView *)[self _contentView];
        if ([tableView.tableFooterView isKindOfClass:ETEmptyView.class]) {
            tableView.tableFooterView = [self bk_associatedValueForKey:kEmptyTableViewFooter];
        }
    } else {
        [self hideView:self.emptyView];
    }
    return YES;
}

- (BOOL)hideView:(UIView *)view {
    if (!view) {
        return NO;
    }
    
    if (view && view.superview) {
        [view removeFromSuperview];
        return YES;
    }
    return NO;
}

- (void)setEmptyViewImageName:(NSString *)imageName title:(NSString *)title {
    if (imageName.length == 0) {
        return;
    }
    @weakify(self);
    if (title.length == 0) {
        title = NSLocalizedString(@"暂无记录",nil);
    }
    ETEmptyViewModel *model = [[ETEmptyViewModel alloc] initWithModel:@{kEmptyModelIconKey : imageName, kEmptyModelTitleKey : title}];
    UIView *emptyView = [[ETEmptyView alloc] initWithModel:model clickBlock:^{
        @strongify(self);
        [self reload];
    }];
    [self setEmptyView:emptyView];
}

- (void)setEmptyViewPositionOnTableView:(ETEmptyViewPosition)position {
    if ([self._contentView isKindOfClass:UITableView.class]) {
        [self bk_associateValue:@(position) withKey:kEmptyViewPosition];
    } else {
        [self bk_associateValue:@(ETEmptyViewPositionNone) withKey:kEmptyViewPosition];
    }
}

- (ETEmptyViewPosition)position {
    id positionId = [self bk_associatedValueForKey:kEmptyViewPosition];
    if (positionId && [self ._contentView isKindOfClass:UITableView.class]) {
        return (ETEmptyViewPosition)[positionId integerValue];
    }
    return ETEmptyViewPositionNone;
}

#pragma ErrorView
- (UIView *)errorView {
    return [self bk_associatedValueForKey:kEmptyErrorView];
}

- (void)hideErrorView {
    UIView *view = self.errorView;
    if (view) {
        [view removeFromSuperview];
        [self bk_associateValue:nil withKey:kEmptyErrorView];
    }
}

- (void)showErrorView:(NSInteger)errorCode {
    if (![[self _contentView] isKindOfClass:[UITableView class]]) {
        return;
    }
    
    NSInteger totalCount = 0;
    NSInteger sections =  ((UITableView *)[self _contentView]).numberOfSections;
    for (NSInteger section = 0; section < sections; section++) {
        totalCount += [(UITableView *)[self _contentView] numberOfRowsInSection:section];
    }
    
    if (!self.isNodata || totalCount > 0) {
        return;
    }
    [self prepareForShow];
    UIView *view = nil;
    if ([ETUtils isNetworkError:errorCode]) {
        view = [ETEmptyView networkErrorView];
    } else if ([ETUtils isServiceError:errorCode]) {
        view = [ETEmptyView serviceErrorView];
    }
    
    if (view) {
        [self bk_associateValue:view withKey:kEmptyErrorView];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (UIScrollView *)_contentView {
    if ([self respondsToSelector:@selector(tableView)]) {
        return [(id)self tableView];
    }
    if ([self respondsToSelector:@selector(collectionView)]) {
        return [(id)self collectionView];
    }
    if ([self respondsToSelector:@selector(scrollView)]) {
        return [(id)self scrollView];
    }
    
    return nil;
}

@end
