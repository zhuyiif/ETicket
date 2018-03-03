//
//  ETQRCodeView.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/3.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETQRCodeView.h"

@interface ETQRCodeView ()

@property (nonatomic) NSString *soucreCode;
@property (nonatomic) UIImageView *qrImageView;

@end

@implementation ETQRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithSize:18];
    titleLabel.textColor = [UIColor colorWithHex:0x18ADF3];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"二维码乘车", nil);
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    self.qrImageView = [UIImageView new];
    self.qrImageView.backgroundColor = [UIColor clearColor];
    self.qrImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.qrImageView];
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.equalTo(self.mas_width);
        make.left.right.equalTo(self);
    }];
    
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont fontWithSize:14];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.textColor = [UIColor colorWithHex:0x999999];
    descriptionLabel.text = NSLocalizedString(@"乘车码每分钟自动刷新，请勿泄露给他人", nil);
    [self addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrImageView.mas_bottom).offset(10);
        make.left.right.equalTo(self.qrImageView);
        make.bottom.equalTo(self);
    }];
}

- (void)updateSource:(NSString *)source {
    self.soucreCode = source;
    self.qrImageView.image = [ETUtils generateQRCodeImage:source];
}

@end
