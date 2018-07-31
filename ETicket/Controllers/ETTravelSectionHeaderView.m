//
//  ETTravelSectionHeaderView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/31.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETTravelSectionHeaderView.h"

@implementation ETTravelSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor white2];
        
        UIView *line = [UIView new];
        line.backgroundColor = [[UIColor greyish] colorWithAlphaComponent:0.1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.width.equalTo(@1);
        }];
        
        UIView *dot = [UIView new];
        dot.backgroundColor = [UIColor white3];
        dot.clipsToBounds = YES;
        dot.layer.cornerRadius = 3;
        dot.layer.borderColor = [UIColor clearColor].CGColor;
        dot.layer.borderWidth = 1;
        [self addSubview:dot];
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(5);
            make.centerX.equalTo(line);
            make.bottom.equalTo(self).offset(-5);
            make.width.height.equalTo(@6);
        }];
        
        UIImageView *timeBG = [UIImageView new];
        timeBG.backgroundColor = [UIColor clearColor];
        timeBG.image = [UIImage imageNamed:@"travelTimeBg"];
        [self addSubview:timeBG];
        [timeBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@100);
            make.height.equalTo(@32);
            make.bottom.equalTo(dot);
            make.left.equalTo(line.mas_right).offset(12);
        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont fontWithSize:16];
        self.timeLabel.textColor = [UIColor white2];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.text = @"8月20日";
        [timeBG addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(timeBG);
            make.left.equalTo(timeBG).offset(15);
            make.right.equalTo(timeBG).offset(-15);
        }];
    }
    return self;
}

@end
