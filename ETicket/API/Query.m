//
//  Query.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <SDVersion/SDVersion.h>
#import "Query.h"
#import "AFHTTPSessionManager+RACSignal.h"
#import "RACSignal+Parse.h"


@interface Query ()

@property (nonatomic) NSString *method;
@property (nonatomic) NSString *path;
@property (nonatomic) NSString *listKey;
@property (nonatomic) Class modelClass;
@property (nonatomic, copy) void (^block)(id<AFMultipartFormData>);
@property (nonatomic) BOOL useJsonBody;

@end

@implementation Query

+ (instancetype)queryWithMethod:(NSString *)httpMethod path:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass headers:(id)headers constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block {
    Query *query = [[self alloc] init];
    query.method = httpMethod;
    query.path = path;
    query.parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    query.headers = [NSMutableDictionary dictionaryWithDictionary:headers];
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

+ (instancetype)GET:(NSString *)path parameters:(id)parameters headers:(id)headers {
    return [self GET:path parameters:parameters listKey:nil modelClass:nil headers:headers];
}

+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass {
    return [self GET:path parameters:parameters listKey:listKey modelClass:modelClass headers:nil];
}

+ (instancetype)GET:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass headers:(id)headers {
    return [self queryWithMethod:@"GET" path:path parameters:parameters listKey:listKey modelClass:modelClass headers:headers constructingBodyWithBlock:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters {
    return [self POST:path parameters:parameters listKey:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey {
    return [self POST:path parameters:parameters listKey:listKey modelClass:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters headers:(id)headers {
    return [self POST:path parameters:parameters listKey:nil modelClass:nil headers:headers];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass {
    return [self POST:path parameters:parameters listKey:listKey modelClass:modelClass headers:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters listKey:(NSString *)listKey modelClass:(Class)modelClass headers:(id)headers {
    return [self queryWithMethod:@"POST" path:path parameters:parameters listKey:listKey modelClass:modelClass headers:headers constructingBodyWithBlock:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block {
    return [self POST:path parameters:parameters constructingBodyWithBlock:block listKey:nil modelClass:nil];
}

+ (instancetype)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block listKey:(NSString *)listKey modelClass:(Class)modelClass {
    return [self queryWithMethod:@"POST" path:path parameters:parameters listKey:listKey modelClass:modelClass headers:nil constructingBodyWithBlock:block];
}

+ (instancetype)PUT:(NSString *)path parameters:(id)parameters {
    return [self queryWithMethod:@"PUT" path:path parameters:parameters listKey:nil modelClass:nil headers:nil constructingBodyWithBlock:nil];
}

+ (instancetype)PUT:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block {
    return [self queryWithMethod:@"PUT" path:path parameters:parameters listKey:nil modelClass:nil headers:nil constructingBodyWithBlock:block];
}

+ (instancetype)PUT:(NSString *)path parameters:(id)parameters headers:(id)headers {
    return [self queryWithMethod:@"PUT" path:path parameters:parameters listKey:nil modelClass:nil headers:headers constructingBodyWithBlock:nil];
}

+ (instancetype)DELETE:(NSString *)path parameters:(id)parameters {
    return [self queryWithMethod:@"DELETE" path:path parameters:parameters listKey:nil modelClass:nil headers:nil constructingBodyWithBlock:nil];
}

+ (instancetype)emptyQuery {
    return [[self alloc] init];
}

static id<QueryConfig> _config;
+ (void)setConfig:(id<QueryConfig>)config {
    _config = config;
}

+ (NSString *)baseURL {
    NSAssert([_config respondsToSelector:@selector(baseURL)], @"需要配置Config中的baseURL方法");
    return [_config baseURL];
}


- (RACSignal *)execute:(id)input manager:(AFHTTPSessionManager *)manager retry:(RACSignal *)retrySignal {
    assert(_path);
    
    id params = _parameters;
    if (input) { // input 是一次性的参数、覆盖但不影响初始化时设置的 parameters。
        params = [NSMutableDictionary dictionaryWithDictionary:_parameters]; // 无副作用
        [params addEntriesFromDictionary:input];
    }
    
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        serializer.removesKeysWithNullValues = YES;
        manager.responseSerializer = serializer;
    }
    
    // copy old request values
    AFHTTPRequestSerializer *request = manager.requestSerializer;
    if (self.useJsonBody) {
        manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    } else {
        manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    }
    manager.requestSerializer.timeoutInterval = request.timeoutInterval;
    [request.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    
    [manager.requestSerializer setValue:[Query currentUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    [_headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    RACSignal *fetchSignal = nil;
    if (_block) {
        fetchSignal = [manager POST:_path parameters:params constructingBodyWithBlock:_block];
    } else if ([_method isEqualToString:@"POST"]) {
        fetchSignal = [manager POST:_path parameters:params];
    } else if ([_method isEqualToString:@"DELETE"]) {
        fetchSignal = [manager DELETE:_path parameters:params];
    } else if ([_method isEqualToString:@"PUT"]) {
        fetchSignal = [manager PUT:_path parameters:params];
    } else {
        fetchSignal = [manager GET:_path parameters:params];
    }
    
    BOOL isJSONResponse = [manager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]];
    
    RACSignal *parseSignal = isJSONResponse ? [fetchSignal parse:_listKey modelClass:_modelClass] : fetchSignal;
    
    return retrySignal ? [parseSignal retryIfUnauthorized:retrySignal] : parseSignal;
}

- (RACSignal *)execute:(id)input retry:(RACSignal *)retrySignal {
    return [self execute:input manager:[_config respondsToSelector:@selector(networkManager)] ? [_config networkManager] : nil retry:retrySignal];
}

- (RACSignal *)execute:(id)input manager:(AFHTTPSessionManager *)manager {
    return [self execute:input manager:manager retry:[_config respondsToSelector:@selector(retrySignal)] ? [_config retrySignal] : nil];
}

- (RACSignal *)execute:(id)input {
    return [self execute:input retry:[_config respondsToSelector:@selector(retrySignal)] ? [_config retrySignal] : nil];
}

- (RACSignal *)loadCache:(id)input { 
    return [self execute:input manager:[_config respondsToSelector:@selector(cacheManager)] ? [_config cacheManager] : nil retry:nil];
}


- (RACSignal *)execute {
    return [self execute:nil];
}

- (RACSignal *)fetchImage {
    AFHTTPSessionManager *manager = [_config respondsToSelector:@selector(networkManager)] ? [[_config networkManager] copy] : [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    return [self execute:nil manager:manager];
}

- (RACSignal *)loadCache {
    return [self execute:nil manager:[_config respondsToSelector:@selector(cacheManager)] ? [_config cacheManager] : nil retry:nil];
}

- (Query *(^)(void))jsonQuery {
    return ^ {
        self.useJsonBody = YES;
        return self;
    };
}

+ (RACSignal *)loadCache:(NSArray<Query *> *)queries {
    return [RACSignal zip:[[queries rac_sequence] map:^(Query *value) {
        return [value loadCache];
    }]];
}

static NSString *_userAgent = nil;

+ (NSString *)currentUserAgent {
    if (!_userAgent) {
        _userAgent = [_config respondsToSelector:@selector(customUserAgent:)] ? [_config customUserAgent:[self defaultUserAgent]] : [self defaultUserAgent];
    }
    return _userAgent;
}

+ (NSString *)defaultUserAgent {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", infoDict[(__bridge NSString *)kCFBundleExecutableKey] ?: infoDict[(__bridge NSString *)kCFBundleIdentifierKey], infoDict[@"CFBundleShortVersionString"] ?: infoDict[(__bridge NSString *)kCFBundleVersionKey], [SDVersion deviceNameString], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
}

@end
