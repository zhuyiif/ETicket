//
//  AFHTTPSessionManager+RACSignal.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AFHTTPSessionManager (RACSignal)

- (RACSignal *)GET:(NSString *)path parameters:(id)parameters;
- (RACSignal *)POST:(NSString *)path parameters:(id)parameters;
- (RACSignal *)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block;
- (RACSignal *)HEAD:(NSString *)path parameters:(id)parameters;
- (RACSignal *)PUT:(NSString *)path parameters:(id)parameters;
- (RACSignal *)PATCH:(NSString *)path parameters:(id)parameters;
- (RACSignal *)DELETE:(NSString *)path parameters:(id)parameters;
@end
