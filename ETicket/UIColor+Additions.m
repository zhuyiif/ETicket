//
//  UIColor+Additions.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "UIColor+Additions.h"
#import "ETThemeHelper.h"
#import <EDColor.h>

@implementation UIColor (Additions)


+ (UIColor *)backgroundColor {
    return [UIColor colorWithHex:0xf8f8f8];
}

+ (UIColor *)seperatorLineColor {
    return [UIColor drColorC2];
}

+ (UIColor *)drColorC0 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C0"]];
}

+ (UIColor *)drColorC1 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C1"]];
}

+ (UIColor *)drColorC2 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C2"]];
}

+ (UIColor *)drColorC3 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C3"]];
}

+ (UIColor *)drColorC4 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C4"]];
}

+ (UIColor *)drColorC5 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C5"]];
}

+ (UIColor *)drColorC6 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C6"]];
}

+ (UIColor *)drColorC7 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C7"]];
}

+ (UIColor *)drColorC8 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C8"]];
}

+ (UIColor *)drColorC9 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C9"]];
}

+ (UIColor *)drColorC10 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C10"]];
}

+ (UIColor *)drColorC11 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C11"]];
}

+ (UIColor *)drColorC12 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C12"]];
}

+ (UIColor *)drColorC13 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C13"]];
}

+ (UIColor *)drColorC14 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C14"]];
}

+ (UIColor *)drColorC15 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C15"]];
}

+ (UIColor *)drColorC16 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C16"]];
}

+ (UIColor *)drColorC17 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C17"]];
}

+ (UIColor *)drColorC18 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C18"]];
}

+ (UIColor *)drColorC19 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C19"]];
}

+ (UIColor *)drColorC21 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C21"]];
}

+ (UIColor *)drColorC22 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C22"]];
}

+ (UIColor *)drColorC23 {
    return [UIColor colorWithHexString:[self colorValueWithName:@"C23"]];
}

+ (NSString *)colorValueWithName:(NSString *)name {
    return [[ETThemeHelper sharedInstance] colorValueWithName:name];
}

+ (UIColor *)drBlackColor {
    return [UIColor colorWithHex:0x141D26];
}

+ (UIColor *)drOrangeColor {
    return [UIColor colorWithHex:0xF5A623];
}

+ (UIColor *)footerColor {
    return [UIColor colorWithHex:0x914d10];
}

+ (UIColor *)footerCutLineColor {
    return [UIColor colorWithHex:0xd47118];
}

+ (UIColor *)dialogTitleColor {
    return [UIColor colorWithHex:0xffd776];
}

+ (UIColor *)dialogContentColor {
    return [UIColor colorWithHex:0xfffaf1];
}

+ (UIColor *)warmGrey {
    return [UIColor colorWithHex:0x747474];
}

+ (UIColor *)greyishBrown {
    return [UIColor colorWithHex:0x4e4e4e];
}

+ (UIColor *)black {
    return [UIColor colorWithHex:0x1e1e1e];
}

+ (UIColor *)pumpkinOrange {
    return [UIColor colorWithHex:0xfd7e22];
}

+ (UIColor *)teal {
    return [UIColor colorWithHex:0x079a8b];
}

+ (UIColor *)tomato {
    return [UIColor colorWithHex:0xe9342b];
}

+ (UIColor *)white {
    return [UIColor colorWithHex:0xfafafa];
}

+ (UIColor *)appleGreen {
    return [UIColor colorWithHex:0x51c025];
}

@end
