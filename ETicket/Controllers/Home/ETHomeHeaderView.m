//
//  ETHomeHeaderView.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/3.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHomeHeaderView.h"


@interface ETHomeHeaderView () <ETHotViewDelegate>

@property (nonatomic) UIStackView *stackView;
@property (nonatomic) NSMutableArray *hotItems;
@property (nonatomic) UIView *midCoverView;

@end

@implementation ETHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    self.stackView = [UIStackView new];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.distribution = UIStackViewDistributionFill;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.spacing = 0;
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.bannerView = [ETHomeBannerView new];
    UIView *bannerBG = [UIView new];
    bannerBG.backgroundColor = [UIColor white2];
    [bannerBG addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bannerBG);
        make.height.equalTo(@(kScreenHeight * 0.35));
    }];
  
    [self.stackView addArrangedSubview:bannerBG];
    [self.stackView addArrangedSubview:self.hotView];
    self.announceView = [ETAnouncementScrollView new];
    [self.stackView addArrangedSubview:self.announceView];
    [self.stackView addArrangedSubview:self.cardView];
    [self.stackView addArrangedSubview:self.midCoverView];

}

- (ETHotView *)hotView {
    if (!_hotView) {
        _hotView = [ETHotView new];
        _hotView.delegate = self;
        [_hotView updateModels:self.hotItems];
    }
    return _hotView;
}

- (ETHomeCardView *)cardView {
    if (!_cardView) {
        _cardView = [ETHomeCardView new];
    }
    return _cardView;
}

- (UIView *)midCoverView {
    if (!_midCoverView) {
        _midCoverView = [UIView new];
        _midCoverView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
        self.midImageView = [UIImageView new];
        self.midImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.midImageView.image = [UIImage imageNamed:@"homeMidImage"];
        [_midCoverView addSubview:self.midImageView];
        [self.midImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_midCoverView).offset(10);
            make.right.equalTo(_midCoverView).offset(-10);
            make.top.equalTo(_midCoverView);
            make.height.equalTo(@((kScreenWidth - 20)*0.2));
            make.bottom.equalTo(_midCoverView).offset(-15);
        }];
    }
    return _midCoverView;
}

- (NSMutableArray *)hotItems {
    if (!_hotItems) {
        _hotItems = [NSMutableArray arrayWithCapacity:4];
        ETHotModel *model = [ETHotModel modelWithName:@"微互动" link:@"weInterface" image:@"weihudong"];
        [_hotItems addObject:model];
        ETHotModel *model1 = [ETHotModel modelWithName:@"线路查询" link:@"routeSearch" image:@"xianlu"];
        [_hotItems addObject:model1];
        ETHotModel *model2 = [ETHotModel modelWithName:@"时刻查询" link:@"timeSearch" image:@"shike"];
        [_hotItems addObject:model2];
        ETHotModel *model3 = [ETHotModel modelWithName:@"我的余额" link:@"banance" image:@"yue"];
        [_hotItems addObject:model3];
    }
    return _hotItems;
}

#pragma mark hotViewDelegate
- (void)hotView:(ETHotView *)hotView selectedItem:(ETHotModel *)model {
    
}

@end
