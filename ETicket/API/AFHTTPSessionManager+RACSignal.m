//
//  AFHTTPSessionManager+RACSignal.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "AFHTTPSessionManager+RACSignal.h"
NSString *const RACAFNResponseObjectErrorKey = @"responseObject";
@implementation AFHTTPSessionManager (RACSignal)

- (RACSignal *)GET:(NSString *)path parameters:(id)parameters {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // 为支持分页的 hack，可在服务端添加，只针对 GET，容器必须 NSJSONReadingMutableContainers
            if (parameters[@"page"]) {
                responseObject[@"data"][@"page"] = parameters[@"page"];
            }
            // end of hack
            
            [subscriber sendNext:RACTuplePack(responseObject, task.response)];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)POST:(NSString *)path parameters:(id)parameters {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [subscriber sendNext:RACTuplePack(responseObject, task.response)];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self POST:path parameters:parameters constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [subscriber sendNext:RACTuplePack(responseObject, task.response)];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)HEAD:(NSString *)path parameters:(id)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"HEAD"]
            setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, path, parameters];
}


- (RACSignal *)PUT:(NSString *)path parameters:(id)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"PUT"]
            setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)PATCH:(NSString *)path parameters:(id)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"PATCH"]
            setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)DELETE:(NSString *)path parameters:(id)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"DELETE"]
            setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

        NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                NSError *errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:[userInfo copy]];
                [subscriber sendError:errorWithRes];
            } else {
                [subscriber sendNext:RACTuplePack(responseObject, response)];
                [subscriber sendCompleted];
            }
        }];
        [task resume];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
@end
