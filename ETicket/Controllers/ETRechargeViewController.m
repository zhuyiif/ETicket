//
//  ETRechargeViewController.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETRechargeViewController.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "ETRechargeAmountView.h"
#import "UIBarButtonItem+Helper.h"
#import "ETRechargeChannelView.h"
#import "TTTAttributedLabel+additions.h"

@interface ETRechargeViewController ()<TTTAttributedLabelDelegate>

@property (nonatomic) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) ETRechargeAmountView *amountView;
@property (nonatomic) ETRechargeChannelView *alipayView;
@property (nonatomic) ETRechargeChannelView *wechatView;
@property (nonatomic) TTTAttributedLabel *protocolLabel;
@property (nonatomic) UIView *footerView;
@property (nonatomic) UIButton *commitButton;

@end

@implementation ETRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额充值";
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor white2];
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
    }];
    self.scrollView = [TPKeyboardAvoidingScrollView new];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self bindEvents];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
        self.amountView = [ETRechargeAmountView new];
        [_containerView addSubview:self.amountView];
        [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_containerView);
        }];
        
        [_containerView addSubview:self.alipayView];
        [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_containerView);
            make.top.equalTo(self.amountView.mas_bottom).offset(0);
        }];
        
        [_containerView addSubview:self.wechatView];
        [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_containerView);
            make.top.equalTo(self.alipayView.mas_bottom).offset(0);
        }];
        
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [_containerView addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView).offset(16);
            make.right.equalTo(_containerView).offset(-16);
            make.top.equalTo(self.wechatView.mas_bottom).offset(10);
            make.height.equalTo(@1);
        }];
        
        [_containerView addSubview:self.protocolLabel];
        [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView).offset(16);
            make.right.equalTo(_containerView).offset(-16);
            make.top.equalTo(cutLine.mas_bottom).offset(10);
            make.bottom.equalTo(_containerView).offset(-10);
        }];
    }
    return _containerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor clearColor];
        UIImageView *bgView = [UIImageView new];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.clipsToBounds = YES;
        bgView.image = [UIImage imageNamed:@"footerBg"];
        [_footerView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView);
        }];
        
        UIButton *button = [UIButton buttonWithStyle:ETButtonStyleRed height:20];
        [button setTitle:@"充值" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithSize:16];
        [_footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView).offset(8);
            make.right.equalTo(_footerView).offset(-8);
            make.bottom.equalTo(_footerView).offset(-8);
            make.top.equalTo(_footerView).offset(10);
            make.height.equalTo(@40);
        }];
        self.commitButton = button;
    }
    return _footerView;
}

- (ETRechargeChannelView *)alipayView {
    if (!_alipayView) {
        _alipayView = [ETRechargeChannelView new];
        _alipayView.iconView.image = [UIImage imageNamed:@"rechargeAlipay"];
        _alipayView.titleLabel.text = @"支付宝";
        _alipayView.checkBoxButton.selected = YES;
    }
    return _alipayView;
}

- (ETRechargeChannelView *)wechatView {
    if (!_wechatView) {
        _wechatView = [ETRechargeChannelView new];
        _wechatView.iconView.image = [UIImage imageNamed:@"rechargeWechat"];
        _wechatView.titleLabel.text = @"微信(暂未开通)";
        _wechatView.checkBoxButton.selected = NO;
        _wechatView.titleLabel.textColor = [UIColor greyish];
    }
    return _wechatView;
}

- (TTTAttributedLabel *)protocolLabel {
    if (!_protocolLabel) {
        _protocolLabel = [TTTAttributedLabel attributedWithLinkColor:[UIColor paleRed] activeLinkColor:[UIColor warmGrey] underLine:NO];
        _protocolLabel.textColor = [UIColor warmGrey];
        _protocolLabel.font = [UIFont s02Font];
        _protocolLabel.numberOfLines = 0;
        _protocolLabel.text = @"点击充值，即表示已阅读并同意 充值协议";
        [_protocolLabel addLinkToTransitInformation:@{@"type": @"protocol"} withRange:[_protocolLabel.text rangeOfString:NSLocalizedString(@"充值协议", nil)]];
        _protocolLabel.delegate = self;
    }
    return _protocolLabel;
}

-(void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(showHistory:) title:@"交易记录" isRight:YES];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont s04Font], NSForegroundColorAttributeName: [UIColor drColorC0]}];
}

- (void)showHistory:(UIButton *)button {
    
}

- (void)bindEvents {
    RAC(self.commitButton,enabled) = [self.amountView.textField.rac_textSignal map:^id(NSString *value) {
        return @([NSString isNotBlank:value] && [value isDigitalStr]);
    }];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    
}

@end
