//
//  ETUtils.m
//  ETicket
//
//  Created by chunjian wang on 2018/3/1.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETUtils.h"

@implementation ETUtils

+ (void)makeCallWithPhone:(NSString *)phone view:(UIView *)superView {
    if ([NSString isNotBlank:phone]) {
        NSString *str = [NSString stringWithFormat:@"tel://%@", phone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        NSURL *telURL = [NSURL URLWithString:str];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [superView addSubview:callWebview];
    }
}

+ (UIImage *)generateQRCodeImage:(NSString *)source {
    if (source == nil) {
        return nil;
    }
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"]; //设置纠错等级越高；即识别越容易，值可设置为L(Low) |  M(Medium) | Q | H(High)
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1. orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    
    return image;
}

//Only used in test, real tradeNO come from server
+ (NSString *)generateAlipayTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

@end
