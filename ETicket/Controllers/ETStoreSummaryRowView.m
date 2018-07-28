//
//  ETStoreSummaryRowView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETStoreSummaryRowView.h"

@interface ETStoreSummaryRowView()

@property (nonatomic) UIView *avgView;
@property (nonatomic) UIView *locationView;
@property (nonatomic) UIView *bannerContainer;

@end

@implementation ETStoreSummaryRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor white2];
        [self addSubview:self.bannerContainer];
        [self.bannerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];
        self.nameLabel = [UILabel new];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont fontWithSize:22];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.textColor = [UIColor black];
        self.nameLabel.text = @"大唐芙蓉园";
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.top.equalTo(self.bannerContainer.mas_bottom).offset(8);
            make.right.equalTo(self).offset(-12);
        }];
        
        self.summaryLabel = [UILabel new];
        self.summaryLabel.backgroundColor = [UIColor clearColor];
        self.summaryLabel.font = [UIFont fontWithSize:14 name:nil];
        self.summaryLabel.textColor = [UIColor greyishBrown];
        self.summaryLabel.numberOfLines = 2;
        self.summaryLabel.text = @"位于古都西安大雁塔之侧，是中国第一个全方位展示盛唐风貌的大型皇家园林式文…";
        [self addSubview:self.summaryLabel];
        [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
        }];
        
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [self addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.top.equalTo(self.summaryLabel.mas_bottom).offset(12);
            make.left.right.equalTo(self.nameLabel);
        }];
        [self addSubview:self.avgView];
        [self.avgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutLine.mas_bottom);
            make.left.right.equalTo(self);
        }];
        
        UIView *cutLine2 = [UIView new];
        cutLine2.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [self addSubview:cutLine2];
        [cutLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.top.equalTo(self.avgView.mas_bottom).offset(0);
            make.left.right.equalTo(self.nameLabel);
        }];
        
        [self addSubview:self.locationView];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.top.equalTo(cutLine2.mas_bottom);
        }];
    }
    return self;
}

- (UIView *)avgView {
    if (!_avgView) {
        _avgView = [UIView new];
        _avgView.backgroundColor = [UIColor clearColor];
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"storeAvgPriceIcon"];
        [_avgView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avgView).offset(12);
            make.centerY.equalTo(_avgView);
            make.width.equalTo(@20);
            make.height.equalTo(@22);
        }];
        UILabel *tipLabel = [UILabel new];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont fontWithSize:14];
        tipLabel.textColor = [UIColor greyishBrown];
        tipLabel.text = @"人均:";
        [_avgView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(5);
            make.top.equalTo(_avgView).offset(15);
            make.bottom.equalTo(_avgView).offset(-15);
            make.width.equalTo(@36);
        }];
        
        self.avgPriceLabel = [UILabel new];
        self.avgPriceLabel.backgroundColor = [UIColor clearColor];
        self.avgPriceLabel.font = [UIFont fontWithSize:14];
        self.avgPriceLabel.textColor = [UIColor greyishBrown];
        self.avgPriceLabel.text = @"178";
        [_avgView addSubview:self.avgPriceLabel];
        [self.avgPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(3);
            make.centerY.equalTo(_avgView);
            make.right.equalTo(_avgView).offset(-12);
        }];
    }
    return _avgView;
}

- (UIView *)locationView {
    if (!_locationView) {
        _locationView = [UIView new];
        _locationView.backgroundColor = [UIColor clearColor];
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"storeLocationIcon"];
        [_locationView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_locationView).offset(12);
            make.top.equalTo(_locationView).offset(15);
            make.width.equalTo(@20);
            make.height.equalTo(@22);
        }];
        UILabel *tipLabel = [UILabel new];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont fontWithSize:14];
        tipLabel.textColor = [UIColor greyishBrown];
        tipLabel.text = @"地址:";
        [_locationView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(5);
            make.top.equalTo(_locationView).offset(15);
            make.bottom.lessThanOrEqualTo(_locationView).offset(-15);
            make.width.equalTo(@36);
        }];
        
        self.addressLabel = [UILabel new];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.font = [UIFont fontWithSize:14];
        self.addressLabel.textColor = [UIColor greyishBrown];
        self.addressLabel.text = @"西安市雁塔区曲江新区芙蓉西路99号";
        self.addressLabel.numberOfLines = 0;
        [_locationView addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(3);
            make.top.equalTo(tipLabel);
            make.bottom.lessThanOrEqualTo(_locationView).offset(-15);
        }];
        
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [_locationView addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.addressLabel);
            make.width.equalTo(@1);
            make.left.equalTo(self.addressLabel.mas_right).offset(10);
        }];
        
        self.phoneButton = [UIButton new];
        self.phoneButton.backgroundColor = [UIColor clearColor];
        [self.phoneButton setImage:[UIImage imageNamed:@"storePhoneIcon"] forState:UIControlStateNormal];
        [_locationView addSubview:self.phoneButton];
        [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.addressLabel);
            make.left.equalTo(cutLine.mas_right).offset(10);
            make.right.equalTo(_locationView).offset(-12);
            make.width.equalTo(@60);
        }];
    }
    return _locationView;
}

- (UIView *)bannerContainer {
    if (!_bannerContainer) {
        _bannerContainer = [UIView new];
        _bannerContainer.backgroundColor = [UIColor white2];
        self.bannerView = [ETBannerScrollView new];
        self.bannerView.isHorizontal = YES;
        [_bannerContainer addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bannerContainer);
            make.height.equalTo(@(188 *PIXEL_SCALE));
        }];
        
        _bannerContainer.clipsToBounds = YES;
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor white2];
        bottomView.clipsToBounds = YES;
        bottomView.layer.cornerRadius = 10;
        bottomView.layer.borderColor = [UIColor clearColor].CGColor;
        bottomView.layer.borderWidth = 1.0f;
        [_bannerContainer addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bannerContainer.mas_bottom);
            make.left.right.equalTo(_bannerContainer);
            make.height.equalTo(@20);
        }];
    }
    return _bannerContainer;
}

@end
