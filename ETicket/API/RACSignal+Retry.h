//
//  RACSignal+Retry.h
///  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (Retry)

+ (RACSignal *)retrySignal;

@end
