//
//  ETStoreExtendRowView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETStoreExtendRowView.h"

@interface ETStoreExtendRowView ()

@property (nonatomic) UIView *categoryView;
@property (nonatomic) UIView *busniessView;

@end

@implementation ETStoreExtendRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor white2];
        [self addSubview:self.categoryView];
        [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];
        
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [self addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.top.equalTo(self.categoryView.mas_bottom).offset(0);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
        }];
        
        [self addSubview:self.busniessView];
        [self.busniessView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutLine.mas_bottom);
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UIView *)categoryView {
    if (!_categoryView) {
        _categoryView = [UIView new];
        _categoryView.backgroundColor = [UIColor clearColor];
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"storeCategory"];
        [_categoryView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_categoryView).offset(12);
            make.centerY.equalTo(_categoryView);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        UILabel *tipLabel = [UILabel new];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont fontWithSize:14];
        tipLabel.textColor = [UIColor greyishBrown];
        tipLabel.text = @"类型:";
        [_categoryView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(5);
            make.top.equalTo(_categoryView).offset(15);
            make.bottom.equalTo(_categoryView).offset(-15);
            make.width.equalTo(@36);
        }];
        
        self.categoryLabel = [UILabel new];
        self.categoryLabel.backgroundColor = [UIColor clearColor];
        self.categoryLabel.font = [UIFont fontWithSize:14];
        self.categoryLabel.textColor = [UIColor greyishBrown];
        self.categoryLabel.text = @"景点";
        [_categoryView addSubview:self.categoryLabel];
        [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(3);
            make.centerY.equalTo(_categoryView);
            make.right.equalTo(_categoryView).offset(-12);
        }];
    }
    return _categoryView;
}

- (UIView *)busniessView {
    if (!_busniessView) {
        _busniessView = [UIView new];
        _busniessView.backgroundColor = [UIColor clearColor];
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"storeOpenTimeIcon"];
        [_busniessView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_busniessView).offset(12);
            make.centerY.equalTo(_busniessView);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        UILabel *tipLabel = [UILabel new];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont fontWithSize:14];
        tipLabel.textColor = [UIColor greyishBrown];
        tipLabel.text = @"营业时间:";
        [_busniessView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(5);
            make.top.equalTo(_busniessView).offset(15);
            make.bottom.lessThanOrEqualTo(_busniessView).offset(-15);
            make.width.equalTo(@62);
        }];
        
        self.busniessTimeLabel = [UILabel new];
        self.busniessTimeLabel.backgroundColor = [UIColor clearColor];
        self.busniessTimeLabel.font = [UIFont fontWithSize:14];
        self.busniessTimeLabel.textColor = [UIColor greyishBrown];
        self.busniessTimeLabel.text = @"09:00-22:00,21:00停止入场";
        self.busniessTimeLabel.numberOfLines = 0;
        [_busniessView addSubview:self.busniessTimeLabel];
        [self.busniessTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(3);
            make.right.equalTo(_busniessView).offset(-12);
            make.top.equalTo(tipLabel);
            make.bottom.lessThanOrEqualTo(_busniessView).offset(-15);
        }];
    }
    return _busniessView;
}

@end
