//
//  ETAccountPresenter.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETAccountPresenter.h"

@implementation ETAccountPresenter

- (RACSignal *)fetchVerificationCode:(NSString *)phone {
    if (![phone isMobile]) {
        [ETPopover showFailureWithContent:NSLocalizedString(@"手机号错误", nil)];
        return [RACSignal error:nil];
    }
    return [[APICenter postSMS:@{ @"mobile": phone }] execute];
    
}

@end
