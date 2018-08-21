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

- (RACSignal *)refreshIfNeeded {
    @weakify(self);
    return [[[ETActor instance] refreshSeedIfNeeded] doNext:^(NSDictionary *x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self generateSourceCode:x];
        });
    }];
}

- (void)generateSourceCode:(NSDictionary *)x {
    NSString *key = x[@"key"];
    NSString *seed = x[@"seed"];
    NSData *privateKeyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSMutableData *signSource = [[[NSData alloc] initWithBase64EncodedString:seed options:NSDataBase64DecodingIgnoreUnknownCharacters] mutableCopy];
    NSInteger timeValue = [[NSDate date] timeIntervalSince1970];
    uint8_t buffer[5];
    buffer[0] = (timeValue & 0xFF);
    buffer[1] = (timeValue >> 8) & 0xFF;
    buffer[2] = (timeValue >> 16) & 0xFF;
    buffer[3] = (timeValue >> 24) & 0xFF;
    buffer[4] = 0x15;
    int length = sizeof(buffer);
    [signSource appendBytes:buffer length:length];
    
    unsigned char privateKeys[32] = {0x0};
    sm4dec((unsigned char *)[privateKeyData bytes],(int)privateKeyData.length, privateKeys);
    
    unsigned char sign[64] = {0x0};
    int signedlen = 0;
    sm2Sign(privateKeys, sizeof(privateKeys), signSource.bytes,(int)signSource.length, sign, &signedlen);
    [signSource appendBytes:sign length:signedlen];
    self.sourceCode = [self convertDataToHexStr:signSource];
    NSLog(@"%@",self.sourceCode);
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end
