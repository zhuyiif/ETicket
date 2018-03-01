//
//  DSMineListItem.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSMineListItem.h"

@implementation DSMineListItem

+ (instancetype)listItemWithId:(NSNumber *)itemId title:(NSString *)title iconName:(NSString *)iconName {
    DSMineListItem *item = [[DSMineListItem alloc] init];
    item.itemId = itemId;
    item.title = title;
    item.iconName = iconName;
    return item;
}

@end
