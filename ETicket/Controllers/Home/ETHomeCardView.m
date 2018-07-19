//
//  ETHomeCardView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHomeCardView.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "ETHomeCardItemView.h"

@interface ETHomeCardView ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *iconLabel;
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UIScrollView *scrollView;

@end

@implementation ETHomeCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithSize:22];
    self.titleLabel.textColor = [UIColor black];
    self.titleLabel.text = @"小幸福";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(24);
    }];
    
    self.iconLabel = [UILabel new];
    self.iconLabel.backgroundColor = [UIColor clearColor];
    self.iconLabel.font = [UIFont s06Font];
    self.iconLabel.textColor = [UIColor pumpkinOrange];
    self.iconLabel.text = @"HOT";
    [self addSubview:self.iconLabel];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.bottom.equalTo(self.titleLabel);
    }];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.bottom.equalTo(self).offset(-12);
        make.height.equalTo(@204);
    }];
    
    self.stackView = [UIStackView new];
    self.stackView.backgroundColor = [UIColor clearColor];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.distribution = UIStackViewDistributionFill;
    self.stackView.spacing = 8;
    [self.scrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    for (int i = 0; i < 5; i++) {
        [self.stackView addArrangedSubview:[ETHomeCardItemView new]];
    }
}

@end
