//
//  ETHotModel.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETHotModel : UIView

@property (nonatomic) NSString *actionLink;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imageName;

+ (instancetype)modelWithName:(NSString *)name link:(NSString *)link image:(NSString *)image;
@end
