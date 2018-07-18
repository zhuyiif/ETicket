//
//  ETHotModel.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHotModel.h"

@implementation ETHotModel

+ (instancetype)modelWithName:(NSString *)name link:(NSString *)link image:(NSString *)image {
    ETHotModel *model = [ETHotModel new];
    model.name = name;
    model.actionLink = link;
    model.imageName = image;
    return model;
}

@end
