//
//  ETTravelViewController.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/20.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETTravelViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "ETTravelTVCell.h"
#import "ETTravelSectionHeaderView.h"

@interface ETTravelViewController ()

@end

@implementation ETTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的行程";
    self.view.backgroundColor = [UIColor white2];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(showMessageCenter:) title:nil normalImage:[UIImage imageNamed:@"navNoMsg"] highlightedImage:nil];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(showCalendar:) title:nil normalImage:[UIImage imageNamed:@"navCalendar"] highlightedImage:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ETTravelTVCell class] forCellReuseIdentifier:NSStringFromClass([ETTravelTVCell class])];
    [self.tableView reloadData];
}


#pragma mark UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section % 2 == 0 ? 3 :1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETTravelTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ETTravelTVCell class])];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ETTravelSectionHeaderView *headerView = [[ETTravelSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)showMessageCenter:(UIButton *)button {
    
}

- (void)showCalendar:(UIButton *)button {
    
}

@end
