//
//  UIView+SepLine.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "UIView+SepLine.h"

@implementation UIView (SepLine)

- (void)setSepLineStyle:(UIViewAddSepLineStyle)sepLineStyle {
    if (sepLineStyle == UIViewAddSepLineStyleNone) {
        return;
    }
    if (sepLineStyle & UIViewAddSepLineStyleLeft) {
        UIView *v = [UIView new];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@.5);
            make.top.left.height.equalTo(self);
        }];
    }
    if (sepLineStyle & UIViewAddSepLineStyleRight) {
        UIView *v = [UIView new];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@.5);
            make.top.right.height.equalTo(self);
        }];
    }
    if (sepLineStyle & UIViewAddSepLineStyleTop) {
        UIView *v = [UIView new];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@.5);
            make.top.left.width.equalTo(self);
        }];
    }
    if (sepLineStyle & UIViewAddSepLineStyleBottom) {
        UIView *v = [UIView new];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@.5);
            make.bottom.left.width.equalTo(self);
        }];
    }
}

- (UIViewAddSepLineStyle)sepLineStyle {
    NSAssert(false, @"no support");
    return UIViewAddSepLineStyleNone;
}

@end
