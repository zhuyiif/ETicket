//
//  UITabBar+Theme.m
//  SLMobile
//
//  Created by chunjian wang on 2017/4/13.
//  Copyright © 2017年 DianRong Information Technology Co.Ltd. All rights reserved.
//

#import "SwizzleMethod.h"
#import "UITabBar+Theme.h"

@implementation UITabBar (Theme)
+ (void)load {
//    [SwizzleMethod swizzleMethod:self originalSelector:@selector(layoutSubviews) swizzledSelector:@selector(swizzle_layoutSubviews)];
//    [SwizzleMethod swizzleMethod:self originalSelector:@selector(hitTest:withEvent:) swizzledSelector:@selector(swizzle_hitTest:withEvent:)];
//    [SwizzleMethod swizzleMethod:self originalSelector:@selector(touchesBegan:withEvent:) swizzledSelector:@selector(swizzle_touchesBegan:withEvent:)];
//    [SwizzleMethod swizzleMethod:self originalSelector:@selector(setSelectedItem:) swizzledSelector:@selector(swizzle_setSelectedItem:)];
}

- (NSMutableDictionary *)badgeValues {
    return objc_getAssociatedObject(self, @selector(badgeValues));
}

- (void)setBadgeValues:(NSMutableDictionary *)badgeValues {
    objc_setAssociatedObject(self, @selector(badgeValues), badgeValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)swizzle_layoutSubviews {
    [self swizzle_layoutSubviews];
    
    NSInteger index = 0;
    CGFloat space = 10;
    CGFloat tabBarButtonLabelHeight = 15;
    
    for (UIView *childView in self.subviews) {
        if (![childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            continue;
        }
        childView.backgroundColor = [UIColor clearColor];
        self.selectionIndicatorImage = [[UIImage alloc] init];
        
        UIView *tabBarImageView, *tabBarButtonLabel, *tabBarBadgeView;
        
        for (UIView *subView in childView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                tabBarImageView = subView;
            } else if ([subView isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
                tabBarButtonLabel = subView;
            } else if ([subView isKindOfClass:NSClassFromString(@"_UIBadgeView")]) {
                tabBarBadgeView = subView;
            }
        }
        NSString *tabBarButtonLabelText = ((UILabel *)tabBarButtonLabel).text;
        
        CGFloat realyHeight = (CGRectGetHeight(tabBarButtonLabel.bounds) + CGRectGetHeight(tabBarImageView.bounds) + ([NSString isNotBlank:tabBarButtonLabelText] ? space : tabBarButtonLabelHeight));
        
        CGFloat offSetY = CGRectGetHeight(self.bounds) - realyHeight + ([NSString isNotBlank:tabBarButtonLabelText] ? 0 : tabBarButtonLabelHeight);
        if (offSetY < 0) {
            childView.frame = CGRectMake(childView.frame.origin.x,offSetY,childView.frame.size.width,realyHeight);
        }
        
        CGFloat bandgeX = CGRectGetMaxX(childView.frame) - (CGRectGetWidth(childView.frame)) / 2 + 5;
        CGFloat bandgeY = offSetY < 0 ? CGRectGetMinY(childView.frame) + 10 : CGRectGetMinY(childView.frame) + 5;
        
        if (!self.badgeValues) {
            self.badgeValues = [NSMutableDictionary dictionary];
        }
        
        NSString *key = @(index).stringValue;
        UILabel *currentBadgeValue = self.badgeValues[key];
        tabBarBadgeView.layer.transform = CATransform3DIdentity;
        tabBarBadgeView.layer.transform = CATransform3DMakeTranslation(-17.0, 1.0, 1.0);
        tabBarBadgeView.hidden = YES;
        
        UILabel *oldLabel = [self oldBadgeLabelFromBadgeView:tabBarBadgeView];
        if (!currentBadgeValue) {
            currentBadgeValue = [self cloneBadgeViewWithOldBadge:tabBarBadgeView];
            self.badgeValues[key] = currentBadgeValue;
        }
        
        currentBadgeValue.text = oldLabel.text;
        CGSize size = [currentBadgeValue.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName: currentBadgeValue.font }
                                                           context:nil].size;
        CGFloat width = MAX(ceilf(size.width) + 10, CGRectGetHeight(currentBadgeValue.frame));
        currentBadgeValue.frame = CGRectMake(bandgeX, bandgeY, width, CGRectGetHeight(currentBadgeValue.frame));
        if(currentBadgeValue.text) {
            [self addSubview:currentBadgeValue];
        } else {
            [currentBadgeValue removeFromSuperview];
        }
        
        index++;
    }
}

- (UILabel *)oldBadgeLabelFromBadgeView:(UIView *)badgeView {
    UILabel *oldLabel;
    for (UIView *sView in badgeView.subviews) {
        if ([sView isKindOfClass:[UILabel class]]) {
            oldLabel = (UILabel *)sView;
        }
    }
    return oldLabel;
}

- (UILabel *)cloneBadgeViewWithOldBadge:(UIView *)badgeView {
    if (!badgeView) {
        return nil;
    }
    UILabel *oldLabel = [self oldBadgeLabelFromBadgeView:badgeView];
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.text = oldLabel.text;
    newLabel.font = oldLabel.font;
    CGSize size = [newLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: oldLabel.font } context:nil].size;
    newLabel.frame = CGRectMake(0, 0, ceilf(size.width) + 10, size.height + 2);
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.layer.masksToBounds = YES;
    newLabel.layer.cornerRadius = CGRectGetHeight(newLabel.frame) / 2;
    newLabel.textColor = [UIColor drColorC0];
    newLabel.backgroundColor = [UIColor drColorC6];
    newLabel.layer.borderWidth = 1;
    newLabel.layer.borderColor = [UIColor drColorC0].CGColor;
    return newLabel;
}

- (UIView *)swizzle_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        UIView *result = [super hitTest:point withEvent:event];
        if (result) {
            return result;
        }
        
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            if (CGRectContainsPoint(subview.frame, point)) {
                return subview;
            }
        }
    }
    return nil;
}
- (void)swizzle_setSelectedItem:(UITabBarItem *)selectedItem {
    [self swizzle_setSelectedItem:selectedItem];
    [self layoutSubviews];
}

- (void)swizzle_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self swizzle_touchesBegan:touches withEvent:event];
    
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    
    UITabBarController *tabBarController = [self tabBarController];
    if (!tabBarController) {
        return;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / tabBarController.viewControllers.count;
    NSUInteger clickIndex = ceilf(point.x) / ceilf(width);
    [[self tabBarController] setSelectedIndex:clickIndex];
}

- (UITabBarController *)tabBarController {
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)nextResponder;
        }
    }
    return nil;
}

@end
