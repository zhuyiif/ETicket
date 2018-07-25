//
//  ETMineLoginHeaderView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/25.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETMineLoginHeaderView.h"
#import "ETMineSummaryView.h"

@interface ETMineLoginHeaderView ()

@property (nonatomic) UILabel *nickNameLabel;
@property (nonatomic) UIImageView *avatorView;
@property (nonatomic) UIImageView *avatorBGView;
@property (nonatomic) UIImageView *vipIcon;
@property (nonatomic) UIImageView *bgView;
@property (nonatomic) ETMineSummaryView *summaryView;

@end

@implementation ETMineLoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.bgView = [UIImageView new];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.image = [UIImage imageNamed:@"mineHeaderBG1"];
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-60 * PIXEL_SCALE);
    }];
    
    self.summaryView = [ETMineSummaryView new];
    [self addSubview:self.summaryView];
    [self.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
    }];

    
    self.avatorBGView = [UIImageView new];
    self.avatorBGView.backgroundColor = [UIColor clearColor];
    self.avatorBGView.image = [UIImage imageNamed:@"nickNameBG1"];
    [self addSubview:self.avatorBGView];
    [self.avatorBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@113);
        make.height.equalTo(@70);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(37);
    }];
    
    self.vipIcon = [UIImageView new];
    self.vipIcon.backgroundColor = [UIColor clearColor];
    self.vipIcon.image = [UIImage imageNamed:@"vip10"];
    [self addSubview:self.vipIcon];
    [self.vipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(86);
        make.right.equalTo(self).offset(-101);
    }];
}

@end
