//
//  ETPayHelper.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/2.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETPayHelper.h"
#import "ETAlipayOrder.h"
#import "ETUtils.h"
#import "ETAlipayRSASigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APICenter.h"

static ETPayHelper *instance = nil;

@implementation ETPayHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ETPayHelper new];
    });
    return instance;
}

- (RACSignal *)payWithAmount:(NSNumber *)amount {
    return [self payWithAmount:amount subject:@"地铁票" content:@"快捷支付"];
}

- (RACSignal *)payWithAmount:(NSNumber *)amount subject:(NSString *)subject content:(NSString *)content {
    if (!amount) {
        return [RACSignal error:[NSError errorWithDomain:@"alipay" code:-10001 userInfo:@{ @"message": NSLocalizedString(@"支付金额无效", nil) }]];
    }
    return [[[[[APICenter getPaymentSN:nil] execute] map:^id(id value) {
        return [ETUtils generateAlipayTradeNO];
    }] flattenMap:^RACStream *(id value) {
        ETAlipayOrder *order = [ETAlipayOrder orderWithTitle:subject body:content amount:amount tradeNo:value];
        return [self alipayWithOrder:order];
    }] flattenMap:^RACStream *(id value) {
        return [[APICenter postPaymentConfirmation:nil] execute];
    }];
}

- (RACSignal *)alipayWithOrder:(ETAlipayOrder *)order {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSLog(@"orderSpec = %@",orderInfo);
        ETAlipayRSASigner* signer = [[ETAlipayRSASigner alloc] initWithPrivateKey:kAlipayRSAPrivate];
        NSString *signedString = [signer signString:orderInfo withRSA2:YES];
        // NOTE: 如果加签成功，则继续执行支付
        if ([NSString isBlankString:signedString]) {
            [subscriber sendError:[NSError errorWithDomain:@"alipay" code:-10002 userInfo:@{ @"message": NSLocalizedString(@"签名验证失败", nil) }]];
            return nil;
        }
        
        NSString *appScheme = @"ETicket";
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",[order orderInfoEncoded:YES], signedString];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSNumber *status = resultDic[@"resultStatus"];
            if (status.integerValue == 9000) {
                [subscriber sendNext:resultDic];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"alipay" code:-10002 userInfo:@{ @"message": NSLocalizedString(@"支付失败", nil)}]];
            }
        }];
        return nil;
    }];
}

@end
