//
//  ETHotItemView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHighlightedStyleControl.h"

@interface ETHotItemView : ETHighlightedStyleControl

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *iconView;

- (RACSignal *)eventSignal;

@end
