//
//  ETAlipayRSASigner.h
//  ETicket
//
//  Created by chunjian wang on 2018/3/2.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETAlipayRSASigner : NSObject

- (id)initWithPrivateKey:(NSString *)privateKey;
- (NSString *)signString:(NSString *)string withRSA2:(BOOL)rsa2;

@end
