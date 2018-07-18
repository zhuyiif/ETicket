//
//  UIViewController+Empty.h
//  ETicket
//
//  Created by chunjian wang on 2018/5/17.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ETEmptyViewPosition) {
    ETEmptyViewPositionNone, //full
    ETEmptyViewPositionTableViewHeader,//tableviewHeader
    ETEmptyViewPositionTableViewFooter//tabliewviewFooter
};

typedef BOOL(^returnBoolBlock)(void);

@interface UIViewController (Empty)

@property (nonatomic) BOOL isLoading;
@property (nonatomic) UIView *emptyView;
@property (nonatomic) returnBoolBlock isNodataBlock;

- (void)showEmptyView;
- (BOOL)hideEmptyView;

- (void)showErrorView:(NSInteger)errorCode;
- (void)hideErrorView;

- (void)setEmptyViewImageName:(NSString *)imageName title:(NSString *)title;
- (void)setEmptyViewPositionOnTableView:(ETEmptyViewPosition)position;

- (BOOL)isNodata;

@end
