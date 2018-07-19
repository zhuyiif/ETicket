//
//  ETHomeNewsTVCell.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/19.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETHomeNewsTVCell : UITableViewCell

@property (nonatomic) UIImageView *coverView;
@property (nonatomic) UIImageView *authorIcon;
@property (nonatomic) UIImageView *seeCountIcon;
@property (nonatomic) UIButton *likeButton;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *seeCountLabel;
@property (nonatomic) UILabel *authorLabel;

@end
