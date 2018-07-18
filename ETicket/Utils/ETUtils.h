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
+ (NSString *)generateAlipayTradeNO;
+ (BOOL)isNetworkError:(NSInteger)errorCode;
+ (BOOL)isServiceError:(NSInteger)errorCode;
/**
 *  生成二维码图片 根据外界传递过来的内容, 生成一个二维码图片, 并且可以根据参数, 在生成后的二维码中间添加小图片
 *
 *  @param content         二维码内容
 *  @param qrcodeImageSize 二维码图片尺寸
 *  @param smallImage      小图片
 *  @param smallImageSize  小图片尺寸
 *
 *  @return 二维码图片
 */
+ (UIImage *)generateQRCodeWithContent:(NSString *)content qrcodeImageSize:(CGFloat)qrcodeImageSize centerSmallImage:(UIImage *)smallImage centerSmallImageSize:(CGFloat)smallImageSize;

@end
