//
//  ETBannerScrollView.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETBannerInfo.h"
#import "ETPageIndicator.h"

@interface ETBannerScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic) BOOL isLoaded;
@property (nonatomic) BOOL loadImageFailed;
@property (nonatomic) BOOL isHeadBanner;
@property (nonatomic) ETPageIndicator *pageIndicator;
@property (nonatomic) BOOL isHorizontal;
@property (nonatomic) UIScrollView *scrollView;

- (void)setBanners:(NSArray<ETBannerInfo *> *)items;
- (void)invalidate; // performSelector:withObject:afterDelay: keeps retaining this view

@end
