//
//  DSAccountPresenter.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSAccountPresenter.h"

@implementation DSAccountPresenter

- (void)fetchVerificationCode:(NSString *)phone {
    if (![phone isMobile]) {
        [DSPopover showFailureWithContent:NSLocalizedString(@"手机号错误", nil)];
        return;
    }
    [DSPopover showLoading:YES];
    [[[APICenter postSMS:@{ @"mobile": phone }] execute] subscribeNext:^(id x) {
        [DSPopover showLoading:NO];
        [DSPopover showSuccessWithContent:NSLocalizedString(@"发送成功", nil)];
    } error:^(NSError *error) {
        [DSPopover showFailureWithContent:error.message];
    }];
    
}

@end
