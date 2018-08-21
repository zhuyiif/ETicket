//
//  ETStoreDetailViewController.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETStoreDetailViewController.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "ETStoreExtendRowView.h"
#import "ETStoreRecommendRowView.h"
#import "ETStoreSummaryRowView.h"
#import "ETStoreFeatureRowView.h"
#import "ETStoreBottomView.h"
#import "UIBarButtonItem+Helper.h"

@interface ETStoreDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) CGFloat statusBarAlpha;
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic) ETStoreSummaryRowView *summaryView;
@property (nonatomic) ETStoreFeatureRowView *featureView;
@property (nonatomic) ETStoreRecommendRowView *recommendView;
@property (nonatomic) ETStoreExtendRowView *extendView;
@property (nonatomic) ETStoreBottomView *bottomView;
@property (nonatomic) UIBarButtonItem *backItem;

@end

@implementation ETStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setupNavigationBar];
    self.bottomView = [ETStoreBottomView new];
    [self.bottomView.backButton addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    self.scrollView = [TPKeyboardAvoidingScrollView new];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top).offset(3);
    }];
    
    [self.scrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    ETBannerInfo *info = [ETBannerInfo new];
    info.cover = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532802520842&di=ae4ffc5076b42e9a033c2519972990c8&imgtype=0&src=http%3A%2F%2Fuploads.sundxs.com%2Fallimg%2F1704%2F19-1F421204216-50.jpg";
    [self.summaryView.bannerView setBanners:@[info]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = [self statusBarNeedToWhite] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        self.summaryView = [ETStoreSummaryRowView new];
        self.extendView = [ETStoreExtendRowView new];
        self.featureView = [ETStoreFeatureRowView new];
        self.recommendView = [ETStoreRecommendRowView new];
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.summaryView,self.extendView,self.featureView,self.recommendView]];
        _stackView.backgroundColor = [UIColor clearColor];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 12;
    }
    return _stackView;
}

- (BOOL)statusBarNeedToWhite {
    return self.statusBarAlpha > 0.3 ? NO : YES;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - 120) / 2, 0, 120, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor clearColor];
        _titleLabel.font = [UIFont s05Font];
    }
    return _titleLabel;
}

#pragma mark - Private Methods
- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = self.titleLabel;
    self.titleLabel.text = NSLocalizedString(@"详情",nil);
    self.backItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(popController)  title:nil normalImage:[UIImage imageNamed:@"ArrowBackWhite"] highlightedImage:nil];
    self.backItem.customView.hidden = YES;
    self.navigationItem.leftBarButtonItem = self.backItem;
    
}

- (void)updateNavigationBarStyle {
    self.titleLabel.textColor = [self statusBarNeedToWhite] ? [UIColor clearColor] : [[UIColor drColorC5] colorWithAlphaComponent:self.statusBarAlpha];
    self.backItem.customView.hidden = [self statusBarNeedToWhite];
    UIColor *naviColor = [self statusBarNeedToWhite] ? [UIColor clearColor] : [[UIColor drColorC0] colorWithAlphaComponent:self.statusBarAlpha];
    [self.navigationController.navigationBar lt_setBackgroundColor:naviColor];
    [UIApplication sharedApplication].statusBarStyle = [self statusBarNeedToWhite] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat rate = 200.0f / 375.0f;
    CGFloat offsetTop = 44 + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat effectDistance = rate * kScreenWidth - offsetTop;
    self.statusBarAlpha = (offsetY > effectDistance) ? MIN(1, ((offsetY - effectDistance ) / offsetTop)) : 0;
    [self updateNavigationBarStyle];
}

@end
