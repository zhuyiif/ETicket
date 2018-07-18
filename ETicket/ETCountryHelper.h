//
//  ETCountryHelper.h
//  ETicket
//
//  Created by chunjian wang on 2018/5/10.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETCountryCode.h"

@interface ETCountryHelper : NSObject

@property (nonatomic) NSArray<ETCountryCode *> *countryCodes;

+ (instancetype)sharedInstance;

- (RACSignal *)syncIfNeeded;;

@end
