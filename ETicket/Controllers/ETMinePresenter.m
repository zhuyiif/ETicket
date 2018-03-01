//
//  ETMinePresenter.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETMinePresenter.h"
#import "ETMineListItem.h"

@implementation ETMinePresenter

- (instancetype)init {
    if (self = [super init]) {
        self.listArray = [[NSMutableArray alloc] initWithCapacity:5];
        NSMutableArray *sectionOne = [[NSMutableArray alloc] initWithCapacity:5];
        [sectionOne addObject:[ETMineListItem listItemWithId:@1 title:@"我的收藏" iconName:@"loginQQNor"]];
        [sectionOne addObject:[ETMineListItem listItemWithId:@1 title:@"我的收藏" iconName:@"loginQQNor"]];
        [sectionOne addObject:[ETMineListItem listItemWithId:@1 title:@"我的收藏" iconName:@"loginQQNor"]];
        [sectionOne addObject:[ETMineListItem listItemWithId:@1 title:@"我的收藏" iconName:@"loginQQNor"]];
        [self.listArray addObject:sectionOne];
        
        NSMutableArray *sectionTwo = [[NSMutableArray alloc] initWithCapacity:5];
        [sectionTwo addObject:[ETMineListItem listItemWithId:@1 title:@"我的教材" iconName:@"loginQQNor"]];
        [sectionTwo addObject:[ETMineListItem listItemWithId:@1 title:@"我的教材" iconName:@"loginQQNor"]];
        [sectionTwo addObject:[ETMineListItem listItemWithId:@1 title:@"我的教材" iconName:@"loginQQNor"]];
        [sectionTwo addObject:[ETMineListItem listItemWithId:@1 title:@"我的教材" iconName:@"loginQQNor"]];
        [self.listArray addObject:sectionTwo];
    }
    return self;
}

@end
