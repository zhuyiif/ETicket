//
//  ETSegmentItem.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/19.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETSegmentItem.h"

@interface ETSegmentItem ()

@property (nonatomic) UIView *lineView;

@end

@implementation ETSegmentItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor pumpkinOrange];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-6);
            make.height.equalTo(@2);
        }];
        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        [self updateTitleStyle];
        
        @weakify(self);
        [RACObserve(self, selected) subscribeNext:^(id x) {
            @strongify(self);
            [self updateTitleStyle];
        }];
    }
    return self;
}

- (void)updateTitleStyle {
    if (self.selected) {
        self.lineView.hidden = NO;
        self.titleLabel.font = [UIFont fontWithSize:22];
        self.titleLabel.textColor = [UIColor black];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(2);
            make.left.right.equalTo(self);
        }];
    } else {
        self.titleLabel.textColor = [UIColor greyishBrown];
        self.titleLabel.font = [UIFont s04Font];
        self.lineView.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
            make.left.right.equalTo(self);
        }];
    }
}

@end
