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

+ (instancetype)buttonWithStyle:(ETButtonStyle)style height:(CGFloat)height {
    return [[UIButton alloc] initWithStyle:style height:height];
}

+ (instancetype)buttonWithNormalImage:(NSString *)normalImage hightImage:(NSString *)hightImage {
    UIButton *wechat = [UIButton new];
    [wechat setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [wechat setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    return wechat;
}

#pragma mark - Public

- (instancetype)initWithStyle:(ETButtonStyle)style height:(CGFloat)height {
    if (self = [super init]) {
        [self setStyle:style];
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setStyle:(ETButtonStyle)style {
    switch (style) {
        case ETButtonStyleRed:
        case ETButtonStyleBlue:
        case ETButtonStyleGreen: {
            [self setTitleColor:[UIColor drColorC0] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor drColorC0] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor drColorC0] forState:UIControlStateDisabled];
            [self setBackgroundImage:[self normalBGImageWithStyle:style] forState:UIControlStateNormal];
            [self setBackgroundImage:[self hightBGImageWithStyle:style] forState:UIControlStateHighlighted];
            [self setBackgroundImage:[self disableBGImageWithStyle:style] forState:UIControlStateDisabled];
        }
            break;
            
        case ETButtonStyleBorderGreen:
        case ETButtonStyleBorderOrange:
        case ETButtonStyleBorderBlue:
        case ETButtonStyleBorderWhite:{
            self.backgroundColor = [UIColor clearColor];
            [self setTitleColor:[self borderColorWithStyle:style] forState:UIControlStateNormal];
            [self setTitleColor:[[self borderColorWithStyle:style] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
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
- (UIImage *)normalBGImageWithStyle:(ETButtonStyle)style {
    UIColor *color = [self normalBgColorWithStyle:style];
    return [UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:color strokeColor:color];
}

- (UIImage *)hightBGImageWithStyle:(ETButtonStyle)style {
    UIColor *color = [self hightBgColorWithStyle:style];
    return [UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:color strokeColor:color];
}

- (UIImage *)disableBGImageWithStyle:(ETButtonStyle)style {
    UIColor *color = [self disableBgColorWithStyle:style];
    return [UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:color strokeColor:color];
}

- (UIColor *)normalBgColorWithStyle:(ETButtonStyle)style {
    UIColor *color = nil;
    switch (style) {
        case ETButtonStyleGreen: {
            color = [UIColor drColorC8];
        }
            break;
        case ETButtonStyleRed: {
            color = [UIColor drColorC17];
        }
            break;
        case ETButtonStyleBlue: {
            color = [UIColor drColorC10];
        }
            break;
        default: {
            color = [UIColor drColorC8];
        }
    }
    return color;
}

- (UIColor *)borderColorWithStyle:(ETButtonStyle)style {
    UIColor *color = nil;
    switch (style) {
        case ETButtonStyleBorderGreen: {
            color = [UIColor drColorC8];
        }
            break;
        case ETButtonStyleBorderOrange: {
            color = [UIColor drColorC7];
        }
            break;
        case ETButtonStyleBorderBlue: {
            color = [UIColor drColorC10];
        }
            break;
        default: {
            color = [UIColor drColorC0];
        }
    }
    return color;
}

- (UIColor *)hightBgColorWithStyle:(ETButtonStyle)style {
    UIColor *color = nil;
    switch (style) {
        case ETButtonStyleGreen: {
            color = [[UIColor drColorC8] colorWithAlphaComponent:0.5];
        }
            break;
        case ETButtonStyleRed: {
            color = [[UIColor drColorC17] colorWithAlphaComponent:0.5];
        }
            break;
        case ETButtonStyleBlue: {
            color = [[UIColor drColorC10] colorWithAlphaComponent:0.5];
        }
            break;
        default: {
            color = [[UIColor drColorC2] colorWithAlphaComponent:0.5];
        }
    }
    return color;
}

- (UIColor *)disableBgColorWithStyle:(ETButtonStyle)style {
    return [[UIColor drColorC0] colorWithAlphaComponent:0.3];
}

- (UIFont *)fontWithStyle:(ETButtonStyle)style {
    UIFont *font = nil;
    switch (style) {
        case ETButtonStyleGreen:
        case ETButtonStyleRed:
        case ETButtonStyleBorderWhite:
        case ETButtonStyleBorderOrange:
        case ETButtonStyleBorderGreen:
            font = [UIFont s03Font];
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
