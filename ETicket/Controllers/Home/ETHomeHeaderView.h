//
//  ETHomeHeaderView.h
//  ETicket
//
//  Created by chunjian wang on 2018/3/3.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETHomeBannerView.h"
#import "ETAnouncementScrollView.h"
#import "ETHotView.h"
#import "ETHomeCardView.h"

@interface ETHomeHeaderView : UIView

@property (nonatomic) ETHomeBannerView *bannerView;
@property (nonatomic) ETAnouncementScrollView *announceView;
@property (nonatomic) ETHomeCardView *cardView;
@property (nonatomic) ETHotView *hotView;
@property (nonatomic) UIImageView *midImageView;

@end
