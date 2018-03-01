//
//  DSEditView.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DSEditViewActionHandler)(void);

typedef NS_ENUM(NSInteger, DSEditViewStyle) {
    DSEditViewStylePhone,
    DSEditViewStyleNormal,
    DSEditViewStyleInputMoney, //金额输入
    DSEditViewStyleInputPassWord, //密码
    DSEditViewStyleCaptcha, //验证码
    DSEditViewStyleImageCaptcha //图形验证码
};

typedef NS_ENUM(NSInteger, DSEditViewStatus) {
    DSEditViewStatusNormal, //灰色
    DSEditViewStatusTyping, //输入中，绿色
    DSEditViewStatusError // 错误，橙色
};

@interface DSEditView : UIView

@property (nonatomic) BOOL enabled;
@property (nonatomic, assign, readonly) CGFloat inputViewHeight; //根据样式和title返回inputView高度，用于外部布局

@property (nonatomic) UITextField *textField;
@property (nonatomic) UIButton *captchaButton; //获取验证码按钮
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *inputViewTitle;
@property (nonatomic, strong) UIButton *countryCodeButton;

@property (nonatomic, assign) DSEditViewStatus inputViewStatus;
@property (nonatomic, copy) DSEditViewActionHandler rightButtonActionHandler;
@property (nonatomic, copy) DSEditViewActionHandler captureImageViewTappedHandler;

/**
 *  指定inputView样式和title
 *
 *  @param style inputView 样式
 *  @param title inputView 顶部title，目前仅输入金额需要，不需要title设置为nil即可
 **/
+ (instancetype)inputViewWithStyle:(DSEditViewStyle)style title:(NSString *)title;

+ (instancetype)inputViewWithStyle:(DSEditViewStyle)style title:(NSString *)title limitInput:(BOOL)limit;

+ (instancetype)inputViewWithStyle:(DSEditViewStyle)style placeHolder:(NSString *)title;

/**
 *  设置输入框右部button title。设置以后在输入框有内容时button隐藏，没有内容时button显示
 *
 *  @param title 输入框右部button title
 **/
- (void)setTextFieldRightButtonTitle:(NSString *)title;

- (void)setTextFieldRightButtonImage:(UIImage *)image;

/**
 *  设置输入框左部title目前仅输入金额有"¥"符号。
 *
 *  @param title 输入框左部title文案
 **/
- (void)setTextFieldLeftTitle:(NSString *)title;

/**
 *  设置输入框右部title
 *
 *  @param title 输入框左部title文案
 **/
- (void)setTextFieldRightTitle:(NSString *)title;

/**
 *  设置textField placeHolder，因为它的颜色值，字号和系统默认不一致，所以需要通过此方法设置
 *
 *  @param placeHolder textField placeHolder
 **/
- (void)setPlaceHolder:(NSString *)placeHolder;

/**
 *  当输入内容出错时通过此方法进行设置，目前仅金额输入会有错误显示区域
 *
 *  @param errorMessage 错误信息
 **/
- (void)setErrorMessage:(NSString *)errorMessage;

/**
 *  当inputView为DSEditViewStyleCaptcha类型时，获取验证码后需调用此方法进行倒计时
 **/
- (void)startCodeCountDown;

/**
 *  设置图片验证码
 *
 *  @param image 验证码图片
 **/
- (void)setCaptureImage:(UIImage *)image;

/**
 *  单独设置下划线为错误提示状态
 **/
- (void)setTextFieldStateError;

/**
 *  在出错的时候可以给错误view添加事件按钮
 **/
- (void)setReloadViewWhenError:(UIView *)view;

/**
 *  输入框样式为“密码”类型时，设置密码显示样式
 **/
- (void)setPasswordDisplayStatus:(BOOL)display;

@end
