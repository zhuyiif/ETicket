//
//  ETAccountPresenter.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETAccountPresenter.h"

@implementation ETAccountPresenter

- (void)fetchVerificationCode:(NSString *)phone {
    if (![phone isMobile]) {
        [ETPopover showFailureWithContent:NSLocalizedString(@"手机号错误", nil)];
        return;
    }
    [ETPopover showLoading:YES];
    [[[APICenter postSMS:@{ @"mobile": phone }] execute] subscribeNext:^(id x) {
        [ETPopover showLoading:NO];
        [ETPopover showSuccessWithContent:NSLocalizedString(@"发送成功", nil)];
    } error:^(NSError *error) {
        [ETPopover showFailureWithContent:error.message];
    }];
    
}

@end
