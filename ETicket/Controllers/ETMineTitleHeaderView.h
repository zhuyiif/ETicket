//
//  ETMineTitleHeaderView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/20.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETMineTitleHeaderView : UIView

@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;

- (RACSignal *)actionSignal;

@end
