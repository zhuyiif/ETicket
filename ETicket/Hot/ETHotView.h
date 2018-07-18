//
//  ETHotView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETHotModel.h"

@class  ETHotView;
@protocol ETHotViewDelegate <NSObject>

- (void)hotView:(ETHotView *)hotView selectedItem:(ETHotModel *)model;

@end

@interface ETHotView : UIView

@property (weak,nonatomic) id<ETHotViewDelegate> delegate;

- (void)updateModels:(NSArray<ETHotModel *> *) models;

@end
