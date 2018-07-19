//
//  ETHomeCardItemView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHomeCardItemView.h"

@implementation ETHomeCardItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHex:0xfffdfb];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.iconView = [UIImageView new];
    self.iconView.backgroundColor = [UIColor clearColor];
    self.iconView.image = [UIImage imageNamed:@"homeMidImage"];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.width.equalTo(@228);
        make.height.equalTo(@114);
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom);
        make.left.right.equalTo(self.iconView);
        make.height.equalTo(@90);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont s04Font];
    self.titleLabel.textColor = [UIColor teal];
    self.titleLabel.text = @"里程兑换";
    [bottomView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(12);
        make.right.equalTo(bottomView).offset(-12);
        make.top.equalTo(bottomView).offset(8);
    }];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont s03Font];
    self.contentLabel.numberOfLines = 2;
    self.contentLabel.textColor = [UIColor greyishBrown];
    self.contentLabel.text = @"中配置你中配置你中配置你你中配置你你中配置你你中配置你你中配置你";
    [bottomView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.bottom.lessThanOrEqualTo(bottomView).offset(-15);
    }];
    
    self.moreLabel = [UILabel new];
    self.moreLabel.font = [UIFont s02Font];
    self.moreLabel.textColor = [UIColor warmGrey];
    self.moreLabel.text = @"更多 >";
    [bottomView addSubview:self.moreLabel];
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView).offset(-12);
        make.bottom.equalTo(bottomView).offset(-4);
    }];
}

@end
