//
//  RACSignal+Parse.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (Parse)

/*
 解析应用层 Payload
 input: (responseObject, response): RACTuple<id, NSURLResponse *> (from AFNetworking-RACExtensions)
 output: responseObject.content / error
 */
- (RACSignal *)parse;
- (RACSignal *)parse:(NSString *)listKey modelClass:(Class)itemClass;

/*
 看到特定的 error 会 retry
 error: error.userInfo.result == "login"
 */
- (RACSignal *)retryIfUnauthorized:(RACSignal *)retrySignal;

// 累加
- (RACSignal *)accumulated;

@end

