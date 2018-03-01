//
//  DSCountryCodeView.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSCountryCodeView : UIView

+ (void)showWithCode:(NSString *)countryCode completeBlock:(void (^)(NSString *countryCode))completeBlock;

@end
