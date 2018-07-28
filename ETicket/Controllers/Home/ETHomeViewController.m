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
#import "UIButton+Style.h"
#import "ETPayHelper.h"
#import "ETHomeHeaderView.h"
#import "ETQRCodeViewController.h"
#import "ETLoginViewController.h"
#import "ETHomeNewsTVCell.h"
#import "ETSegmentControl.h"
#import "ETStoreDetailViewController.h"

@interface ETHomeViewController () <UIScrollViewDelegate,ETSegmentControlDelegate>
@property (nonatomic) ETHomeHeaderView *headerView;
@property (nonatomic) ETHomePresenter *presenter;
@property (nonatomic) ETSegmentControl *segmentControl;
@property (nonatomic) UIView *sectionHeader;
@property (nonatomic) UILabel *titleView;
@property (nonatomic) UIView *navigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) CGFloat statusBarAlpha;

@end

@implementation ETHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"首页", nil);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [self.tableView registerClass:[ETHomeNewsTVCell class] forCellReuseIdentifier:NSStringFromClass([ETHomeNewsTVCell class])];
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        if (@available(iOS 11.0, *)) {
            if(statusBarHeight > 20) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                
            } else {
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.view);
            }
        } else {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }
    }];
    self.segmentControl.selectIndex = 0;
    self.segmentControl.titles = @[@"街探",@"吃吃吃吃吃吃",@"玩玩玩",@"买买卖",@"出去浪",@"街探",@"吃吃吃",@"玩玩玩",@"吃吃吃吃吃吃",@"出去浪"];
    self.segmentControl.frame = CGRectMake(.0f, .0f, kScreenWidth, DefaultSegmentHeight);
    [self.segmentControl load];
    [self bindDatas];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = [self statusBarNeedToWhite] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    [self reloadIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (ETSegmentControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[ETSegmentControl alloc] init];
        _segmentControl.delegate = self;
        _segmentControl.titleColor = [UIColor greyishBrown];
        _segmentControl.sepLineStyle = UIViewAddSepLineStyleNone;
        _segmentControl.highlightColor = [UIColor black];
        _segmentControl.lineHeight = 4;
        _segmentControl.bottomLineColor = [UIColor pumpkinOrange];
        _segmentControl.backgroundColor = [UIColor backgroundColor];
        [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(DefaultSegmentHeight));
        }];
    }
    return _segmentControl;
}

- (ETHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [ETHomeHeaderView new];
        _headerView.height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        _headerView.width = kScreenWidth;
    }
    return _headerView;
}

- (UIView *)sectionHeader {
    if (!_sectionHeader) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.segmentControl];
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
            make.height.equalTo(@(DefaultSegmentHeight));
        }];
        _sectionHeader = view;
    }
    return _sectionHeader;
}

- (void)bindDatas {
    self.presenter = [[ETHomePresenter alloc] init];
    [self.presenter setupRequestWithController:self];
    @weakify(self);
    [[RACObserve(self.presenter, banners) skip:1] subscribeNext:^(NSArray<ETBannerInfo *> *x) {
        @strongify(self);
        [self.headerView.bannerView.bannerView setBanners:x];
    }];
    
    [[RACObserve(self.presenter, announces) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.headerView.announceView setAnouncements:x];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarAlpha > 0.3 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (BOOL)statusBarNeedToWhite {
    return self.statusBarAlpha > 0.3 ? NO : YES;
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _navigationBar = [UIView new];
    _navigationBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navigationBar];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor drColorC2];
    [_navigationBar addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(_navigationBar);
        make.height.equalTo(@1);
    }];
    
    CGSize statusSize = [UIApplication sharedApplication].statusBarFrame.size;
    [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(44 + statusSize.height));
    }];
    
    _titleView = [UILabel new];
    _titleView.backgroundColor = [UIColor clearColor];
    _titleView.font = [UIFont s04Font];
    _titleView.textColor = [UIColor drColorC5];
    _titleView.text = @"首页";
    [_navigationBar addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBar);
        make.bottom.equalTo(_navigationBar).offset(-10);
    }];
    _titleView.alpha = 0;
    _navigationBar.hidden = YES;
}

- (void)updateNavigationBarStyle {
    _navigationBar.hidden = [self statusBarNeedToWhite];
    _titleView.alpha = self.statusBarAlpha;
    _navigationBar.backgroundColor = [self statusBarNeedToWhite] ? [UIColor clearColor] :[[UIColor drColorC0] colorWithAlphaComponent:self.statusBarAlpha];
    self.bottomLine.backgroundColor = [self statusBarNeedToWhite] ? [UIColor clearColor] : [[UIColor drColorC2] colorWithAlphaComponent:self.statusBarAlpha];
    [UIApplication sharedApplication].statusBarStyle = [self statusBarNeedToWhite] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (statusBarHeight > 20) {
        self.tableView.contentInset = UIEdgeInsetsMake(self.statusBarAlpha > 0.5 ? self.navigationBar.height - statusBarHeight : 0,0 ,0,0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(self.statusBarAlpha > 0.5 ? self.navigationBar.height : 0,0 ,0,0);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat rate = 200.0f / 375.0f;
    CGFloat effectDistance = rate * kScreenWidth - self.navigationBar.height;
    self.statusBarAlpha = (offsetY > effectDistance) ? MIN(1, ((offsetY - effectDistance ) / self.navigationBar.height)) : 0;
    [self updateNavigationBarStyle];
    _navigationBar.transform = CGAffineTransformMakeTranslation(0, offsetY > 0 ? 0 : -offsetY);
}

#pragma mark UITableViewDelegate & UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETHomeNewsTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ETHomeNewsTVCell class])];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DefaultSegmentHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ETStoreDetailViewController *VC = [ETStoreDetailViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma ETSegmentControlDelegate
- (void)segmentSelectAtIndex:(NSInteger)index animation:(BOOL)animation {
    [self.tableView reloadData];
}

- (void)updateSegmentBarPosition {
    
}

@end
