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

@interface ETMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) ETMinePresenter *presenter;
@property (nonatomic) ETHotView *hotView;
@property (nonatomic) NSMutableArray *hotItems;
@property (nonatomic) ETMineTitleHeaderView *sectionHeader;

@end

@implementation ETMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    [self.tableView reloadData];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的",nil);
    self.view.backgroundColor = [UIColor white];
    [self setupTableview];
}

#pragma mark - Private Methods
- (void)setupTableview {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
    }];
}

//- (UIView *)tableViewFooter {
//    if (!_tableViewFooter) {
//        _tableViewFooter = [UIView new];
//        _tableViewFooter.backgroundColor = [UIColor drColorC1];
//        UIButton *logoutButton = [UIButton buttonWithStyle:ETButtonStyleRed height:44];
//        [logoutButton setTitle:NSLocalizedString(@"注销账号", nil) forState:UIControlStateNormal];
//        [_tableViewFooter addSubview:logoutButton];
//        [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_tableViewFooter).offset(10);
//            make.left.equalTo(_tableViewFooter).offset(30);
//            make.right.equalTo(_tableViewFooter).offset(-30);
//            make.bottom.equalTo(_tableViewFooter).offset(-10);
//            make.height.equalTo(@44);
//        }];
//
//        @weakify(self);
//        [logoutButton.eventSingal subscribeNext:^(id x) {
//            @strongify(self);
//            ETAlertView *alertView = [ETAlertView noticeAlertView];
//            [alertView addButton:@"确定" actionBlock:^(void) {
//                [ETActor instance].login = NO;
//                [[ETAppDelegate delegate] resetRootController];
//            }];
//            [alertView showNotice:self title:@"温馨提示" subTitle:@"确认退出当前账户？" closeButtonTitle:@"取消" duration:0.0];
//
//        }];
//        _tableViewFooter.height = [_tableViewFooter systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//
//    }
//    return _tableViewFooter;
//}

- (ETMineTitleHeaderView *)sectionHeader {
    if (!_sectionHeader) {
        _sectionHeader = [ETMineTitleHeaderView new];
    }
    return _sectionHeader;
}

- (ETHotView *)hotView {
    if (!_hotView) {
        _hotView = [ETHotView new];
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
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        _tableView.tableFooterView = self.tableViewFooter;
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
