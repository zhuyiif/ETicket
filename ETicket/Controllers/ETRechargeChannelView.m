//
//  ETRechargeChannelView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETRechargeChannelView.h"

@implementation ETRechargeChannelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.iconView = [UIImageView new];
        self.iconView.backgroundColor = [UIColor clearColor];
        self.iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(16);
            make.top.equalTo(self).offset(16);
            make.bottom.equalTo(self).offset(-16);
            make.width.height.equalTo(@24);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithSize:14 name:nil];
        self.titleLabel.textColor = [UIColor greyishBrown];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.iconView.mas_right).offset(12);
        }];
        
        self.checkBoxButton = [UIButton new];
        self.checkBoxButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.checkBoxButton setImage:[UIImage imageNamed:@"checkboxNor"] forState:UIControlStateNormal];
        [self.checkBoxButton setImage:[UIImage imageNamed:@"checkboxSelected"] forState:UIControlStateSelected];
        [self addSubview:self.checkBoxButton];
        [self.checkBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-16);
            make.width.height.equalTo(@40);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
