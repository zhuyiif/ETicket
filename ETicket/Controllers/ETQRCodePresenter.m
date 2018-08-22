//
//  ETQRCodePresenter.m
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETQRCodePresenter.h"
#import "MF_Base64Additions.h"
#import "sm2oc.h"

@implementation ETQRCodePresenter

- (RACSignal *)refresh {
    @weakify(self);
    return [[[[ETActor instance] refreshSeedIfNeeded] doNext:^(NSDictionary *x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self generateSourceCode:x];
        });
    }] doError:^(NSError *error) {
        
    }] ;
}

- (void)generateSourceCode:(NSDictionary *)x {
    NSData *privateKeyData = x[@"key"];
    NSMutableData *signSource = [x[@"seed"] mutableCopy];
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    //int to data 大端,并不上固定字节0x15
    uint8_t buffer[4] = {(time >> 24) & 0xFF,(time >> 16) & 0xFF,(time >> 8) & 0xFF,time & 0xFF};
    [signSource appendBytes:buffer length:4];
    
    unsigned char privateKeys[32] = {0x0};
    sm4dec((unsigned char *)[privateKeyData bytes],(int)privateKeyData.length, privateKeys);
    
    unsigned char sign[64] = {0x0};
    int signedlen = 0;
    sm2Sign(privateKeys, sizeof(privateKeys), signSource.bytes,(int)signSource.length, sign, &signedlen);
    uint8_t space[1] = {0x15};//分隔符
    [signSource appendBytes:space length:1];
    [signSource appendBytes:sign length:signedlen];
    self.sourceCode = [signSource base64String];
    NSLog(@"%@",self.sourceCode);
}

@end
