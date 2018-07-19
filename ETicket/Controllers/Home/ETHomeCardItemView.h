//
//  ETHomeCardItemView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETHighlightedStyleControl.h"

@interface ETHomeCardItemView : ETHighlightedStyleControl

@property (nonatomic) UIImageView *iconView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) UILabel *moreLabel;

@end
