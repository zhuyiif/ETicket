//
//  DSMineTVCell.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DSMineTVCell : UITableViewCell

@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic, assign) BOOL isHiddenSeparatorLine;
@property (nonatomic) UIView *unReadDot;

@end
