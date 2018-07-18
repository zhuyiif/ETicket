//
//  ETEditView.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef RACSignal* (^ETEditViewActionHandler)(void);

typedef NS_ENUM(NSInteger, ETEditViewStyle) {
    ETEditViewStylePhone,
    ETEditViewStyleNormal,
    ETEditViewStyleInputMoney, //金额输入
    ETEditViewStyleEmail,
    ETEditViewStyleInputPassWord, //密码
    ETEditViewStyleCaptcha, //验证码
    ETEditViewStyleImageCaptcha //图形验证码
};

typedef NS_ENUM(NSInteger, ETEditViewStatus) {
    ETEditViewStatusNormal, //灰色
    ETEditViewStatusTyping, //输入中，绿色
    ETEditViewStatusError // 错误，橙色
};

@interface ETEditView : UIView

@property (nonatomic) UIButton *captchaButton; //获取验证码按钮
@property (nonatomic) BOOL enabled;
@property (nonatomic) UITextField *textField;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *attachText;
@property (nonatomic) NSString *inputViewTitle;
@property (nonatomic) UILabel *textFieldLeftTitleLabel;
@property (nonatomic) UILabel *textFieldRightTitleLabel;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic, assign) ETEditViewStatus inputViewStatus;
@property (nonatomic, copy) ETEditViewActionHandler captchaButtonTappedActionHandler;

/**
 *  指定inputView样式和title
 *
 *  @param style inputView 样式
 *  @param title inputView 顶部title
 **/
+ (instancetype)inputViewWithStyle:(ETEditViewStyle)style title:(NSString *)title;

+ (instancetype)inputViewWithStyle:(ETEditViewStyle)style title:(NSString *)title limitInput:(BOOL)limit;

+ (instancetype)inputViewWithStyle:(ETEditViewStyle)style placeHolder:(NSString *)placeHolder;


/**
 *  设置输入框左部title
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

- (void)setCustomRightView:(UIView *)view;

- (void)setCustomFooterView:(UIView *)view;

/**
 *  设置textField placeHolder，因为它的颜色值，字号和系统默认不一致，所以需要通过此方法设置
 *
 *  @param placeHolder textField placeHolder
 **/
- (void)setPlaceHolder:(NSString *)placeHolder;

/**
 *  当输入内容出错时通过此方法进行设置
 *
 *  @param errorMessage 错误信息
 **/
- (void)setErrorMessage:(NSString *)errorMessage;

/**
 *  当inputView为ETEditViewStyleCaptcha类型时，获取验证码后需调用此方法进行倒计时
 **/
- (void)startCodeCountDown;

/**
 *  设置图片验证码 style = ETEditViewStyleImageCaptcha 有效
 *
 *  @param image 验证码图片
 **/
- (void)setCaptureImage:(UIImage *)image;

- (void)setSeperatorLineStatus:(BOOL)show;

@end
