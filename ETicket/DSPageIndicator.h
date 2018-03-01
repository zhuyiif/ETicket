//
//  DSPageIndicator.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSPageIndicator : UIView<UIScrollViewDelegate>

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *highlightedColor;

@end
