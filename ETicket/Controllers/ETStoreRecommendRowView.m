//
//  ETStoreRecommendRowView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETStoreRecommendRowView.h"
#import "ETHomeNewsTVCell.h"

@interface ETStoreRecommendRowView ()

@property (nonnull) UIStackView *stackView;

@end

@implementation ETStoreRecommendRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor white2];
        UILabel *tipLabel = [UILabel new];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont fontWithSize:16];
        tipLabel.textColor = [UIColor black];
        tipLabel.text =  @"猜你喜欢";
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.top.equalTo(self).offset(15);
        }];
        
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [self addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).offset(15);
            make.height.equalTo(@1);
            make.left.right.equalTo(tipLabel);
        }];
        
        self.stackView = [UIStackView new];
        self.stackView.backgroundColor = [UIColor clearColor];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.distribution = UIStackViewDistributionFill;
        self.stackView.spacing = 0;
        [self addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(cutLine.mas_bottom).offset(0);
            make.bottom.equalTo(self).offset(-15);
        }];
        
        for (int i = 0; i < 10; i++) {
            ETHomeNewsTVCell *cell = [[ETHomeNewsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [self.stackView addArrangedSubview:cell];
        }
    }
    return self;
}

@end
