//
//  NSString+Additions.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString *)URLEncodedString;
- (NSString *)sqliteString;
- (NSString *)telPhoneNumberAreaString;
- (NSString *)telPhoneNumber;
- (NSString *)XXXString;
- (NSString *)MD5String;
- (NSString *)trim;
- (NSAttributedString *)attributeWithColor:(UIColor *)color;
- (NSAttributedString *)attributeWithColor:(UIColor *)color font:(UIFont *)font;

- (BOOL)isNumericStr;
- (BOOL)isDigitalStr;
- (BOOL)isCurrectPhoneNum;
- (BOOL)isTelNum;
- (BOOL)isEmailAddress;
- (BOOL)isMobile;
- (BOOL)isCarNo;
- (BOOL)validateIdentityCard;

+ (BOOL)isNotBlank:(NSString *)string;
+ (BOOL)isBlankString:(NSString *)string;

@end
