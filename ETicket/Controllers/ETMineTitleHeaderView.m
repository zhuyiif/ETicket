//
//  ETMineTitleHeaderView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/20.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETMineTitleHeaderView.h"

@interface ETMineTitleHeaderView ()

@property (nonatomic) UIControl *actionControl;

@end

@implementation ETMineTitleHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor drColorC0];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.leftLabel = [UILabel new];
    self.leftLabel.font = [UIFont fontWithSize:16];
    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.textColor = [UIColor black];
    self.leftLabel.text = @"我的行程";
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(12);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    UIImageView *arrowIcon = [UIImageView new];
    arrowIcon.backgroundColor = [UIColor clearColor];
    arrowIcon.image = [UIImage imageNamed:@"arrowGrey"];
    [self addSubview:arrowIcon];
    [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
    }];
    
    self.rightLabel = [UILabel new];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.font = [UIFont s02Font];
    self.rightLabel.textColor = [UIColor warmGrey];
    self.rightLabel.text = @"全部行程";
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(arrowIcon.mas_left).offset(-4);
    }];
    
    self.actionControl = [UIControl new];
    self.actionControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.actionControl];
    [self.actionControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.rightLabel);
        make.top.bottom.equalTo(self);
    }];
}

- (RACSignal *)actionSignal {
    return [self.actionControl rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
