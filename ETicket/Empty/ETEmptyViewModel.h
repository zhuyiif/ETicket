//
//  ETEmptyViewModel.h
//  ETicket
//
//  Created by chunjian wang on 2018/5/17.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kEmptyModelTitleKey @"tipText"
#define kEmptyModelIconKey @"iconName"
#define kEmptyModelSubtitleKey @"subText"
#define kEmptyModelButtonTitleKey @"buttonTitle"
#define kEmptyModelFooterTitleKey @"footerTitle"

@interface ETEmptyViewModel : NSObject

@property (nonatomic) NSString *iconName;
@property (nonatomic) NSString *tipText;
@property (nonatomic) NSString *subText;
@property (nonatomic) NSString *buttonTitle;
@property (nonatomic) NSString *footerTitle;
@property (nonatomic) UIEdgeInsets contentInsets;

- (instancetype)initWithModel:(NSDictionary *)dic;

@end
