//
//  ETSignupItem.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ETSignupItem : MTLModel <MTLJSONSerializing, NSCoding, NSCopying>

@property (nonatomic) NSString *accessType;
@property (nonatomic) NSString *nickname;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *verifyCode;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *email;
@property (nonatomic) NSDate *birthDay;
@property (nonatomic) BOOL gender;

@end
