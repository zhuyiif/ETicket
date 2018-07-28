//
//  ETSegmentItem.h
//  ETicket
//
//  Created by chunjian wang on 2017/3/1.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Item_Padding 20.0f
#define Default_Title_Font [UIFont fontWithSize:16]
#define Hilight_Title_Font [UIFont fontWithSize:22]


@interface ETSegmentItem : UIButton

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

- (void)refresh;
+ (BOOL)isStringEmpty:(NSString *)text;
+ (CGFloat)caculateWidthWithtitle:(NSString *)title titleFont:(UIFont *)titleFont;

@end
