//
//  ETLoadingView.h
//  ETicket
//
//  Created by chunjian wang on 2017/5/2.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETLoadingView : UIView

@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UILabel *textLabel;
@property (nonatomic,readonly) BOOL hiding;

- (void)show;
- (void)show:(void (^)(void))completion;
- (void)hide:(void (^)(void))completion;
- (void)hide:(void (^)(void))completion isAnimate:(BOOL)isAnimate;

@end
