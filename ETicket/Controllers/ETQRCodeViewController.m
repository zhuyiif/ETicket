//
//  ETQRCodeViewController.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/3.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETQRCodeViewController.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "ETQRCodeView.h"
#import "UIButton+Style.h"
#import "TTTAttributedLabel+additions.h"

@interface ETQRCodeViewController ()<TTTAttributedLabelDelegate>

@property (nonatomic) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic) UIView *contentView;
@property (nonatomic) ETQRCodeView *qrCodeView;
@property (nonatomic) UIButton *refreshButton;
@property (nonatomic) TTTAttributedLabel *refLabel;

@end

@implementation ETQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"西安地铁", nil);
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view);
        }
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.qrCodeView updateSource:@"https://www-demo.dianrong.com/feapi/banners?page=1&rows=21&type=appV4Homepage1"];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        self.qrCodeView = [ETQRCodeView new];
        [_contentView addSubview:self.qrCodeView];
        [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(25);
            make.left.equalTo(_contentView).offset(45);
            make.right.equalTo(_contentView).offset(-45);
        }];
        
        [_contentView addSubview:self.refreshButton];
        [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qrCodeView.mas_bottom).offset(15);
            make.left.equalTo(self.qrCodeView).offset(25);
            make.right.equalTo(self.qrCodeView).offset(-25);
            make.height.equalTo(@38);
        }];
        
        [_contentView addSubview:self.refLabel];
        [self.refLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.qrCodeView);
            make.top.equalTo(self.refreshButton.mas_bottom).offset(15);
            make.bottom.equalTo(_contentView).offset(-15);
        }];
    }
    return _contentView;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithStyle:ETButtonStyleBlue height:38];
        [_refreshButton setTitle:NSLocalizedString(@"刷新二维码", nil) forState:UIControlStateNormal];
        @weakify(self);
        [[_refreshButton eventSingal] subscribeNext:^(id x) {
            @strongify(self);
        }];
    }
    return _refreshButton;
}

- (TTTAttributedLabel *)refLabel {
    if (!_refLabel) {
        _refLabel = [TTTAttributedLabel attributedWithLinkColor:[UIColor colorWithHex:0x18ADF3] activeLinkColor:[UIColor colorWithHex:0x666666] underLine:NO];
        _refLabel.textColor = [UIColor colorWithHex:0x666666];
        _refLabel.textAlignment = NSTextAlignmentCenter;
        _refLabel.text = NSLocalizedString(@"余额支付,更换 >", nil);
        [_refLabel addLinkToTransitInformation:@{@"type": @"change"} withRange:[_refLabel.text rangeOfString:NSLocalizedString(@",更换 >",nil)]];
        _refLabel.delegate = self;
    }
    return _refLabel;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if ([[components objectForKey:@"type"] isEqualToString:@"change"]) {
        
    }
}

@end
