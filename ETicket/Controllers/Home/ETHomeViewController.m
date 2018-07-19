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
#import "ETSegmentBar.h"

@interface ETHomeViewController () <UIScrollViewDelegate,ETSegmentBarDelegate>
@property (nonatomic) ETHomeHeaderView *headerView;
@property (nonatomic) ETHomePresenter *presenter;
@property (nonatomic) ETSegmentBar *segmentBar;
@property (nonatomic) UILabel *titleView;
@property (nonatomic) UIView *navigationBar;
@property (nonatomic) UIView *bottomLine;
@property (nonatomic) CGFloat statusBarAlpha;

@end

@implementation ETHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
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
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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

- (ETSegmentBar *)segmentBar {
    if (!_segmentBar) {
        _segmentBar = [ETSegmentBar new];
        _segmentBar.delegate = self;
        NSMutableArray *items = [NSMutableArray new];
        ETSegmentModel *model = [ETSegmentModel new];
        model.title = @"街探";
        [items addObject:model];
        
        ETSegmentModel *model1 = [ETSegmentModel new];
        model1.title = @"吃吃";
        [items addObject:model1];
        
        ETSegmentModel *model2 = [ETSegmentModel new];
        model2.title = @"玩玩玩";
        [items addObject:model2];
        
        ETSegmentModel *model3 = [ETSegmentModel new];
        model3.title = @"买买买";
        [items addObject:model3];
        
        ETSegmentModel *model4 = [ETSegmentModel new];
        model4.title = @"出去浪";
        [items addObject:model4];
        
        ETSegmentModel *model5 = [ETSegmentModel new];
        model5.title = @"出去浪1";
        [items addObject:model5];
        ETSegmentModel *model6 = [ETSegmentModel new];
        model6.title = @"出去浪2";
        [items addObject:model6];
        
        [_segmentBar updateWithModels:items];
    }
    return _segmentBar;
}

- (ETHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [ETHomeHeaderView new];
        _headerView.height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    return _headerView;
}

- (void)bindDatas {
    self.presenter = [[ETHomePresenter alloc] init];
    [self.presenter setupRequestWithController:self];
    @weakify(self);
    [[RACObserve(self.presenter, banners) skip:1] subscribeNext:^(NSArray<ETBannerInfo *> *x) {
        @strongify(self);
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
        ETBannerInfo *bannerInfo = [ETBannerInfo new];
        bannerInfo.image = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531994350329&di=0e4e4c4cc979e7ca46e93f65c0477e56&imgtype=0&src=http%3A%2F%2Fimg3.3lian.com%2F2013%2Fc4%2F95%2Fd%2F18.jpg";
        [array addObject:bannerInfo];
        ETBannerInfo *bannerInfo1 = [ETBannerInfo new];
        bannerInfo1.image = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531994350329&di=0e4e4c4cc979e7ca46e93f65c0477e56&imgtype=0&src=http%3A%2F%2Fimg3.3lian.com%2F2013%2Fc4%2F95%2Fd%2F18.jpg";
        [array addObject:bannerInfo1];
        ETBannerInfo *bannerInfo2 = [ETBannerInfo new];
        bannerInfo2.image = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531994350329&di=0e4e4c4cc979e7ca46e93f65c0477e56&imgtype=0&src=http%3A%2F%2Fimg3.3lian.com%2F2013%2Fc4%2F95%2Fd%2F18.jpg";
        [array addObject:bannerInfo2];
        [self.headerView.bannerView.bannerView setBanners:array];
        
        NSMutableArray *announceArray = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0 ;i < 5; i ++) {
            ETAnouncementInfo *announce = [ETAnouncementInfo new];
            announce.title = @"大户哦发货方";
            [announceArray addObject:announce];
        }
        [self.headerView.announceView setAnouncements:announceArray];
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
    self.tableView.contentInset = UIEdgeInsetsMake(self.statusBarAlpha > 0.5 ? self.navigationBar.height : 0,0 ,0,0);
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
    return [self.segmentBar systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentBar;
}

#pragma mark ETSegementBarDelegate
- (void)onSegemnetBar:(ETSegmentBar *)segmentBar itemSeleced:(ETSegmentModel *)model {
    
}

@end
