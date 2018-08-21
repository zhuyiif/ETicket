//
//  ETSettingItem.m
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETSettingItem.h"

@implementation ETSettingItem

+ (instancetype)itemWithTitle:(NSString *)title content:(NSString *)content rowId:(ETSettingRowId)rowId {
    ETSettingItem *item = [ETSettingItem new];
    item.content = content;
    item.rowId = rowId;
    item.title = title;
    return item;
}

@end
