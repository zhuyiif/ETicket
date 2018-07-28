//
//  ETMineHeaderView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/25.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETMineHeaderView.h"
#import "ETMineSummaryView.h"

@interface ETMineHeaderView ()

@property (nonatomic) UILabel *nickNameLabel;
@property (nonatomic) UIImageView *avatorView;
@property (nonatomic) UIImageView *avatorBGView;
@property (nonatomic) UIImageView *vipIcon;
@property (nonatomic) UIImageView *bgView;
@property (nonatomic) ETMineSummaryView *summaryView;

@end

@implementation ETMineHeaderView

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
    
    self.loginButton = [UIButton new];
    self.loginButton.backgroundColor = [UIColor clearColor];
    [self.loginButton setImage:[UIImage imageNamed:@"mineHeaderLoginNor"] forState:UIControlStateNormal];
    [self.loginButton setImage:[UIImage imageNamed:@"mineHeaderLoginPress"] forState:UIControlStateHighlighted];
    [self addSubview:self.loginButton];
    self.loginButton.hidden = YES;
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(108);
        make.width.height.equalTo(@56);
    }];
}

- (void)updateStyle:(BOOL)logined {
    if (logined) {
        self.loginButton.hidden = YES;
        self.vipIcon.hidden = self.avatorView.hidden = self.nickNameLabel.hidden = self.avatorBGView.hidden = NO;
        self.summaryView.bgView.image = [UIImage imageNamed:@"mineSummaryBG1"];
        self.bgView.image = [UIImage imageNamed:@"mineHeaderBG1"];
    } else {
        self.loginButton.hidden = NO;
        self.vipIcon.hidden = self.avatorView.hidden = self.nickNameLabel.hidden = self.avatorBGView.hidden = YES;
        self.summaryView.bgView.image = [UIImage imageNamed:@"mineSummaryBG0"];
        self.bgView.image = [UIImage imageNamed:@"mineHeaderBG0"];
    }
}

@end
