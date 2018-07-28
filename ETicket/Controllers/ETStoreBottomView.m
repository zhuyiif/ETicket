//
//  ETStoreBottomView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETStoreBottomView.h"

@implementation ETStoreBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *bgView = [UIImageView new];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.clipsToBounds = YES;
        bgView.image = [UIImage imageNamed:@"footerBg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.backButton = [UIButton new];
        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        self.backButton.backgroundColor = [UIColor clearColor];
        [self.backButton setImage:[UIImage imageNamed:@"storeBackIcon"] forState:UIControlStateNormal];
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.backButton setTitleColor:[UIColor warmGrey] forState:UIControlStateNormal];
        [self addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.top.equalTo(self).offset(3);
            make.height.equalTo(@44);
        }];
        UIView *cutline = [UIView new];
        cutline.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [self addSubview:cutline];
        [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backButton.mas_right);
            make.width.equalTo(@1);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-5);
        }];
        
        self.shareButton = [UIButton new];
        self.shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        self.shareButton.backgroundColor = [UIColor clearColor];
        [self.shareButton setImage:[UIImage imageNamed:@"storeShareIcon"] forState:UIControlStateNormal];
        [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [self.shareButton setTitleColor:[UIColor warmGrey] forState:UIControlStateNormal];
        [self addSubview:self.shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.height.equalTo(self.backButton);
            make.right.equalTo(self);
        }];
        
        UIView *cutline2 = [UIView new];
        cutline2.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [self addSubview:cutline2];
        [cutline2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareButton.mas_left);
            make.width.equalTo(@1);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-5);
        }];
        
        self.likeButton = [UIButton new];
        self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        self.likeButton.backgroundColor = [UIColor clearColor];
        [self.likeButton setImage:[UIImage imageNamed:@"storeCollectionIcon"] forState:UIControlStateNormal];
        [self.likeButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor warmGrey] forState:UIControlStateNormal];
        [self addSubview:self.likeButton];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.height.equalTo(self.backButton);
            make.right.equalTo(cutline2.mas_left);
            make.left.equalTo(cutline.mas_right);
        }];
    }
    return self;
}

@end
