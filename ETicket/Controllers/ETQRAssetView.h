//
//  ETQRAssetView.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETQRAssetView : UIView

@property (nonatomic) UILabel *balanceLabel;
@property (nonatomic) UILabel *mileageLabel;

- (void)updateWithBalance:(NSNumber *)balance miles:(NSNumber *)miles;

@end
