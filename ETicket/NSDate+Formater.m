//
//  NSDate+Formater.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "NSDate+Formater.h"

#define D_MINUTE 60
#define D_HOUR 3600
#define D_DAY 86400
#define D_WEEK 604800
#define D_YEAR 31556926

@implementation NSDate (Formater)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour |
    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval {
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    NSInteger roundedSeconds = lround(timeInterval - (components.hour * 60 * 60) - (components.minute * 60));
    
    if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)roundedSeconds];
    } else {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)roundedSeconds];
    }
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:dateFormat];
    NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [dateFormatter setLocale:mainlandChinaLocale];
    NSDate *desDate = [dateFormatter dateFromString:dateString];
    return desDate;
}

+ (NSString *)formattedWithDate:(NSDate *)desData format:(NSString *)dateFormat {
    if (!desData || dateFormat == nil) {
        return @"";
    }
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:dateFormat];
    NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
    [dateFormatter setLocale:mainlandChinaLocale];
    
    return [dateFormatter stringFromDate:desData];
}

+ (NSString *)formattedWithDate:(NSDate *)desData {
    if (!desData) {
        return @"";
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:desData];
    
    NSString *formattedString = nil;
    if ([nowComponents year] == [dateComponents year] &&
        [nowComponents month] == [dateComponents month] &&
        [nowComponents day] == [dateComponents day]) { // 今天.
        
        int diff = [desData timeIntervalSinceNow];
        
        if (diff <= 0 && diff > -60 * 60) { // 一小时之内.
            int min = -diff / 60;
            
            if (min == 0) {
                min = 1;
            }
            formattedString = [NSString stringWithFormat:@"%d分钟前", min];
            
        } else if (diff > 0) {
            formattedString = [NSString stringWithFormat:@"%d分钟前", 1];
        } else {
            [dateFormatter setDateFormat:@"HH:mm"];
            
            formattedString = [dateFormatter stringFromDate:desData];
        }
    } else {
        NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:mainlandChinaLocale];
        if ([nowComponents year] == [dateComponents year]) {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        } else {
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        }
        
        formattedString = [dateFormatter stringFromDate:desData];
    }
    return formattedString;
}

+ (NSString *)getWeekDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags =
    NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour |
    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    
    NSDateComponents *components = [calendar
                                    components:unitFlags fromDate:date];
    NSInteger weekDayIndex = [components weekday];
    switch (weekDayIndex) {
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        case 1:
            return @"周日";
            break;
        default:
            return @"  ";
            break;
    }
}


- (NSString *)getWeekDay {
    return [NSDate getWeekDay:self];
}

/**
 * 判断是否为当天
 */
#define kOneDay (60 * 60 * 24)

- (NSInteger)daysSinceDate:(NSDate *)date {
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSInteger current = [self timeIntervalSince1970] + offset;
    NSInteger another = [date timeIntervalSince1970] + offset;
    return (current / kOneDay - another / kOneDay);
}

- (NSInteger)daysSinceToday {
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSInteger today = [[NSDate date] timeIntervalSince1970] + offset;
    NSInteger current = [self timeIntervalSince1970] + offset;
    return (current / kOneDay - today / kOneDay);
}

- (BOOL)isToday {
    return [self daysSinceToday] == 0;
}

@end
