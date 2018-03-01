//
//  ETPayHelper.h
//  ETicket
//
//  Created by chunjian wang on 2018/3/2.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETPayHelper : NSObject

+ (instancetype)sharedInstance;

- (RACSignal *)payWithAmount:(NSNumber *)amount;
- (RACSignal *)payWithAmount:(NSNumber *)amount subject:(NSString *)subject content:(NSString *)content;

@end
