//
//  ETBannerInfo.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ETBannerInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *cover;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *url;

@end
