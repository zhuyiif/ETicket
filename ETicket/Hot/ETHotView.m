//
//  ETHotView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHotView.h"
#import "ETHotItemView.h"

@interface ETHotView ()

@property (nonatomic) UIStackView *stackView;

@end

@implementation ETHotView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor drColorC0];
        self.stackView = [UIStackView new];
        self.stackView.backgroundColor = [UIColor clearColor];
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        self.stackView.spacing = 0;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        self.stackView.alignment = UIStackViewAlignmentFill;
        [self addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.bottom.top.equalTo(self);
        }];
    }
    return self;
}

- (void)updateModels:(NSArray<ETHotModel *> *)models {
    while (self.stackView.arrangedSubviews.count > 0) {
        [[self.stackView.arrangedSubviews lastObject] removeFromSuperview];
    }
    
    for (ETHotModel *model in models) {
        ETHotItemView *button = [ETHotItemView new];
        button.titleLabel.text = model.name;
        button.iconView.image = [UIImage imageNamed:model.imageName];
        @weakify(self);
        [[button eventSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate hotView:self selectedItem:model];
        }];
        [self.stackView addArrangedSubview:button];
    }
}

@end
