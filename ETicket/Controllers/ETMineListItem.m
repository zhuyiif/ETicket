//
//  ETMineListItem.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETMineListItem.h"

@implementation ETMineListItem

+ (instancetype)listItemWithId:(NSNumber *)itemId title:(NSString *)title iconName:(NSString *)iconName {
    ETMineListItem *item = [[ETMineListItem alloc] init];
    item.itemId = itemId;
    item.title = title;
    item.iconName = iconName;
    return item;
}

@end
