//
//  RACCommand+Additions.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

@protocol Executable <NSObject>

- (RACSignal *)execute:(id)input;
- (RACSignal *)loadCache:(id)input;

@end

@interface RACCommand (Additions)

+ (instancetype)commandWithQueries:(NSArray<id<Executable>> *)queries until:(RACSignal *)cancelSignal;
+ (instancetype)commandWithQuery:(id<Executable>)query until:(RACSignal *)cancelSignal;

@end
