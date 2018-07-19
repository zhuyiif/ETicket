//
//  ETSegmentBar.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/19.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETSegmentModel.h"

@class ETSegmentBar;

@protocol ETSegmentBarDelegate <NSObject>

- (void)onSegemnetBar:(ETSegmentBar *)segmentBar itemSeleced:(ETSegmentModel *)model;

@end

@interface ETSegmentBar : UIView

@property (nonatomic,weak) id<ETSegmentBarDelegate> delegate;

- (void)updateWithModels:(NSArray<ETSegmentModel *> *)models;

@end
