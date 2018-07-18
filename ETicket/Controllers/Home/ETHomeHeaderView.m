//
//  ETHomeHeaderView.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/3.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHomeHeaderView.h"
#import "ETHomeBannerView.h"
#import "ETAnouncementScrollView.h"
#import "ETHotView.h"

@interface ETHomeHeaderView () <ETHotViewDelegate>

@property (nonatomic) UIStackView *stackView;
@property (nonatomic) ETHomeBannerView *bannerView;
@property (nonatomic) ETAnouncementScrollView *announceView;
@property (nonatomic) ETHotView *hotView;
@property (nonatomic) NSMutableArray *hotItems;

@end

@implementation ETHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
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
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kScreenHeight * 0.35));
    }];
    [self.stackView addArrangedSubview:self.bannerView];
    [self.stackView addArrangedSubview:self.hotView];
    self.announceView = [ETAnouncementScrollView new];
    [self.announceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@36);
    }];
    [self.stackView addArrangedSubview:self.announceView];
}

- (ETHotView *)hotView {
    if (!_hotView) {
        _hotView = [ETHotView new];
        _hotView.delegate = self;
        [_hotView updateModels:self.hotItems];
    }
    return _hotView;
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
