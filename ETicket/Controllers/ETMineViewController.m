//
//  ETMineViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETMineViewController.h"
#import "ETMinePresenter.h"
#import "ETMineTVCell.h"
#import "ETMineListItem.h"
#import "ETRouteTVCell.h"
#import "ETMineTitleHeaderView.h"
#import "ETHotView.h"
#import "ETMineHeaderView.h"

@interface ETMineViewController ()<UITableViewDelegate,UITableViewDataSource,ETHotViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) ETMinePresenter *presenter;
@property (nonatomic) ETHotView *hotView;
@property (nonatomic) NSMutableArray *hotItems;
@property (nonatomic) ETMineTitleHeaderView *sectionHeader;
@property (nonatomic) ETMineHeaderView *loginedHeaderView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) CGFloat statusBarAlpha;


@end

@implementation ETMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的",nil);
    self.view.backgroundColor = [UIColor white];
    [self setupTableview];
    [self setupNavigationBar];
}

#pragma mark - Private Methods
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
    self.titleLabel.text = NSLocalizedString(@"我的",nil);
}

- (BOOL)statusBarNeedToWhite {
    return self.statusBarAlpha > 0.3 ? NO : YES;
}

- (void)updateNavigationBarStyle {
    self.titleLabel.textColor = [self statusBarNeedToWhite] ? [UIColor clearColor] : [[UIColor drColorC5] colorWithAlphaComponent:self.statusBarAlpha];
    UIColor *naviColor = [self statusBarNeedToWhite] ? [UIColor clearColor] : [[UIColor drColorC0] colorWithAlphaComponent:self.statusBarAlpha];
    [self.navigationController.navigationBar lt_setBackgroundColor:naviColor];
    [UIApplication sharedApplication].statusBarStyle = [self statusBarNeedToWhite] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)setupTableview {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

- (ETMineHeaderView *)loginedHeaderView {
    if (!_loginedHeaderView) {
        _loginedHeaderView = [ETMineHeaderView new];
        [_loginedHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(313*PIXEL_SCALE));
        }];
        _loginedHeaderView.width = kScreenWidth;
        _loginedHeaderView.height = 313*PIXEL_SCALE;
    }
    return _loginedHeaderView;
}

- (ETMineTitleHeaderView *)sectionHeader {
    if (!_sectionHeader) {
        _sectionHeader = [ETMineTitleHeaderView new];
    }
    return _sectionHeader;
}

- (ETHotView *)hotView {
    if (!_hotView) {
        _hotView = [ETHotView new];
        _hotView.delegate = self;
        [_hotView updateModels:self.hotItems];
    }
    return _hotView;
}

- (NSMutableArray *)hotItems {
    if (!_hotItems) {
        _hotItems = [NSMutableArray arrayWithCapacity:4];
        ETHotModel *model = [ETHotModel modelWithName:@"余额充值" link:@"wallet" image:@"mineWallet"];
        [_hotItems addObject:model];
        ETHotModel *model1 = [ETHotModel modelWithName:@"我的收藏" link:@"collection" image:@"mineCollection"];
        [_hotItems addObject:model1];
        ETHotModel *model2 = [ETHotModel modelWithName:@"在线客户" link:@"kefu" image:@"mineKefu"];
        [_hotItems addObject:model2];
        ETHotModel *model3 = [ETHotModel modelWithName:@"关于我们" link:@"about" image:@"mineAbout"];
        [_hotItems addObject:model3];
    }
    return _hotItems;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 0 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section ==  0) {
        return [self.hotView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    return [self.sectionHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? self.hotView : self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 8)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETRouteTVCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ETRouteTVCell class])];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetTop = 44 + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    self.statusBarAlpha =  offsetY > 3 ? MIN(1, 1 - ((3 + offsetTop - offsetY) / offsetTop)) : 0;
    [self updateNavigationBarStyle];
}

- (void)hotView:(ETHotView *)hotView selectedItem:(ETHotModel *)model {
    [[[ETActor instance] showLoginIfNeeded] subscribeNext:^(id x) {
        
    }];
}

#pragma mark - Setters/Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = (id)self;
        _tableView.dataSource = (id)self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
        [_tableView registerClass:[ETRouteTVCell class] forCellReuseIdentifier:NSStringFromClass([ETRouteTVCell class])];
        _tableView.tableHeaderView = self.loginedHeaderView;
    }
    return _tableView;
}

- (ETMinePresenter *)presenter {
    if (!_presenter) {
        _presenter = [[ETMinePresenter alloc] init];
    }
    return _presenter;
}

@end
