//
//  DSHomePresenter.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSBannerInfo.h"

@interface DSHomePresenter : NSObject

@property (nonatomic) NSArray<DSBannerInfo *> *banners;

- (void)setupRequestWithController:(UIViewController *)controller;

@end
