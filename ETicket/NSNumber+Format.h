//
//  NSNumber+Format.h
//  ETicket
//
//  Created by chunjian wang on 2018/3/8.
//  Copyright © 2018年 Bkex Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (format2TN)

/*
 * 2-digits位小数
 */
- (NSString *)format2TN:(NSInteger)digits;

/*
 * 0-digits位小数
 */
- (NSString *)format0TN:(NSInteger)digits;


@end
