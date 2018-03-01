//
//  ETHomeViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETHomeViewController.h"
#import "ETBannerScrollView.h"
#import "ETHomePresenter.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface ETHomeViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) ETBannerScrollView *bannerView;
@property (nonatomic) UIView *bannerContainer;
@property (nonatomic) ETHomePresenter *presenter;

@end

@implementation ETHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor drColorC0];
    self.title = NSLocalizedString(@"首页", nil);
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.stackView = [UIStackView new];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 10;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.distribution = UIStackViewDistributionFill;
    [self.scrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.view);
    }];
    
    [self.bannerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bannerContainer.mas_width).multipliedBy(.4);
    }];
    [self.stackView addArrangedSubview:self.bannerContainer];
    [self bindDatas];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadIfNeeded];
}

- (UIView *)bannerContainer {
    if (!_bannerContainer) {
        _bannerContainer = [UIView new];
        _bannerContainer.backgroundColor = [UIColor clearColor];
        
        _bannerView = [ETBannerScrollView new];
        _bannerView.isHorizontal = YES;
        [_bannerContainer addSubview:_bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bannerContainer);
        }];
    }
    return _bannerContainer;
}

- (void)bindDatas {
    self.presenter = [[ETHomePresenter alloc] init];
    [self.presenter setupRequestWithController:self];
    @weakify(self);
    [[RACObserve(self.presenter, banners) skip:1] subscribeNext:^(NSArray<ETBannerInfo *> *x) {
        @strongify(self);
        [self.bannerView setBanners:x];
    }];
}

@end
