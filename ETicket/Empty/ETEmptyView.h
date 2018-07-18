//
//  ETEmptyView.h
//  ETicket
//
//  Created by chunjian wang on 2018/5/17.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETEmptyViewModel.h"

#define kDefaultTitleText  NSLocalizedString(@"您当前暂无记录",nil)

@interface ETEmptyView : UIView

@property (nonatomic) void(^footerClickedBlock)(void);
@property (nonatomic) void(^subTitleClickedBlock)(void);
@property (nonatomic, readonly) UILabel *footerLabel;

- (instancetype)initWithClickBlock:(void (^)(void))block;
- (instancetype)initWithModel:(ETEmptyViewModel *)model clickBlock:(void (^)(void))block;

@end

@interface ETEmptyView (NetworkError)

+ (instancetype)networkErrorView;

@end

@interface ETEmptyView (ServiceError)

+ (instancetype)serviceErrorView;

@end
