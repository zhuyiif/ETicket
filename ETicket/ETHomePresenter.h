//
//  ETHomePresenter.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETBannerInfo.h"
#import "ETAnouncementInfo.h"

@interface ETHomePresenter : NSObject

@property (nonatomic) NSArray<ETBannerInfo *> *banners;
@property (nonatomic) NSArray<ETAnouncementInfo *> *announces;

- (void)setupRequestWithController:(UIViewController *)controller;

@end
