//
//  ETSettingPresenter.h
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETSettingItem.h"

@interface ETSettingPresenter : NSObject

@property (nonatomic) NSArray<NSArray<ETSettingItem *> *> *sources;

@end
