//
//  SLBannerAnouncementModel.h
//  ETicket
//
//  Created by chunjian wang on 1/12/17.
//
//

#import <Mantle/Mantle.h>


@interface ETAnouncementInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger viewCount;
@property (nonatomic) BOOL top;

@end
