//
//  ETSettingProfileViewController.m
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETSettingProfileViewController.h"
#import "ETSettingItem.h"
#import "ETSettingTVCell.h"
#import "ETSettingAvatorTVCell.h"

@interface ETSettingProfileViewController ()

@property (nonatomic) NSArray *sources;

@end

@implementation ETSettingProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    self.view.backgroundColor = [UIColor white];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onCompleteTapped:)];
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:5];
    [sections addObject:@[[ETSettingItem itemWithTitle:@"头像" content:nil rowId:ETSettingRowIdUserAvator]]];
    
    [sections addObject:@[[ETSettingItem itemWithTitle:@"昵称" content:@"小小虾米" rowId:ETSettingRowIdUserNickname],[ETSettingItem itemWithTitle:@"性别" content:@"男" rowId:ETSettingRowIdUserSex]]];
    
    [sections addObject:@[[ETSettingItem itemWithTitle:@"邮箱" content:@"329358709@qq.com" rowId:ETSettingRowIdUserEmail],[ETSettingItem itemWithTitle:@"电话" content:@"18628088940" rowId:ETSettingRowIdUserMobile]]];
    self.sources = sections;
    
    [self.tableView registerClass:[ETSettingTVCell class] forCellReuseIdentifier:NSStringFromClass([ETSettingTVCell class])];
    [self.tableView registerClass:[ETSettingAvatorTVCell class] forCellReuseIdentifier:NSStringFromClass([ETSettingAvatorTVCell class])];
    [self.tableView reloadData];
}


- (void)onCompleteTapped:(UIButton *)button {
    [self popController];
}

#pragma mark UITableViewDelegate&UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sources[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETSettingItem *item = [self.sources[indexPath.section] objectAtIndex:indexPath.row];
    
    if (item.rowId == ETSettingRowIdUserAvator) {
        ETSettingAvatorTVCell *avatorCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ETSettingAvatorTVCell class])];
        return avatorCell;
    }
    
    ETSettingTVCell *tvCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ETSettingTVCell class])];
    tvCell.titleLabel.text = item.title;
    tvCell.contentLabel.text = item.content;
    tvCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowNextGrey"]];
    
    return tvCell;
}
@end
