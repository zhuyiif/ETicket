//
//  ETTableViewController.h
//  ETicket
//
//  Created by chunjian wang on 2018/4/29.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) UITableView *tableView;

@end
