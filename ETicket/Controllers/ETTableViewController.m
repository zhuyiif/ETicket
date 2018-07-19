//
//  ETTableViewController.m
//  ETicket
//
//  Created by chunjian wang on 2018/4/29.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETTableViewController.h"

#import "TPKeyboardAvoidingTableView.h"

@interface ETTableViewController  ()

@end

@implementation ETTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor drColorC1];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    UIView *footer = [[UIView alloc] init];
    footer.height = 1;
    footer.width = self.view.width;
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
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

#pragma mark TableDatasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"baseCell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:Identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont s01Font];
    }
    return cell;
}

@end

