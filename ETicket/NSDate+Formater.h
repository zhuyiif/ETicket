//
//  NSDate+Formater.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formater)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

+ (NSDate *)dateWithString:(NSString *)dateString
                    format:(NSString *)dateFormat;

+ (NSString *)formattedWithDate:(NSDate *)desData;

+ (NSString *)formattedWithDate:(NSDate *)desData
                         format:(NSString *)dateFormat;

+ (NSString *)getWeekDay:(NSDate *)date;

- (BOOL)isToday;

- (NSString *)getWeekDay;

- (NSInteger)daysSinceDate:(NSDate *)date;

- (NSInteger)daysSinceToday;

@end
