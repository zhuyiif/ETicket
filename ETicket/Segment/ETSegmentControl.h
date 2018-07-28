//
//  ETSegmentControl.h
//  ETicket
//
//  Created by chunjian wang on 2017/3/1.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETSegmentItem.h"

#define DefaultSegmentWidth kScreenWidth
#define DefaultSegmentHeight 40.0f

#define Default_Line_Height 2.0f
#define Default_Color [UIColor drColorC5]
#define Default_Highlight_Color [UIColor drColorC8]
#define Default_Line_Color [UIColor drColorC8]

@protocol ETSegmentControlDelegate <NSObject>

- (void)updateSegmentBarPosition;
- (void)segmentSelectAtIndex:(NSInteger)index animation:(BOOL)animation;

@end

@interface ETSegmentControl : UIView

@property (nonatomic, weak) id<ETSegmentControlDelegate> delegate;

@property (nonatomic, assign) BOOL segmentScrollEnable;
@property (nonatomic, assign) BOOL isInNaviBar;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat lineHeight; //底部高亮线高度
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

- (void)load;
- (void)scrollToRate:(CGFloat)rate;
- (void)refresh;

@end
