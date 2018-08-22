//
//  ETSettingPresenter.m
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETSettingPresenter.h"
#import "ETConstant.h"

@implementation ETSettingPresenter

- (instancetype)init {
    if (self = [super init]) {
        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:5];
        [sections addObject:@[[ETSettingItem itemWithTitle:@"账户与安全" content:nil rowId:ETSettingRowIdSecurity]]];
    
        [sections addObject:@[[ETSettingItem itemWithTitle:@"提示音效" content:nil rowId:ETSettingRowIdVoice],[ETSettingItem itemWithTitle:@"清除缓存" content:@"12M" rowId:ETSettingRowIdCache]]];
        
        [sections addObject:@[[ETSettingItem itemWithTitle:@"用户指南" content:nil rowId:ETSettingRowIdGuide],[ETSettingItem itemWithTitle:@"版本更新" content:[NSString stringWithFormat:@"V%@",KVersion] rowId:ETSettingRowIdVersion]]];
        
        [sections addObject:@[[ETSettingItem itemWithTitle:@"法律条款与隐私政策" content:nil rowId:ETSettingRowIdPotocol],[ETSettingItem itemWithTitle:@"关于我们" content:nil rowId:ETSettingRowIdAbout]]];
        self.sources = sections;
        
    }
    return self;
}

@end
