//
//  UIViewController+Shadow.m
//  ETicket
//
//  Created by chunjian wang on 2018/5/4.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "UIViewController+Shadow.h"
#import "SwizzleMethod.h"

@interface UIViewController ()

@property (nonatomic) BOOL showShadowImage;
@property (nonatomic) BOOL isShowShadow;
@property (nonatomic) BOOL isInit;

@end

@implementation UIViewController(Shadow)

+ (void)load {
    [SwizzleMethod swizzleMethod:[self class] originalSelector:@selector(viewWillAppear:) swizzledSelector:@selector(swizzle_viewWillAppearS:)];
}

- (void)swizzle_viewWillAppearS:(BOOL)animated {
    if ([self respondsToSelector:@selector(swizzle_viewWillAppearS:)]) {
        [self initialState];
    }
}

- (void)initialState {
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self _contentView] && [self enableShadowImage]) {
        if (!self.isInit) {
            self.isInit = YES;
            [self notifyWhenOffsetYChanged];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGPoint point = [self _contentView].contentOffset;
            self.showShadowImage = point.y >= 1;
            self.isShowShadow = !self.showShadowImage;
            [self handleShaowImage];
        });
    }
}

- (void)notifyWhenOffsetYChanged {
    RAC(self, showShadowImage) = [RACObserve([self _contentView], contentOffset) flattenMap:^RACStream *(id value) {
        CGPoint point;
        [value getValue:&point];
        return [RACSignal return:@(point.y >= 1)] ;
    }];
    @weakify(self);
    [RACObserve(self, showShadowImage) subscribeNext:^(id x) {
        @strongify(self);
        [self handleShaowImage];
    }];
}

- (void)handleShaowImage {
    if (self.showShadowImage) {
        if (!self.isShowShadow) {
            [self setupShadowImage];
            self.isShowShadow = YES;
        }
    } else {
        if (self.isShowShadow) {
            [self setupNoShadowImage];
            self.isShowShadow = NO;
        }
    }
}

- (BOOL)enableShadowImage {
    return self.navigationController != nil;
}

- (void)setupShadowImage {
    CGSize size = self.navigationController.navigationBar.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    CGContextRef context  = UIGraphicsGetCurrentContext();
    [[[UIColor blackColor] colorWithAlphaComponent:0.05] setFill];
    CGContextAddRect(context, CGRectMake(0, 0, size.width, 1));
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
}

- (void)setupNoShadowImage {
    CGSize size = self.navigationController.navigationBar.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    CGContextRef context  = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextAddRect(context, CGRectMake(0, 0, size.width, 1));
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
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

- (BOOL)showShadowImage {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setShowShadowImage:(BOOL)showShadowImage {
    if (showShadowImage == self.showShadowImage) {
        return;
    }
    [self willChangeValueForKey:@"showShadowImage"];
    objc_setAssociatedObject(self, @selector(showShadowImage), @(showShadowImage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"showShadowImage"];
}

- (BOOL)isShowShadow {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsShowShadow:(BOOL)isShowShadow {
    objc_setAssociatedObject(self, @selector(isShowShadow), @(isShowShadow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isInit {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void) setIsInit:(BOOL)isInit {
    objc_setAssociatedObject(self, @selector(isInit), @(isInit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
