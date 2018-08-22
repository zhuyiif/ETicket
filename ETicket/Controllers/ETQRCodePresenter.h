//
//  ETQRCodePresenter.h
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETQRCodePresenter : NSObject

@property (nonatomic) NSString *sourceCode;

- (RACSignal *)refresh;

@end
