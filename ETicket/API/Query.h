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
// 获取BaseURL
- (NSString *)baseURL;

// use `[AFHTTPSessionManager manager]` if not implemented
- (AFHTTPSessionManager *)networkManager;

// use `[AFHTTPSessionManager manager]` if not implemented
- (AFHTTPSessionManager *)cacheManager;

// no retry if not implemented
- (RACSignal *)retrySignal;

// 定制UserAgent，参数为默认生成的UA
- (NSString *)customUserAgent:(NSString *)defaultUserAgent;

@end


@interface Query : NSObject <Executable>

+ (instancetype)GET:(NSString *)path parameters:(id)parameters;
+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey;
+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass;
+ (instancetype)GET:(NSString *)path parameters:(id)parameters headers:(id)headers;

+ (instancetype)POST:(NSString *)path parameters:(id)parameters;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block listKey:(NSString *)listKey modelClass:(Class)modelClass;
+ (instancetype)POST:(NSString *)path parameters:(id)parameters headers:(id)headers;

+ (instancetype)PUT:(NSString *)path parameters:(id)parameters;
+ (instancetype)PUT:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block;
+ (instancetype)PUT:(NSString *)path parameters:(id)parameters headers:(id)headers;


+ (instancetype)DELETE:(NSString *)path parameters:(id)parameters;

+ (instancetype)emptyQuery;

+ (void)setConfig:(id<QueryConfig>)config;

+ (NSString *)baseURL;

+ (NSString *)cmsURL;

@property (nonatomic) NSMutableDictionary *parameters;
@property (nonatomic) NSMutableDictionary *headers;

// cold
- (RACSignal *)execute;
- (RACSignal *)execute:(id)input; // input 是一次性的 parameters
- (RACSignal *)execute:(id)input retry:(RACSignal *)retrySignal;
- (RACSignal *)execute:(id)input manager:(AFHTTPSessionManager *)manager retry:(RACSignal *)retrySignal;

// 下载图片
- (RACSignal *)fetchImage;

- (RACSignal *)loadCache;

- (Query *(^)(void))jsonQuery;

// batch
+ (RACSignal *)loadCache:(NSArray<Query *> *)queries;

@end

