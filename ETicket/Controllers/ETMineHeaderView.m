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
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth));
    }];
    self.bgView = [UIImageView new];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.image = [UIImage imageNamed:@"mineHeaderBG1"];
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self);
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
    
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.font = [UIFont fontWithSize:12];
    self.nickNameLabel.textColor = [UIColor white2];
    self.nickNameLabel.backgroundColor = [UIColor clearColor];
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.avatorBGView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatorBGView).offset(3);
        make.centerX.equalTo(self.avatorBGView);
        make.width.equalTo(@84);
        make.height.equalTo(@17);
    }];
    
    self.avatorView = [UIImageView new];
    self.avatorView.backgroundColor = [UIColor clearColor];
    self.avatorView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorView.image = [UIImage imageNamed:@"homeMidImage"];
    self.avatorView.clipsToBounds = YES;
    self.avatorView.layer.cornerRadius = 16;
    self.avatorView.layer.borderColor = [UIColor white].CGColor;
    self.avatorView.layer.borderWidth = 2;
    self.avatorBGView.userInteractionEnabled = YES;
    [self.avatorBGView addSubview:self.avatorView];
    [self.avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@32);
        make.bottom.equalTo(self.avatorBGView).offset(-6);
        make.centerX.equalTo(self.avatorBGView);
    }];
    
    self.vipIcon = [UIImageView new];
    self.vipIcon.backgroundColor = [UIColor clearColor];
    self.vipIcon.image = [UIImage imageNamed:@"vip10"];
    [self addSubview:self.vipIcon];
    [self.vipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(86);
        make.right.equalTo(self).offset(-101);
    }];
    
    
    self.avatorButton = [UIButton new];
    self.avatorButton.backgroundColor = [UIColor clearColor];
    [self.avatorBGView addSubview:self.avatorButton];
    [self.avatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.avatorBGView);
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

    [[self.loginButton eventSingal] subscribeNext:^(id x) {
        [[[ETActor instance] showLogin] subscribeNext:^(id x) {
            
        }];
    }];
}

- (void)updateStyle:(BOOL)logined {
    if (logined) {
        self.loginButton.hidden = YES;
        self.vipIcon.hidden = self.avatorView.hidden = self.nickNameLabel.hidden = self.avatorBGView.hidden = NO;
        self.summaryView.bgView.image = [UIImage imageNamed:@"mineSummaryBG1"];
        self.bgView.image = [UIImage imageNamed:@"mineHeaderBG1"];
        self.nickNameLabel.text = [ETActor instance].user.phone;
    } else {
        self.loginButton.hidden = NO;
        self.vipIcon.hidden = self.avatorView.hidden = self.nickNameLabel.hidden = self.avatorBGView.hidden = YES;
        self.summaryView.bgView.image = [UIImage imageNamed:@"mineSummaryBG0"];
        self.bgView.image = [UIImage imageNamed:@"mineHeaderBG0"];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
