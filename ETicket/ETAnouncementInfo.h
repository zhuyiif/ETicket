//
//  SLBannerAnouncementModel.h
//  ETicket
//
//  Created by chunjian wang on 1/12/17.
//
//

#import <Mantle/Mantle.h>

@interface ETAnounceType : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *level;
@property (nonatomic) NSString *descriptionString;

@end

@interface ETAnouncementInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSDate *createTime;
@property (nonatomic) NSDate *updateTime;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger readnum;
@property (nonatomic) BOOL sorting;

@end
