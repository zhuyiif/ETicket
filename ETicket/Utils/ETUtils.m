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
    
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"]; //设置纠错等级越高；即识别越容易，值可设置为L(Low) |  M(Medium) | Q | H(High)
    CIImage *outputImage = [filter outputImage];
    UIImage *image =  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    return image;
}

//Only used in test, real tradeNO come from server
+ (NSString *)generateAlipayTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

+ (BOOL)isNetworkError:(NSInteger)errorCode {
    if (errorCode == -1009 || errorCode == -1005 || errorCode == -1003 || errorCode == -1004 ) {
        return YES;
    }
    return NO;
}

+ (BOOL)isServiceError:(NSInteger)errorCode {
    return errorCode == 404 || errorCode == 5000000 || errorCode == -1011;
}

+ (UIImage *)generateQRCodeWithContent:(NSString *)content qrcodeImageSize:(CGFloat)qrcodeImageSize centerSmallImage:(UIImage *)smallImage centerSmallImageSize:(CGFloat)smallImageSize {
    if (content == nil) {
        return nil;
    }
    // 验证二维码尺寸合法性
    qrcodeImageSize = MAX(160, qrcodeImageSize);
    qrcodeImageSize = MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - 80, qrcodeImageSize);
    
    // 为了二维码图片的完整性,限定小图片二维码的尺寸为整个二维码图片的0.3
    if (smallImageSize/qrcodeImageSize > 0.3) {
        smallImageSize = qrcodeImageSize * 0.3;
    }
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    // 设置纠错等级越高；即识别越容易，值可设置为L(Low) |  M(Medium) | Q | H(High)
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outputImage = [filter outputImage];
    UIImage *resizedImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:qrcodeImageSize];
    // 判断是否传入小图片, 如果有, 生成带小图片的二维码图片
    if (smallImage != nil) {
        resizedImage = [self createImageWithQRCodeImage:resizedImage smallImage:smallImage smallImagesize:smallImageSize];
    }
    return resizedImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)createImageWithQRCodeImage:(UIImage *)bigImage smallImage:(UIImage *)smallImage smallImagesize:(CGFloat)sizeWH {
    CGSize size = bigImage.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    // 绘制大图片
    [bigImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 绘制小图片
    CGFloat x = (size.width - sizeWH) * 0.5;
    CGFloat y = (size.height - sizeWH) * 0.5;
    [smallImage drawInRect:CGRectMake(x, y, sizeWH, sizeWH)];
    // 取出合成图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
