//
//  ETSettingItem.h
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ETSettingRowId) {
    ETSettingRowIdSecurity,
    ETSettingRowIdVoice,
    ETSettingRowIdCache,
    ETSettingRowIdGuide,
    ETSettingRowIdVersion,
    ETSettingRowIdPotocol,
    ETSettingRowIdAbout,
    ETSettingRowIdUserAvator,
    ETSettingRowIdUserNickname,
    ETSettingRowIdUserSex,
    ETSettingRowIdUserEmail,
    ETSettingRowIdUserMobile,
};

@interface ETSettingItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) ETSettingRowId rowId;

+ (instancetype)itemWithTitle:(NSString *)title content:(NSString *)content rowId:(ETSettingRowId)rowId;

@end
