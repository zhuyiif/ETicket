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
    titleLabel.font = [UIFont fontWithSize:14 name:nil];
    titleLabel.textColor = [UIColor greyishBrown];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = NSLocalizedString(@"二维码对准闸机扫描扣刷码进站", nil);
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    self.qrImageView = [UIImageView new];
    self.qrImageView.backgroundColor = [UIColor clearColor];
    self.qrImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.qrImageView];
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(24 * PIXEL_SCALE);
        make.height.equalTo(self.mas_width);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)updateSource:(NSString *)source {
    self.soucreCode = source;
    self.qrImageView.image = [ETUtils generateQRCodeWithContent:self.soucreCode qrcodeImageSize:200 centerSmallImage:[UIImage imageNamed:@"tabScanHight"] centerSmallImageSize:40];
}

@end
