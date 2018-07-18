//
//  NSString+Additions.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}

//sqlite 普通的 = 操作可能出'(单引号的特殊字符)
- (NSString *)sqliteString {
    return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

- (NSString *)telPhoneNumber {
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+*#"] invertedSet];
    NSString *mobile = [[self componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    return mobile;
}


- (NSString *)telPhoneNumberAreaString {
    
    int len = (int)[self length];
    
    unichar *tmpBuf = (unichar *)malloc(len * sizeof(unichar));
    memset(tmpBuf, 0, len * sizeof(unichar));
    
    NSRange r = {0, len};
    [self getCharacters:tmpBuf range:r];
    unichar *curChar = tmpBuf;
    
    int i = 0;
    for (int j = 0; j < len; j++) {
        if (*curChar <= '9' && *curChar >= '0') {
            tmpBuf[i++] = *curChar;
        }
        curChar++;
    }
    
    NSString *outStr = [[NSString alloc] initWithCharacters:tmpBuf length:i];
    free(tmpBuf);
    
    if ([outStr length] <= 11) {
        return outStr;
    }
    
    return [outStr substringFromIndex:[outStr length] - 11];
}

- (NSString *)XXXString {
    if ([self length] < 11) {
        return self;
    }
    
    NSMutableString *mobile = [NSMutableString stringWithString:self];
    [mobile replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    return mobile;
}

- (BOOL)isNumericStr {
    static NSPredicate *_numberPredicate;
    if (!_numberPredicate) {
        _numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([1-9])([0-9])*$"];
    }
    return [_numberPredicate evaluateWithObject:self];
}

- (BOOL)isDigitalStr {
    static NSPredicate *_numberPredicate;
    if (!_numberPredicate) {
        
        _numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]+(.[0-9]{1,3})?$"];
    }
    return [_numberPredicate evaluateWithObject:self];
}

- (BOOL)isCurrectPhoneNum {
    static NSPredicate *_phonePredicate;
    if (!_phonePredicate) {
        _phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    }
    
    return [_phonePredicate evaluateWithObject:self];
}

- (BOOL)isTelNum {
    
    static NSPredicate *_phonePredicate;
    if (!_phonePredicate) {
        _phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]{6,12}$"];
    }
    
    return [_phonePredicate evaluateWithObject:self];
}

- (BOOL)isEmailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isMobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSString *phoneRegex = @"^1\\d{10}|\\+1-\\d{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
    return YES;
}

- (BOOL)isCarNo {
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", carRegex];
    NSLog(@"carTest is %@", carTest);
    return [carTest evaluateWithObject:self];
}
- (BOOL)validateIdentityCard {
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

- (NSString *)MD5String {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (NSString *)trim {
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:self];
    //裁剪开头
    int i;
    for (i = 0; i < self.length; i++) {
        NSString *character = [string substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@" "] || [character isEqualToString:@"\n"] || [character isEqualToString:@"\r"] || [character isEqualToString:@"\t"]) {
            continue;
        } else {
            break;
        }
    }
    
    if (i) {
        [string deleteCharactersInRange:NSMakeRange(0, i)];
    }
    //裁剪尾巴
    for (i = (int)string.length - 1; i >= 0; i--) {
        NSString *character = [string substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@" "] || [character isEqualToString:@"\n"] || [character isEqualToString:@"\r"] || [character isEqualToString:@"\t"]) {
            continue;
        } else {
            break;
        }
    }
    if (i) {
        [string deleteCharactersInRange:NSMakeRange(i + 1, string.length - 1 - i)];
    }
    return string;
}

- (NSAttributedString *)attributeWithColor:(UIColor *)color {
    return [self attributeWithColor:color font:[UIFont systemFontOfSize:14]];
}

- (NSAttributedString *)attributeWithColor:(UIColor *)color font:(UIFont *)font {
    return [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName : font,
                                                                        NSForegroundColorAttributeName : color}];
}

+ (BOOL)isNotBlank:(NSString *)string {
    if (string != nil && ![string isKindOfClass:[NSNull class]] && string.length > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

@end
