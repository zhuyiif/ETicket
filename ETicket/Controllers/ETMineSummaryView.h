//
//  ETMineSummaryView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/25.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETMineSummaryView : UIView

@property (nonatomic) UILabel *mileageLabel;
@property (nonatomic) UILabel *balanceLabel;
@property (nonatomic) UILabel *honourLabel;

- (void)updateWithMileage:(NSNumber *)mileage balance:(NSNumber *) balance honour:(NSNumber *)honour;

@end
