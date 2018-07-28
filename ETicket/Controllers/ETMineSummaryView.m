//
//  ETMineSummaryView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/25.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETMineSummaryView.h"
#import "NSNumber+Format.h"

@interface ETMineSummaryView ()


@end

@implementation ETMineSummaryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.bgView = [UIImageView new];
    self.bgView.image = [UIImage imageNamed:@"mineSummaryBG1"];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(@(100 * PIXEL_SCALE));
    }];
    
    UILabel *balanceTipLabel = [self tipLabelWithText:@"余额"];
    [self addSubview:balanceTipLabel];
    [balanceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-12);
        make.width.equalTo(self.mas_width).multipliedBy(0.33);
    }];
    
    self.balanceLabel = [self tipLabelWithText:@"1000.00"];
    [self addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(balanceTipLabel.mas_top).offset(-15);
        make.left.right.equalTo(balanceTipLabel);
    }];
    
    UIView *leftCutLine = [UIView new];
    leftCutLine.backgroundColor = [UIColor white2];
    [self addSubview:leftCutLine];
    [leftCutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(balanceTipLabel.mas_left);
        make.width.equalTo(@2);
        make.height.equalTo(@18);
        make.bottom.equalTo(self).offset(-14);
    }];
    
    UIView *rightCutLine = [UIView new];
    rightCutLine.backgroundColor = [UIColor white2];
    [self addSubview:rightCutLine];
    [rightCutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceTipLabel.mas_right);
        make.width.height.bottom.equalTo(leftCutLine);
    }];
    
    UILabel *honourTipLabel = [self tipLabelWithText:@"我的勋章"];
    [self addSubview:honourTipLabel];
    [honourTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightCutLine.mas_right);
        make.right.equalTo(self);
        make.centerY.equalTo(balanceTipLabel);
    }];
    self.honourLabel = [self tipLabelWithText:@"2枚"];
    [self addSubview:self.honourLabel];
    [self.honourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.balanceLabel);
        make.left.right.equalTo(honourTipLabel);
    }];
    
    UILabel *mileageTipLabel = [self tipLabelWithText:@"里程数"];
    [self addSubview:mileageTipLabel];
    [mileageTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(leftCutLine.mas_left);
        make.centerY.equalTo(balanceTipLabel);
    }];
    
    self.mileageLabel = [self tipLabelWithText:@"1000km"];
    [self addSubview:self.mileageLabel];
    [self.mileageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.balanceLabel);
        make.left.right.equalTo(mileageTipLabel);
    }];
}

- (UILabel *)tipLabelWithText:(NSString *)text {
    UILabel *balanceTipLabel = [UILabel new];
    balanceTipLabel.backgroundColor = [UIColor clearColor];
    balanceTipLabel.textAlignment = NSTextAlignmentCenter;
    balanceTipLabel.text = text;
    balanceTipLabel.font = [UIFont fontWithSize:14];
    balanceTipLabel.textColor = [UIColor white2];
    return balanceTipLabel;
}

- (void)updateWithMileage:(NSNumber *)mileage balance:(NSNumber *)balance honour:(NSNumber *)honour {
    self.mileageLabel.attributedText = [self attribeStringWithPrefx:[mileage format0TN:2] hrex:@"km"];
    self.honourLabel.attributedText = [self attribeStringWithPrefx:[honour format0TN:2] hrex:@"枚"];
    
    NSString *balanceString = [balance format2TN:2];
    NSArray *elements = [balanceString componentsSeparatedByString:@"."];
    self.balanceLabel.attributedText = [self attribeStringWithPrefx:elements[0] hrex:elements[1]];
}

- (NSAttributedString *)attribeStringWithPrefx:(NSString *)prefx hrex:(NSString *)hrex {
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:prefx attributes:@{NSFontAttributeName:[UIFont fontWithSize:20],NSForegroundColorAttributeName:[UIColor white2]}];
    NSAttributedString *hrexString = [[NSAttributedString alloc] initWithString:hrex attributes:@{NSFontAttributeName:[UIFont fontWithSize:14],NSForegroundColorAttributeName:[UIColor white2]}];
    [resultString appendAttributedString:hrexString];
    return resultString;
}

@end
