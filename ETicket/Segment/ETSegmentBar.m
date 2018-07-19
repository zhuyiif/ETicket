//
//  ETSegmentBar.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/19.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETSegmentBar.h"
#import "ETSegmentItem.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface ETSegmentBar()

@property (nonatomic) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic) UIStackView *stackView;

@end

@implementation ETSegmentBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.scrollView = [TPKeyboardAvoidingScrollView new];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@30);
    }];
    
    self.stackView = [UIStackView new];
    self.stackView.backgroundColor = [UIColor clearColor];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.distribution = UIStackViewDistributionFill;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.spacing = 20;
    [self.scrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}

- (void)updateWithModels:(NSArray<ETSegmentModel *> *)models {
    while (self.stackView.arrangedSubviews.count > 0) {
        [self.stackView.arrangedSubviews.lastObject removeFromSuperview];
    }
    
    for (ETSegmentModel *model in models) {
        ETSegmentItem *item = [ETSegmentItem new];
        item.titleLabel.text = model.title;
        [self.stackView addArrangedSubview:item];
        @weakify(self);
        @weakify(item);
        [[item rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            @strongify(item);
            if (item.selected) {
                return ;
            }
            for (ETSegmentItem *segItem in self.stackView.arrangedSubviews) {
                segItem.selected = NO;
            }
            item.selected = YES;
            [self.delegate onSegemnetBar:self itemSeleced:model];
        }];
    }
    
    if (self.stackView.arrangedSubviews.count > 0) {
        ETSegmentItem *item = [self.stackView.arrangedSubviews firstObject];
        [item sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

@end
