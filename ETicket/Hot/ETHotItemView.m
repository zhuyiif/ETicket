//
//  ETHotItemView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHotItemView.h"

@implementation ETHotItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconView = [UIImageView new];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.iconView];
    CGFloat width = 56 * PIXEL_SCALE;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(width));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.left.greaterThanOrEqualTo(self).offset(5);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor greyishBrown];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self.iconView.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-5);
    }];
}

- (RACSignal *)eventSignal {
    return [self rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
