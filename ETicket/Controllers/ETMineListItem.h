//
//  ETMineListItem.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ETMineRowId) {
    ETMineRowIdAvator,
    ETMineRowIdAbout,
    ETMineRowIdLoginOut,
    ETMineRowIdLike,
};


@interface ETMineListItem : NSObject

+ (instancetype)listItemWithId:(NSNumber *)itemId title:(NSString *)title iconName:(NSString *)iconName;

@property (nonatomic) NSNumber *itemId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *iconName;

@end
