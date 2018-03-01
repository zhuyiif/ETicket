//
//  ETThemeHelper.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETThemeHelper : NSObject

+ (instancetype)sharedInstance;

- (NSString *)colorValueWithName:(NSString *)colorName;



@end
