//
//  UIFont+Additions.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)fontWithSize:(CGFloat)size {
    //    return [UIFont fontWithSize:size name:@"Âä"];
    return [UIFont fontWithSize:size name:@"PingFangSC-Medium"];
}

+ (UIFont *)fontWithSize:(CGFloat)size name:(NSString *)name {
    if (name) {
        return [UIFont fontWithName:name size:size];
    }
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)s00Font {
    return [self fontWithSize:8 name:nil];
}

+ (UIFont *)s01Font {
    return [self fontWithSize:10 name:nil];
}

+ (UIFont *)s02Font {
    return [self fontWithSize:12 name:nil];
}

+ (UIFont *)s03Font {
    return [self fontWithSize:13 name:nil];
}

+ (UIFont *)s04Font {
    return [self fontWithSize:16 name:nil];
}

+ (UIFont *)s05Font {
    return [self fontWithSize:18 name:nil];
}

+ (UIFont *)s06Font {
    return [self fontWithSize:20 name:nil];
}

+ (UIFont *)dialogTitleFont {
    return [self fontWithSize:26];
}

+ (UIFont *)dialogContentFont {
    return [self fontWithSize:14 name:nil];
}

@end
