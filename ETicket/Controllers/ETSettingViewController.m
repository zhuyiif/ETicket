//
//  ETSettingViewController.m
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETSettingViewController.h"
#import "ETSettingItem.h"
#import "ETSettingTVCell.h"
#import "ETSettingPresenter.h"

@interface ETSettingViewController ()

@property (nonatomic) ETSettingPresenter *presenter;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UISwitch *voiceSwitch;

@end

@implementation ETSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    self.view.backgroundColor = [UIColor white];
    self.presenter = [ETSettingPresenter new];
    [self.tableView registerClass:[ETSettingTVCell class] forCellReuseIdentifier:NSStringFromClass([ETSettingTVCell class])];
    [self.tableView reloadData];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@56);
        make.bottom.equalTo(self.tableView);
    }];
    
    @weakify(self);
    [RACObserve([ETActor instance], user) subscribeNext:^(id x) {
        @strongify(self);
        if (!x) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.loginButton.hidden = YES;
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 58, 0);
            self.loginButton.hidden = NO;
        }
    }];
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.backgroundColor = [UIColor white2];
        [_loginButton setTitle:@"退出登录" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont fontWithSize:18];
        [_loginButton setTitleColor:[UIColor paleRedTwo] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(onLogoutTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UISwitch *)voiceSwitch {
    if (!_voiceSwitch) {
        _voiceSwitch = [UISwitch new];
        _voiceSwitch.backgroundColor = [UIColor clearColor];
        _voiceSwitch.on = [ETActor instance].notifyVoice;
        [_voiceSwitch addTarget:self action:@selector(onSwitchTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _voiceSwitch;
}

- (void)onLogoutTapped:(UIButton *)sender {
   
    ETAlertView *alertView = [ETAlertView noticeAlertView];
    [alertView addButton:NSLocalizedString(@"确定",nil) actionBlock:^(void) {
        [[ETActor instance] logoutWithBlock:^{
            [[ETAppDelegate delegate] resetRootController];
        }];
    }];
    [alertView showNotice:self title:NSLocalizedString(@"温馨提示",nil) subTitle:NSLocalizedString(@"确认退出当前账户？",nil) closeButtonTitle:NSLocalizedString(@"取消",nil) duration:0.0];
}

- (void)onSwitchTapped:(UISwitch *)sender {
    [ETActor instance].notifyVoice = sender.on;
}

#pragma mark UITableViewDelegate&UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.presenter.sources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presenter.sources[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETSettingTVCell *tvCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ETSettingTVCell class])];
    ETSettingItem *item = [self.presenter.sources[indexPath.section] objectAtIndex:indexPath.row];
    tvCell.titleLabel.text = item.title;
    tvCell.contentLabel.text = item.content;
    if (item.rowId != ETSettingRowIdVoice) {
        tvCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowNextGrey"]];
    } else {
        tvCell.accessoryView = self.voiceSwitch;
    }
    return tvCell;
}

@end
