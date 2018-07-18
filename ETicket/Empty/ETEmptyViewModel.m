//
//  ETEmptyViewModel.m
//  ETicket
//
//  Created by chunjian wang on 2018/5/17.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETEmptyViewModel.h"

@implementation ETEmptyViewModel

- (id)init {
    if (self = [super init]) {
        self.contentInsets = UIEdgeInsetsMake(60, 0, 30, 0);
    }
    return self;
}

- (instancetype)initWithModel:(NSDictionary *)dic {
    if (self = [super init]) {
        self.tipText = dic[kEmptyModelTitleKey];
        self.iconName = dic[kEmptyModelIconKey];
        self.subText = dic[kEmptyModelSubtitleKey];
        self.buttonTitle = dic[kEmptyModelButtonTitleKey];
        self.footerTitle = dic[kEmptyModelFooterTitleKey];
        self.contentInsets = UIEdgeInsetsMake(60, 0, 30, 0);
    }
    return self;
}

@end
