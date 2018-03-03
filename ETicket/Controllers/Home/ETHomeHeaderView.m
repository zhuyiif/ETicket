//
//  ETHomeHeaderView.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/3.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHomeHeaderView.h"

@interface ETHomeHeaderView ()

@property (nonatomic) UIControl *actionControl;

@end

@implementation ETHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithHex:0x18ADF3];
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.borderColor = [UIColor colorWithHex:0xe0e0e0].CGColor;
    contentView.clipsToBounds = YES;
    contentView.layer.borderWidth = 1.0f;
    contentView.layer.cornerRadius = 80.0f;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.bottom.equalTo(self).offset(-25);
        make.centerX.equalTo(self);
        make.height.width.equalTo(@160);
    }];
    
    UIView *iconArea = [UIView new];
    iconArea.backgroundColor = [UIColor clearColor];
    [contentView addSubview:iconArea];
    [iconArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contentView);
    }];

    UIImageView *scanIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanIcon"]];
    [iconArea addSubview:scanIcon];
    [scanIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@45);
        make.top.centerX.equalTo(iconArea);
        make.left.greaterThanOrEqualTo(iconArea).offset(10);
        make.right.lessThanOrEqualTo(iconArea).offset(-10);
    }];

    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.text = NSLocalizedString(@"扫码进/出站", nil);
    label.font = [UIFont fontWithSize:16];
    label.textColor = [UIColor colorWithHex:0x18ADF3];
    label.textAlignment = NSTextAlignmentCenter;
    [iconArea addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanIcon.mas_bottom).offset(10);
        make.left.greaterThanOrEqualTo(iconArea).offset(10);
        make.right.lessThanOrEqualTo(iconArea).offset(-10);
        make.bottom.equalTo(iconArea).offset(0);
    }];

    UIControl *actionControl = [UIControl new];
    [contentView addSubview:actionControl];
    [actionControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    self.actionControl = actionControl;
}

- (RACSignal *)actionSignal {
    return [self.actionControl rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
