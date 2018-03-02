//
//  APIHosts.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "Query.h"

@interface APIHosts :NSObject <QueryConfig>

+(instancetype)sharedInstance;
+ (NSInteger)count;
+ (NSString *)URLAtIndex:(NSInteger)index;
+ (NSString *)defaultURL;
+ (void)setDefaultURLWithIndex:(NSInteger)index;

@end
