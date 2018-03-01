//
//  UIButton+Style.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DSButtonStyle) { // Define by button bgColor + size
    DSButtonStyleGreen,
    DSButtonStyleOrange,
    DSButtonStyleBorderGreen,
    DSButtonStyleBorderOrange,
    DSButtonStyleBorderWhite,
};

@interface UIButton (Style)


+ (instancetype)buttonWithStyle:(DSButtonStyle)style height:(CGFloat)height;
+ (instancetype)buttonWithNormalImage:(NSString *)normalImage hightImage:(NSString *)hightImage;

- (instancetype)initWithStyle:(DSButtonStyle)style height:(CGFloat)height;

- (RACSignal *)eventSingal;


@end
