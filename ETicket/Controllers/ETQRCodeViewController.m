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
#import "UIBarButtonItem+Helper.h"
#import "ETQRAssetView.h"
#import "ETQRCodePresenter.h"

@interface ETQRCodeViewController ()

@property (nonatomic) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic) UILabel *tipLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UIImageView *refreshIcon;
@property (nonatomic) ETQRCodeView *qrCodeView;
@property (nonatomic) UIView *refreshControl;
@property (nonatomic) UILabel *refLabel;
@property (nonatomic) BOOL existMessage;
@property (nonatomic) ETQRAssetView *assetView;
@property (nonatomic) ETQRCodePresenter *presenter;

@end

@implementation ETQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"扫描乘车", nil);
    UIImageView *bgView = [UIImageView new];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.image = [UIImage imageNamed:@"qrBG"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
    }];
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    self.presenter = [ETQRCodePresenter new];
    
    @weakify(self);
    [[RACObserve(self.presenter, sourceCode) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.qrCodeView updateSource:self.presenter.sourceCode];
    }];
    [self setupNavigationBar];
    [self updateRightButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self.presenter refreshIfNeeded] subscribeNext:^(id x) {
        
    }];
}

-(void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
      [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont s04Font], NSForegroundColorAttributeName: [UIColor drColorC0]}];
}

- (void)updateRightButton {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(showMessageCenter) title:nil normalImage:[UIImage imageNamed:self.existMessage ? @"navHasMsg":@"navNoMsg"] highlightedImage:nil];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(20 *PIXEL_SCALE);
            make.centerX.equalTo(_contentView);
            make.left.equalTo(_contentView).offset(24 * PIXEL_SCALE);
            make.right.equalTo(_contentView).offset(-24 * PIXEL_SCALE);
        }];
        
        UIView *containerView = [UIView new];
        containerView.backgroundColor = [UIColor white2];
        containerView.clipsToBounds = YES;
        containerView.layer.cornerRadius = 5;
        containerView.layer.borderColor = [UIColor clearColor].CGColor;
        containerView.layer.borderWidth = 1.0f;
    
        [_contentView addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tipLabel);
            make.top.equalTo(self.tipLabel.mas_bottom).offset(16);
        }];
        
        self.qrCodeView = [ETQRCodeView new];
        [containerView addSubview:self.qrCodeView];
        [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView).offset(32 * PIXEL_SCALE);
            make.left.equalTo(containerView).offset(64);
            make.right.equalTo(containerView).offset(-64);
        }];
        
        [containerView addSubview:self.refreshControl];
        [self.refreshControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qrCodeView.mas_bottom).offset(30 * PIXEL_SCALE);
            make.left.greaterThanOrEqualTo(self.qrCodeView).offset(25);
            make.right.lessThanOrEqualTo(self.qrCodeView).offset(-25);
            make.centerX.equalTo(containerView);
        }];
        
        [containerView addSubview:self.assetView];
        [self.assetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(containerView);
            make.top.equalTo(self.refreshControl.mas_bottom).offset(20);
        }];
        
        [_contentView addSubview:self.refLabel];
        [self.refLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(containerView);
            make.top.equalTo(containerView.mas_bottom).offset(12);
            make.bottom.equalTo(_contentView).offset(-15);
        }];
    }
    return _contentView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont fontWithSize:16];
        _tipLabel.textColor = [UIColor white2];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"西 安 地 铁 乘 车 码";
    }
    return _tipLabel;
}

- (UIView *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [UIView new];
        _refreshControl.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [UILabel new];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont s02Font];
        titleLabel.textColor = [UIColor warmGrey];
        titleLabel.text = @"刷新二维码";
        [_refreshControl addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_refreshControl).offset(10);
            make.bottom.equalTo(_refreshControl).offset(-10);
            make.right.equalTo(_refreshControl).offset(-10);
        }];
        
        self.refreshIcon = [UIImageView new];
        self.refreshIcon.backgroundColor = [UIColor clearColor];
        self.refreshIcon.image = [UIImage imageNamed:@"qrRefreshIcon"];
        [_refreshControl addSubview:self.refreshIcon];
        [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@14);
            make.height.equalTo(@12);
            make.left.equalTo(_refreshControl).offset(10);
            make.right.equalTo(titleLabel.mas_left).offset(-8);
            make.centerY.equalTo(titleLabel);
        }];

        @weakify(self);
        [_refreshControl bk_whenTapped:^{
            @strongify(self);
            [self startAnimation];
            [[self.presenter refreshIfNeeded] subscribeNext:^(id x) {
                [self stopAnimation];
            } error:^(NSError *error) {
                [self stopAnimation];
            }];
        }];
    }
    return _refreshControl;
}

- (ETQRAssetView *)assetView {
    if (!_assetView) {
        _assetView = [ETQRAssetView new];
        [_assetView updateWithBalance:@1232.00 miles:@134];
    }
    return _assetView;
}

- (UILabel *)refLabel {
    if (!_refLabel) {
        _refLabel = [UILabel new];
        _refLabel.textColor = [UIColor white2];
        _refLabel.font = [UIFont s02Font];
        _refLabel.textAlignment = NSTextAlignmentCenter;
        _refLabel.text = NSLocalizedString(@"APP客服热线:400-870-8989", nil);
    }
    return _refLabel;
}

- (void)showMessageCenter {
    
}

#pragma mark RefreshIcon animation
- (void)startAnimation {
    if ([self isAnimating]) {
        return;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 1.0f;
    animation.beginTime = 0.5;
    animation.fromValue = @0;
    animation.toValue = @(2 * M_PI);
    animation.fillMode = kCAFillModeRemoved;
    animation.repeatCount = HUGE_VALF;
    [self.refreshIcon.layer addAnimation:animation forKey:@"rotation1"];
}

- (void)stopAnimation {
    [self.refreshIcon.layer removeAllAnimations];
}

- (BOOL)isAnimating {
    for (NSString *key in self.refreshIcon.layer.animationKeys) {
        if ([@"rotation1" isEqualToString:key]) {
            return YES;
        }
    }
    return NO;
}

@end
