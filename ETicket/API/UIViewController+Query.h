//
//  UIViewController+Query.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 此接口屏蔽 RAC 的概念，沿用比较熟悉的 block。
@interface UIViewController (Query)

// 触发一个异步操作，如加载数据。
- (void)reload;

// 加入了时间间隔的检查，适合在 viewWillAppear: 中调用
- (void)reloadIfNeeded;

@property (nonatomic, copy, readonly) void (^errorHandler)(NSError *);

// showHeaderXXX 只对包含 tableView/collectionView/scrollView 的 UIViewController 有作用
// 不一定限于 UITableViewController or UICollectionViewController

// convenience: 是否单数(Query or Queries) X 是否有尾部刷新(Header or HeaderAndFooter) X 是否使用缺省的错误处理 (errorHandler) = 共 8 种组合
- (RACCommand *)showHeaderWithQuery:(Query *)query contentHandler:(void (^)(id content))contentHandler;

- (RACCommand *)showHeaderWithQuery:(Query *)query contentHandler:(void (^)(id content))contentHandler errorHandler:(void (^)(NSError *error))errorHandler;

- (RACCommand *)showHeaderAndFooterWithQuery:(Query *)query contentHandler:(void (^)(id content))contentHandler;

- (RACCommand *)showHeaderAndFooterWithQuery:(Query *)query contentHandler:(void (^)(id content))contentHandler errorHandler:(void (^)(NSError *error))errorHandler;
// 复数
- (RACCommand *)showHeaderWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id content))contentHandler;

- (RACCommand *)showHeaderWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id content))contentHandler errorHandler:(void (^)(NSError *error))errorHandler;

- (RACCommand *)showHeaderAndFooterWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id content))contentHandler;

- (RACCommand *)showHeaderAndFooterWithQueries:(NSArray<Query *> *)queries contentHandler:(void (^)(id content))contentHandler errorHandler:(void (^)(NSError *error))errorHandler;

@end
