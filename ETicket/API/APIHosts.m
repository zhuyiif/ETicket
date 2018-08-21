//
//  APIHosts.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "APIHosts.h"
#import "NSDate+Formater.h"
#import <MF_Base64Additions.h>
#import "NSString+Additions.h"

#if CONFIG_DEVELOPMENT_ONLY

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}

@end

#endif

static NSString *gHosts[] = {
    @"https://scan-app.funenc.com",
};

static NSString *gCMSHosts[] = {
    @"https://operator-app.funenc.com",
};

static APIHosts *instance = nil;

#if CONFIG_DEVELOPMENT_ONLY
static NSInteger gIndex = 0;
#else
static NSInteger gIndex = 0;
#endif

@implementation APIHosts

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APIHosts alloc] init];
    });
    return instance;
}

+ (NSInteger)count {
    return sizeof(gHosts) / sizeof(gHosts[0]);
}

+ (NSString *)URLAtIndex:(NSInteger)index {
    return gHosts[index];
}

+ (NSString *)defaultURL {
    return gHosts[gIndex];
}

+ (NSString *)cmsURL {
    return gCMSHosts[gIndex];
}

+ (void)setDefaultURLWithIndex:(NSInteger)index {
    gIndex = index;
    // reset
    _cacheManager = nil;
    _networkManager = nil;
}

#pragma mark -
-(AFHTTPSessionManager *)defaultManager {
    AFHTTPSessionManager *client = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[APIHosts defaultURL]]];
    client.requestSerializer.timeoutInterval = 60;
    // custom header 1: 每次创建时设置即可
    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [client.requestSerializer setValue:uuid forHTTPHeaderField:@"ASI-UUID"];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    serializer.removesKeysWithNullValues = YES;
    client.responseSerializer = serializer;
    return client;
}

static AFHTTPSessionManager *_cacheManager;

- (AFHTTPSessionManager *)cacheManager {
    if (!_cacheManager) {
        _cacheManager = [self defaultManager];
        _cacheManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
    }
    
    [_networkManager.requestSerializer setValue:[ETActor instance].token ?:@"" forHTTPHeaderField:@"app-token"];
    return _cacheManager;
}

static AFHTTPSessionManager *_networkManager;
- (AFHTTPSessionManager *)networkManager {
    if (!_networkManager) {
        _networkManager = [self defaultManager];
        _networkManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    
    // custom header 2: 必须每次使用时设置
    [_networkManager.requestSerializer setValue:[ETActor instance].token ?:@"" forHTTPHeaderField:@"app-token"];
    return _networkManager;
}

- (RACSignal *)retrySignal {
    return [RACSignal retrySignal];
}

@end
