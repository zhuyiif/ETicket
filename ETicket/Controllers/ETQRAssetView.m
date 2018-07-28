//
//  ETQRAssetView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETQRAssetView.h"
#import "NSNumber+Format.h"

@implementation ETQRAssetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor veryLightPinkTwo];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *cutLine = [UIView new];
    cutLine.backgroundColor = [UIColor white2];
    [self addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(12);
        make.bottom.equalTo(self).offset(-12);
        make.width.equalTo(@1);
    }];
    
    UILabel *tipLabel1 = [UILabel new];
    tipLabel1.backgroundColor = [UIColor clearColor];
    tipLabel1.text = @"我的余额";
    tipLabel1.font = [UIFont fontWithSize:14 name:nil];
    tipLabel1.textColor = [UIColor warmGrey];
    tipLabel1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel1];
    [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(cutLine.mas_left).offset(-5);
        make.bottom.equalTo(cutLine);
    }];
    
    UILabel *tipLabel2 = [UILabel new];
    tipLabel2.backgroundColor = [UIColor clearColor];
    tipLabel2.text = @"历史行程";
    tipLabel2.font = [UIFont fontWithSize:14 name:nil];
    tipLabel2.textColor = [UIColor warmGrey];
    tipLabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel2];
    [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.left.equalTo(cutLine.mas_right).offset(5);
        make.bottom.equalTo(cutLine);
    }];
    
    self.balanceLabel = [UILabel new];
    self.balanceLabel.backgroundColor = [UIColor clearColor];
    self.balanceLabel.font = [UIFont fontWithSize:14];
    self.balanceLabel.textAlignment = NSTextAlignmentCenter;
    self.balanceLabel.textColor = [UIColor paleRed];
    [self addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tipLabel1);
        make.bottom.equalTo(tipLabel1.mas_top).offset(-8);
        make.top.equalTo(cutLine);
    }];
    
    self.mileageLabel = [UILabel new];
    self.mileageLabel.backgroundColor = [UIColor clearColor];
    self.mileageLabel.font = [UIFont fontWithSize:14];
    self.mileageLabel.textAlignment = NSTextAlignmentCenter;
    self.mileageLabel.textColor = [UIColor paleRed];
    [self addSubview:self.mileageLabel];
    [self.mileageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tipLabel2);
        make.bottom.equalTo(tipLabel2.mas_top).offset(-8);
        make.top.equalTo(cutLine);
    }];
}

- (void)updateWithBalance:(NSNumber *)balance miles:(NSNumber *)miles {
    self.mileageLabel.attributedText = [self attribeStringWithPrefx:[miles format0TN:2] hrex:@"km"];
    
    NSString *balanceString = [balance format2TN:2];
    NSArray *elements = [balanceString componentsSeparatedByString:@"."];
    self.balanceLabel.attributedText = [self attribeStringWithPrefx:elements[0] hrex:[NSString stringWithFormat:@".%@",elements[1]]];
}

- (NSAttributedString *)attribeStringWithPrefx:(NSString *)prefx hrex:(NSString *)hrex {
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:prefx attributes:@{NSFontAttributeName:[UIFont fontWithSize:20],NSForegroundColorAttributeName:[UIColor paleRed]}];
    NSAttributedString *hrexString = [[NSAttributedString alloc] initWithString:hrex attributes:@{NSFontAttributeName:[UIFont fontWithSize:14],NSForegroundColorAttributeName:[UIColor paleRed]}];
    [resultString appendAttributedString:hrexString];
    return resultString;
}

@end
