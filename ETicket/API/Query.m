//
//  Query.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "Query.h"
#import "AFHTTPSessionManager+RACSignal.h"
#import "RACSignal+Parse.h"


@interface Query ()

@property (nonatomic) NSString *method;
@property (nonatomic) NSString *path;
@property (nonatomic) NSString *listKey;
@property (nonatomic) Class modelClass;
@property (nonatomic, copy) void (^block)(id<AFMultipartFormData>);

@end

@implementation Query

+ (instancetype)queryWithMethod:(NSString *)httpMethod path:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block {
    Query *query = [[self alloc] init];
    query.method = httpMethod;
    query.path = path;
    query.parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    query.listKey = listKey;
    query.block = block;
    query.modelClass = modelClass;
    return query;
}

+ (instancetype)GET:(NSString *)path parameters:(id)parameters {
    return [self GET:path parameters:parameters listKey:nil];
}
+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey {
    return [self GET:path parameters:parameters listKey:listKey modelClass:nil];
}

+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass {
    return [self queryWithMethod:@"GET" path:path parameters:parameters listKey:listKey modelClass:modelClass constructingBodyWithBlock:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters {
    return [self POST:path parameters:parameters listKey:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey {
    return [self POST:path parameters:parameters listKey:listKey modelClass:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass {
    return [self queryWithMethod:@"POST" path:path parameters:parameters listKey:listKey modelClass:modelClass constructingBodyWithBlock:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block {
    return [self queryWithMethod:@"POST" path:path parameters:parameters listKey:nil modelClass:nil constructingBodyWithBlock:block];
}

+ (instancetype)emptyQuery {
    return [[self alloc] init];
}

static id<QueryConfig> _config;
+ (void)setConfig:(id<QueryConfig>)config {
    _config = config;
}

- (RACSignal *)execute:(id)input manager:(AFHTTPSessionManager *)manager retry:(RACSignal *)retrySignal {
    if (!_path) {
        return [RACSignal return:nil];
    }

    id params = _parameters;
    if (input) { // input 是一次性的参数、覆盖但不影响初始化时设置的 parameters。
        params = [NSMutableDictionary dictionaryWithDictionary:_parameters]; // 无副作用
        [params addEntriesFromDictionary:input];
    }

    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    RACSignal *fetchSignal = nil;
    if (_block) {
        fetchSignal = [manager POST:_path parameters:params constructingBodyWithBlock:_block];
    } else if ([_method isEqualToString:@"POST"]) {
        fetchSignal = [manager POST:_path parameters:params];
    } else {
        fetchSignal = [manager GET:_path parameters:params];
    }

    RACSignal *parseSignal = [fetchSignal parse:_listKey modelClass:_modelClass];
    return retrySignal ? [parseSignal retryIfUnauthorized:retrySignal] : parseSignal;
}

- (RACSignal *)execute:(id)input retry:(RACSignal *)retrySignal {
    AFNetworkReachabilityStatus networkStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        NSError *error = [NSError errorWithDomain:@"Network Error"
                                             code:kNetworkErrorCode
                                         userInfo:@{ @"message": NSLocalizedString(@"网络已断开，请检查网络", nil) }];
        return [RACSignal error:error];
    }
    
    return [self execute:input manager:[_config respondsToSelector:@selector(networkManager)] ? [_config networkManager] : nil retry:retrySignal];
}

- (RACSignal *)execute:(id)input {
    return [self execute:input retry:[_config respondsToSelector:@selector(retrySignal)] ? [_config retrySignal] : nil];
}

- (RACSignal *)execute {
    return [self execute:nil];
}

- (RACSignal *)loadCache:(id)input {
    return [self execute:input manager:[_config respondsToSelector:@selector(cacheManager)] ? [_config cacheManager] : nil retry:nil];
}

+ (RACSignal *)loadCache:(NSArray<Query *> *)queries input:(id)input{
    return [RACSignal zip:[[queries rac_sequence] map:^(Query *value) {
        return [value loadCache:input];
    }]];
}

@end
