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

@interface ETMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) ETMinePresenter *presenter;
@property (nonatomic) UIView *tableViewFooter;

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
    self.view.backgroundColor = [UIColor drColorC1];
    [self setupTableview];
}

#pragma mark - Private Methods
- (void)setupTableview {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (UIView *)tableViewFooter {
    if (!_tableViewFooter) {
        _tableViewFooter = [UIView new];
        _tableViewFooter.backgroundColor = [UIColor drColorC1];
        UIButton *logoutButton = [UIButton buttonWithStyle:ETButtonStyleRed height:44];
        [logoutButton setTitle:NSLocalizedString(@"注销账号", nil) forState:UIControlStateNormal];
        [_tableViewFooter addSubview:logoutButton];
        [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableViewFooter).offset(10);
            make.left.equalTo(_tableViewFooter).offset(30);
            make.right.equalTo(_tableViewFooter).offset(-30);
            make.bottom.equalTo(_tableViewFooter).offset(-10);
            make.height.equalTo(@44);
        }];
        
        @weakify(self);
        [logoutButton.eventSingal subscribeNext:^(id x) {
            @strongify(self);
            ETAlertView *alertView = [ETAlertView noticeAlertView];
            [alertView addButton:@"确定" actionBlock:^(void) {
                [ETActor instance].login = NO;
                [[ETAppDelegate delegate] resetRootController];
            }];
            [alertView showNotice:self title:@"温馨提示" subTitle:@"确认退出当前账户？" closeButtonTitle:@"取消" duration:0.0];
            
        }];
        _tableViewFooter.height = [_tableViewFooter systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        
    }
    return _tableViewFooter;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.presenter.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presenter.listArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 7 : 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.1)];
    view.backgroundColor = [UIColor drColorC1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 10)];
    view.backgroundColor = [UIColor drColorC1];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETMineTVCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ETMineTVCell class])];
    ETMineListItem  *item  = [self.presenter.listArray objectAtIndex:indexPath.section][indexPath.row];
    cell.titleLabel.text = item.title;
    cell.iconImageView.image = [UIImage imageNamed:item.iconName];
    cell.isHiddenSeparatorLine = (indexPath.row == 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            ETAlertView *noticeAlert = [ETAlertView noticeAlertView];
            [noticeAlert showNotice:self title:@"温馨提示" subTitle:@"test" closeButtonTitle:@"ok" duration:0];
        }
            break;
        case 1: {
            ETAlertView *noticeAlert = [ETAlertView successAlertView];
            [noticeAlert showNotice:self title:nil subTitle:@"test" closeButtonTitle:@"ok" duration:0];
        }
            break;
        case 2: {
            ETAlertView *noticeAlert = [ETAlertView errorAlertView];
            [noticeAlert showNotice:self title:@"错误" subTitle:@"test" closeButtonTitle:@"ok" duration:0];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Setters/Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = (id)self;
        _tableView.dataSource = (id)self;
        _tableView.backgroundColor = [UIColor drColorC1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
        [_tableView registerClass:[ETMineTVCell class] forCellReuseIdentifier:NSStringFromClass([ETMineTVCell class])];
        _tableView.tableFooterView = self.tableViewFooter;
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
