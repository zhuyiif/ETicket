//
//  UIButton+Style.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "UIButton+Style.h"
#import "UIImage+Draw.h"

#import "UIButton+Style.h"
#import "UIImage+Draw.h"
#import <objc/runtime.h>


@implementation UIButton (Style)

+ (instancetype)buttonWithStyle:(DSButtonStyle)style height:(CGFloat)height {
    return [[UIButton alloc] initWithStyle:style height:height];
}

+ (instancetype)buttonWithNormalImage:(NSString *)normalImage hightImage:(NSString *)hightImage {
    UIButton *wechat = [UIButton new];
    [wechat setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [wechat setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    return wechat;
}

#pragma mark - Public

- (instancetype)initWithStyle:(DSButtonStyle)style height:(CGFloat)height {
    if (self = [super init]) {
        [self setStyle:style];
        self.layer.cornerRadius = height / 2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setStyle:(DSButtonStyle)style {
    switch (style) {
        case DSButtonStyleOrange:
        case DSButtonStyleGreen: {
            [self setTitleColor:[UIColor drColorC0] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor drColorC0] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor drColorC0] forState:UIControlStateDisabled];
            [self setBackgroundImage:[self normalBGImageWithStyle:style] forState:UIControlStateNormal];
            [self setBackgroundImage:[self hightBGImageWithStyle:style] forState:UIControlStateHighlighted];
            [self setBackgroundImage:[self disableBGImageWithStyle:style] forState:UIControlStateDisabled];
        }
            break;

        case DSButtonStyleBorderGreen:
        case DSButtonStyleBorderOrange:
        case DSButtonStyleBorderWhite:{
            self.backgroundColor = [UIColor clearColor];
            [self setTitleColor:[UIColor drColorC0] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor drColorC0] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor drColorC2] forState:UIControlStateDisabled];
            self.layer.borderWidth = 1.0f;
            self.layer.borderColor = [self borderColorWithStyle:style].CGColor;
        } break;
        default:
            break;
    }
    self.titleLabel.font = [self fontWithStyle:style];
   
}

#pragma mark - Private
- (UIImage *)normalBGImageWithStyle:(DSButtonStyle)style {
    UIColor *color = [self normalBgColorWithStyle:style];
    return [UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:color strokeColor:color];
}

- (UIImage *)hightBGImageWithStyle:(DSButtonStyle)style {
    UIColor *color = [self hightBgColorWithStyle:style];
    return [UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:color strokeColor:color];
}

- (UIImage *)disableBGImageWithStyle:(DSButtonStyle)style {
    UIColor *color = [self disableBgColorWithStyle:style];
    return [UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:color strokeColor:color];
}

- (UIColor *)normalBgColorWithStyle:(DSButtonStyle)style {
    UIColor *color = nil;
    switch (style) {
        case DSButtonStyleGreen: {
            color = [UIColor drColorC8];
        }
            break;
        case DSButtonStyleOrange: {
            color = [UIColor drColorC7];
        }
            break;
        default: {
            color = [UIColor drColorC8];
        }
    }
    return color;
}

- (UIColor *)borderColorWithStyle:(DSButtonStyle)style {
    UIColor *color = nil;
    switch (style) {
        case DSButtonStyleBorderGreen: {
            color = [UIColor drColorC8];
        }
            break;
        case DSButtonStyleBorderOrange: {
            color = [UIColor drColorC7];
        }
            break;
        default: {
            color = [UIColor drColorC0];
        }
    }
    return color;
}

- (UIColor *)hightBgColorWithStyle:(DSButtonStyle)style {
    UIColor *color = nil;
    switch (style) {
        case DSButtonStyleGreen: {
            color = [[UIColor drColorC8] colorWithAlphaComponent:0.5];
        }
            break;
        case DSButtonStyleOrange: {
            color = [[UIColor drColorC7] colorWithAlphaComponent:0.5];
        }
            break;
        default: {
            color = [[UIColor drColorC8] colorWithAlphaComponent:0.5];
        }
    }
    return color;
}

- (UIColor *)disableBgColorWithStyle:(DSButtonStyle)style {
    return [UIColor drColorC2];
}

- (UIFont *)fontWithStyle:(DSButtonStyle)style {
    UIFont *font = nil;
    switch (style) {
        case DSButtonStyleGreen:
        case DSButtonStyleOrange:
        case DSButtonStyleBorderWhite:
        case DSButtonStyleBorderOrange:
        case DSButtonStyleBorderGreen:
            font = [UIFont fontWithSize:15];
            break;
        default:
            break;
    }
    return font;
}

- (RACSignal *)eventSingal {
    return [self rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
