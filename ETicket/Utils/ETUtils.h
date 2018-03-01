//
//  ETUtils.h
//  ETicket
//
//  Created by chunjian wang on 2018/3/1.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETUtils : NSObject

+ (void)makeCallWithPhone:(NSString *)phone view:(UIView *)superView;
+ (UIImage *)generateQRCodeImage:(NSString *)source;

@end
