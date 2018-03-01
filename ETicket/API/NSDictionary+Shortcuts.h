//
//  NSDictionary+Shortcuts.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTotalRecordsKey @"totalElements"
#define kPageKey @"page"
#define kPageSize @"rows"
#define kItemsKey @"__items__"
#define kOriginalKey @"__originaldata__"
#define kLoadCacheKey @"__load_cache__"
#define kSingleRespone @"__single_response__"

@interface NSDictionary (list)

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger totalRecords;
@property (nonatomic, readonly) id originalData;
@property (nonatomic, readonly) BOOL loadCache;

@end

@interface NSDictionary(single)

@property(nonatomic,readonly) id response;

@end
