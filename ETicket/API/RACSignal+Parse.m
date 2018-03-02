//
//  RACSignal+Parse.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "RACSignal+Parse.h"

@implementation NSMutableDictionary (Combine)

- (void)combineEntriesFromDictionary:(NSDictionary *)x {
    [x enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]] && [self[key] isKindOfClass:[NSMutableArray class]]) {
            [self[key] addObjectsFromArray:obj];
        } else {
            self[key] = obj;
        }
    }];
}

@end

@implementation RACSignal (Parse)
- (RACSignal *)parse {
    return [self parse:nil modelClass:nil];
}

static NSString *const kParseError = @"ParseError";
static NSInteger const kParseErrorCode = 555;
// 只能解析 AFNetworking-RACExtensions 中的返回
- (RACSignal *)parse:(NSString *)listKey modelClass:(__unsafe_unretained Class)modelClass {
    return [self flattenMap:^(RACTuple *x) {
        id responseObject = x.first;
        if (!responseObject[@"msg"]) {
            NSMutableDictionary *content = responseObject;
            
            if (listKey) { // normalize to __items__
                // 设计一致的 API，此处的 listKey 应该是固定的，无需作为参数到处传递。
                if (!content[@"totalRecords"] && !content[@"totalCount"] && !content[@"count"]) {
                    NSLog(@"warning: no paging support %@", [x.second URL]);
                }
                
                if (modelClass && content[listKey]) {
                    NSError *error = nil;
                    id objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:content[listKey] error:&error];
                    if (error) {
                        return [RACSignal error:[NSError errorWithDomain:kParseError code:kParseErrorCode userInfo:responseObject]];
                    }
                    content[kItemsKey] = objects;
                } else {
                    content[kItemsKey] = content[listKey];
                }
                [content removeObjectForKey:listKey];
            } else if (modelClass) {
                NSError *error = nil;
                id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:content error:&error];
                if (error) {
                    return [RACSignal error:[NSError errorWithDomain:kParseError code:kParseErrorCode userInfo:responseObject]];
                }
                return [RACSignal return:object];
            }
            return [RACSignal return:content];
        }
        
        // 应用层的错误也会转化为 error，具体应该忽略、弹警告、显示还是弹登录等等，是一下个 subscriber 该处理的。
        id errors = responseObject[@"errors"];
        if ([errors count]) {
            responseObject[NSLocalizedDescriptionKey] = [errors componentsJoinedByString:@"\n"];
        }
        NSInteger code = [responseObject[@"code"] integerValue];
        NSError *error = [NSError errorWithDomain:responseObject[@"msg"] ?: @"EmptyResultError" code:code userInfo:responseObject];
        return [RACSignal error:error];
    }];
}
// 只能解析 parse: 后的 error
- (RACSignal *)retryIfUnauthorized:(RACSignal *)retrySignal {
    assert(retrySignal);
    return [[self materialize] flattenMap:^(RACEvent *event) {
        if ((event.eventType == RACEventTypeError && [event.error.userInfo[@"result"] isEqualToString:@"login"] )|| event.error.code == 400001) { //
            return [retrySignal flattenMap:^(id value) {
                // 成功登录后，再试一次刚才的请求。
                return [value boolValue] ? [self retryIfUnauthorized:retrySignal] : [RACSignal error:event.error];
            }];
        }
        return [[RACSignal return:event] dematerialize];
    }];
}

// 只能解析 parse: 后的 content，AFNetworking 一律返回 mutable 容器
- (RACSignal *)accumulated {
    __block id acc = nil; // accumulator 累加器
    return [self map:^(id x) {
        if (!acc) {
            acc = x;
            return acc;
        }
        
        if ([x isKindOfClass:[RACTuple class]]) {
            if ([x[0] page] == [acc[0] page] + 1) {
                [acc[0] combineEntriesFromDictionary:x[0]];
            } else {
                // RACTuple 不支持直接替换
                acc = x;
            }
        } else {
            if ([x page] == [acc page] + 1) {
                [acc combineEntriesFromDictionary:x];
            } else {
                acc = x;
            }
        }
        return acc;
    }];
}

@end
