//
//  TTTAttributedLabel+additions.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface TTTAttributedLabel (additions)

+ (instancetype)attributedWithLinkColor:(UIColor *)linkColor activeLinkColor:(UIColor *)activeColor underLine:(BOOL)underLine;
+ (instancetype)boldAttributedWithLinkColor:(UIColor *)linkColor activeLinkColor:(UIColor *)activeColor;

@end
