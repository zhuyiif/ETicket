//
//  ETUser.h
//  ETicket
//
//  Created by chunjian wang on 2018/7/25.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Mantle.h>

@interface ETUser : MTLModel<MTLJSONSerializing>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *phone;
@property (nonatomic) BOOL isBlack;
@property (nonatomic) NSString *appToken;

@end
