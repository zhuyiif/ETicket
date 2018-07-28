//
//  ETMineHeaderView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/25.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETMineHeaderView : UIView

@property (nonatomic) UIButton *loginButton;
- (void)updateStyle:(BOOL)logined;

@end
