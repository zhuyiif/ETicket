//
//  ETSegmentItem.m
//  ETicket
//
//  Created by chunjian wang on 2017/3/1.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import "ETSegmentItem.h"

@interface ETSegmentItem ()

@end

@implementation ETSegmentItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if ([ETSegmentItem isStringEmpty:self.title]) {
        return;
    }
    self.titleFont = self.selected ? Hilight_Title_Font : Default_Title_Font;
    self.titleFont = [[self class] caulateFont:self.title withFont:self.titleFont width:self.width];
    UIColor *titleColor = self.selected ? self.highlightColor : self.titleColor;
    CGFloat x = (CGRectGetWidth(rect) - [ETSegmentItem caculateTextWidth:self.title withFont:self.titleFont]) / 2;
    CGFloat fontSize = self.titleFont.pointSize;
    CGFloat y = CGRectGetHeight(rect) - fontSize - (self.selected ?3:6);
    [self.title drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName: self.titleFont, NSForegroundColorAttributeName:titleColor}];
}

+ (CGFloat)caculateWidthWithtitle:(NSString *)title titleFont:(UIFont *)titleFont {
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: titleFont} context:nil];
    CGFloat width = Item_Padding * 2 + rect.size.width;
    return width > 60.0f ? width : 60.0f;
}

- (void)refresh {
    [self setNeedsDisplay];
}

+ (BOOL)isStringEmpty:(NSString *)text {
    if (!text || [text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)caculateTextWidth:(NSString *)text withFont:(UIFont *)font {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([ETSegmentItem isStringEmpty:text]) {
        return 0;
    }
    CGRect newRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];

    text = nil;
    return newRect.size.width;
}


+ (UIFont *)caulateFont:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width{
    CGRect newRect = CGRectZero;
    UIFont *oldFont = [font fontWithSize:font.pointSize + 1];
    do {
        oldFont = [oldFont fontWithSize:oldFont.pointSize - 1];
        NSDictionary *attribute = @{NSFontAttributeName: oldFont};
        newRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, oldFont.pointSize) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    } while (newRect.size.width > width);
    return oldFont;
}

@end
