//
//  NSNumber+format2TN.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/8.
//  Copyright © 2018年 Bkex Technology Co.Ltd. All rights reserved.
//

#import "NSNumber+Format.h"

@implementation NSNumber (format2TN)

- (NSString *)format2TN:(NSInteger)digits {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    numberFormatter.minimumFractionDigits = 2;
    numberFormatter.maximumFractionDigits = digits;
    numberFormatter.perMillSymbol = @",";
    return [numberFormatter stringFromNumber:self];
}

- (NSString *)format0TN:(NSInteger)digits {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    numberFormatter.minimumFractionDigits = 0;
    numberFormatter.maximumFractionDigits = digits;
    numberFormatter.perMillSymbol = @",";
    return [numberFormatter stringFromNumber:self];
}

@end
