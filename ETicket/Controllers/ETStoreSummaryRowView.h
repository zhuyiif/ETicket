//
//  ETStoreSummaryRowView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETBannerScrollView.h"

@interface ETStoreSummaryRowView : UIView

@property (nonatomic) ETBannerScrollView *bannerView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *summaryLabel;
@property (nonatomic) UILabel *avgPriceLabel;
@property (nonatomic) UILabel *addressLabel;
@property (nonatomic) UIButton *phoneButton;

@end
