//
//  NSError+message.m
//  Brainspie
//
//  Created by chunjian wang on 16/6/12.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "NSError+message.h"

@implementation NSError (Message)

- (NSString *)message {
    if (self.userInfo  && self.userInfo[@"message"]) {
        return self.userInfo[@"message"];
    }
    return self.localizedDescription ?: [self description];
}

@end
