//
//  ETCountryCode.h
//  ETicket
//
//  Created by chunjian wang on 2018/5/10.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Mantle.h>

@interface ETCountryCode : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *en;
@property (nonatomic) NSString *zh;
@property (nonatomic) NSString *locale;
@property (nonatomic) NSString *code;
@property (nonatomic) BOOL status;

@end
