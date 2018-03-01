//
//  RACCommand+Additions.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "RACCommand+Additions.h"

@implementation RACCommand (Additions)

+ (instancetype)commandWithQueries:(NSArray<id<Executable>> *)queries until:(RACSignal *)cancelSignal {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *inner = [RACSignal zip:[[queries rac_sequence] map:^(Query *value) {
            return [value execute:input];
        }]];
        return cancelSignal ? [inner takeUntil:cancelSignal] : inner;
    }];
}

+ (instancetype)commandWithQuery:(id<Executable>)query until:(RACSignal *)cancelSignal {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            RACSignal *cacheSingal = [query loadCache:input];
            RACSignal *networkSingal = [query execute:input];
            networkSingal = cancelSignal ? [networkSingal takeUntil:cancelSignal] : networkSingal;
            cacheSingal = cancelSignal ? [cacheSingal takeUntil:cancelSignal] : cacheSingal;
            
            [cacheSingal subscribeNext:^(NSDictionary *x) {
                [subscriber sendNext:x];
                [networkSingal subscribeNext:^(NSDictionary *value) {
                    NSString *cacheString = [self jsonWithObject:x.originalData];
                    NSString *netString = [self jsonWithObject:value.originalData];
                    if (![cacheString isEqualToString:netString]) {
                        [subscriber sendNext:value];
                    }
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                } completed:^{
                    [subscriber sendCompleted];
                }];
            } error:^(NSError *error) {
                [networkSingal subscribe:subscriber];
            }];
            
            return nil;
        }];
        return cancelSignal ? [signal takeUntil:cancelSignal] : signal;
    }];
}

+ (NSString*)jsonWithObject:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
