//
//  ETStoreFeatureRowView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETStoreFeatureRowView.h"

@implementation ETStoreFeatureRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor white2];
        UILabel *titleLabel = [UILabel new];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithSize:16];
        titleLabel.textColor = [UIColor black];
        titleLabel.text = @"特色";
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-12);
        }];
        
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [self addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(15);
            make.height.equalTo(@1);
            make.left.right.equalTo(titleLabel);
        }];
        self.contentLabel = [UILabel new];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont s04Font];
        self.contentLabel.textColor = [UIColor greyishBrown];
        self.contentLabel.numberOfLines = 3;
        self.contentLabel.userInteractionEnabled = YES;
        self.contentLabel.text = @"    园区各景点每天上演各种精彩节目，包括祈天鼓舞、“教坊乐舞”宫廷演出、“艳影霓裳”服饰表演、少林武术表演、舞狮、高跷园区各景点每天上演各种精彩节目，包括祈天鼓舞、“教坊乐舞”宫廷演出、“艳影霓裳”服饰表演、少林武术表演、舞狮、高跷园区各景点每天上演各种精彩节目，包括祈天鼓舞、“教坊乐舞”宫廷演出、“艳影霓裳”服饰表演、少林武术表演、舞狮、高跷园区各景点每天上演各种精彩节目，包括祈天鼓舞、“教坊乐舞”宫廷演出、“艳影霓裳”服饰表演、少林武术表演、舞狮、高跷园区各景点每天上演各种精彩节目，包括祈天鼓舞、“教坊乐舞”宫廷演出、“艳影霓裳”服饰表演、少林武术表演、舞狮、高跷园区各景点每天上演各种精彩节目，包括祈天鼓舞、“教坊乐舞”宫廷演出、“艳影霓裳”服饰表演、少林武术表演、舞狮、高跷";
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cutLine);
            make.top.equalTo(cutLine.mas_bottom).offset(15);
            make.bottom.equalTo(self).offset(-15);
        }];
        @weakify(self);
        [self.contentLabel bk_whenTapped:^{
            @strongify(self);
            self.contentLabel.numberOfLines = self.contentLabel.numberOfLines > 0 ? 0 : 3;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    }
    return self;
}

@end
