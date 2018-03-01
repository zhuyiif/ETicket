//
//  NSDictionary+Shortcuts.m
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "NSDictionary+Shortcuts.h"

@implementation NSDictionary (list)

- (NSArray *)items {
    return self[kItemsKey];
}

- (NSInteger)page {
    return [self[kPageKey] integerValue];
}

- (NSInteger)totalRecords {
    return [self[kTotalRecordsKey] integerValue];
}

- (BOOL)loadCache {
    return [self[kLoadCacheKey] boolValue];
}

- (id)originalData {
    return self[kOriginalKey];
}

@end

@implementation NSDictionary(single)

- (id)response {
    return self[kSingleRespone];
}

@end
