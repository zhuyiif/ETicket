//
//  TTTAttributedLabel+additions.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "TTTAttributedLabel+additions.h"

@implementation TTTAttributedLabel (additions)

+ (instancetype)attributedWithLinkColor:(UIColor *)linkColor activeLinkColor:(UIColor *)activeColor underLine:(BOOL)underLine {
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.lineSpacing = 6;
    label.font = [UIFont fontWithSize:14];
    label.textColor = [UIColor drColorC6];
    if (linkColor) {
        label.linkAttributes = @{(__bridge NSString *)kCTUnderlineStyleAttributeName:@(underLine),
                                 (NSString *)kCTForegroundColorAttributeName:(__bridge id)linkColor.CGColor};
    }
    
    if (activeColor) {
        label.activeLinkAttributes = @{
                                       (__bridge NSString *)
                                       kCTUnderlineStyleAttributeName:@(underLine),
                                       (NSString *)kCTForegroundColorAttributeName: (__bridge id)activeColor.CGColor
                                       };
    }
    return label;
}

+ (instancetype)boldAttributedWithLinkColor:(UIColor *)linkColor activeLinkColor:(UIColor *)activeColor {
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.lineSpacing = 6;
    label.font = [UIFont fontWithSize:14];
    label.textColor = [UIColor drColorC6];
    
    if (linkColor) {
        label.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:(__bridge id)linkColor.CGColor,(id)kCTFontAttributeName: (__bridge_transfer id)CTFontCreateWithName(
                                                                                                                                                                                 (CFStringRef)[UIFont boldSystemFontOfSize:14].fontName, 14, NULL)};
    }
    
    if (activeColor) {
        label.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName: (__bridge id)activeColor.CGColor,(id)kCTFontAttributeName: (__bridge_transfer id)CTFontCreateWithName(
                                                                                                                                                                                          (CFStringRef)[UIFont boldSystemFontOfSize:14].fontName, 14, NULL)};
    }
    return label;
}

@end
