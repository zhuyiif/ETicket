//
//  UIView+SepLine.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UIViewAddSepLineStyle) {
    UIViewAddSepLineStyleNone = 0,
    UIViewAddSepLineStyleLeft = 1 << 0,
    UIViewAddSepLineStyleRight = 1 << 1,
    UIViewAddSepLineStyleTop = 1 << 2,
    UIViewAddSepLineStyleBottom = 1 << 3
};

@interface UIView (SepLine)

@property (nonatomic) UIViewAddSepLineStyle sepLineStyle;
@property (nonatomic) UIColor *sepLineColor;

@end
