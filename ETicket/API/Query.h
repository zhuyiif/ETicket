//
//  Query.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>

#import "RACCommand+Additions.h"

@protocol QueryConfig <NSObject>

@optional
- (AFHTTPSessionManager *)networkManager; // use `[AFHTTPSessionManager manager]` if not implemented
- (AFHTTPSessionManager *)cacheManager; // use `[AFHTTPSessionManager manager]` if not implemented
- (RACSignal *)retrySignal; // no retry if not implemented

@end


@interface Query : NSObject <Executable>

+ (instancetype)GET:(NSString *)path parameters:(id)parameters;
+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey;
+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass;

+ (instancetype)POST:(NSString *)path parameters:(id)parameters;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block;

+ (instancetype)emptyQuery;

+ (void)setConfig:(id<QueryConfig>)config;

@property (nonatomic) NSMutableDictionary *parameters;

// cold
- (RACSignal *)execute;
- (RACSignal *)execute:(id)input; // input 是一次性的 parameters
- (RACSignal *)execute:(id)input retry:(RACSignal *)retrySignal;
- (RACSignal *)execute:(id)input manager:(AFHTTPSessionManager *)manager retry:(RACSignal *)retrySignal;
- (RACSignal *)loadCache:(id)input;

// batch
+ (RACSignal *)loadCache:(NSArray<Query *> *)queries input:(id)input;

@end
