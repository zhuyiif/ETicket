//
//  UIButton+Style.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ETButtonStyle) { // Define by button bgColor + size
    ETButtonStyleGreen,
    ETButtonStyleOrange,
    ETButtonStyleBlue,
    ETButtonStyleBorderGreen,
    ETButtonStyleBorderOrange,
    ETButtonStyleBorderWhite,
};

@interface UIButton (Style)


+ (instancetype)buttonWithStyle:(ETButtonStyle)style height:(CGFloat)height;
+ (instancetype)buttonWithNormalImage:(NSString *)normalImage hightImage:(NSString *)hightImage;

- (instancetype)initWithStyle:(ETButtonStyle)style height:(CGFloat)height;

- (RACSignal *)eventSingal;


@end
