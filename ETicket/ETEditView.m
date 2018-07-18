//
//  ETEditView.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETEditView.h"
#import "UIButton+Style.h"
#import "UIImage+Draw.h"
#import "ETCountryHelper.h"
#import "ETCountryCodeView.h"
#import "APIHosts.h"
#import <UIImageView+WebCache.h>
#import "UITextField+CLMaxLength.h"
#import "UITextField+CLValidator.h"
#import "NSString+Additions.h"


typedef NS_ENUM(NSUInteger, ETEditViewTextFieldTextType) {
    ETEditViewTextFieldTextTypeDefalut,
    ETEditViewTextFieldTextTypeAmount,
};

@interface ETEditView ()

@property (nonatomic) UIImageView *captureImageView; //图片验证码
@property (nonatomic) UIButton *eyeBtn;
@property (nonatomic) UIImageView *separateLine;
@property (nonatomic) UIView *errorMessageView;
@property (nonatomic) UILabel *errorMessageLabel;
@property (nonatomic) UILabel *inputTitleLabel;


@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) ETEditViewStyle inputViewStyle;
@property (nonatomic) UIButton *countryCodeButton;
@property (nonatomic) UIStackView *vStackView;
@property (nonatomic) UIStackView *hStackView;
@property (nonatomic) BOOL limit;


@end

@implementation ETEditView

+ (instancetype)inputViewWithStyle:(ETEditViewStyle)style title:(NSString *)title {
    return [[self class] inputViewWithStyle:style title:title limitInput:YES];
}

+ (instancetype)inputViewWithStyle:(ETEditViewStyle)style title:(NSString *)title limitInput:(BOOL)limit{
    ETEditView *inputView = [[ETEditView alloc] init];
    inputView.inputViewStyle = style;
    inputView.inputViewTitle = title;
    inputView.limit = limit;
    [inputView setupNotification];
    [inputView setupUI];
    return inputView;
}

+ (instancetype)inputViewWithStyle:(ETEditViewStyle)style placeHolder:(NSString *)placeHolder {
    ETEditView *editView = [self inputViewWithStyle:style title:nil];
    [editView setPlaceHolder:placeHolder];
    return editView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#if DEBUG
        self.count = 60;
#else
        self.count = 60;
#endif
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupUI {
    [self removeAllSubviews];
    [self addSubview:self.vStackView];
    [self.vStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (self.inputViewTitle) {
        self.inputTitleLabel.text = self.inputViewTitle;
        [self.vStackView addArrangedSubview:self.inputTitleLabel];
    }
    
    [self.vStackView addArrangedSubview:self.hStackView];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
    }];
    [self.vStackView addArrangedSubview:self.separateLine];
    
    switch (self.inputViewStyle) {
        case ETEditViewStylePhone: {
            self.textField.keyboardType = UIKeyboardTypePhonePad;
            self.textField.maxLength = 11;
            UIView *countryCode = [self countryCodeView];
            [self.hStackView insertArrangedSubview:countryCode atIndex:0];
        }
            break;
        case ETEditViewStyleEmail: {
            [self.textField addFailureMessage:NSLocalizedString(@"邮箱格式错误",nil) testBlock:^BOOL(UITextField *textField) {
                return [[textField.text trim] isEmailAddress];
            }];
            @weakify(self);
            [self.textField setValidatorFailureBlock:^(NSString *message) {
                @strongify(self);
                [self setErrorMessage:message];
            }];
        }
            break;
        case ETEditViewStyleInputMoney: {
            [self setTextFieldTextType:ETEditViewTextFieldTextTypeAmount limit:YES];
        }
            break;
        case ETEditViewStyleInputPassWord: {
            self.textField.secureTextEntry = YES;
            self.textField.maxLength = 20;
            [self.hStackView addArrangedSubview:self.eyeBtn];
        }
            break;
        case ETEditViewStyleCaptcha: {
            UIView *view = [UIView new];
            self.textField.maxLength = 8;
            view.backgroundColor = [UIColor clearColor];
            [view addSubview:self.captchaButton];
            [self.captchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                make.centerY.equalTo(view);
                make.left.right.equalTo(view);
                make.top.greaterThanOrEqualTo(view).offset(0);
                make.bottom.lessThanOrEqualTo(view).offset(0);
            }];
            [self.hStackView addArrangedSubview:view];
        }
            break;
        case ETEditViewStyleImageCaptcha: {
            [self.hStackView addArrangedSubview:self.captureImageView];
        }
            break;
            
        default:
            break;
    }
}

- (void)setupNotification {
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *_Nonnull note) {
        @strongify(self);
        if ([note.object isEqual:self.textField]) {
            self.inputViewStatus = ETEditViewStatusTyping;
            self.errorMessageLabel.text = nil;
            self.errorMessageView.hidden = YES;
            [self rightButtonDisplayControl];
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidEndEditingNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *_Nonnull note) {
        @strongify(self);
        if ([note.object isEqual:self.textField]) {
            self.inputViewStatus = ETEditViewStatusNormal;
            [self rightButtonDisplayControl];
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *_Nonnull note) {
        @strongify(self);
        if ([note.object isEqual:self.textField]) {
            if (self.textField.text.length < 1) {
                self.inputViewStatus = ETEditViewStyleNormal;
            }
            [self rightButtonDisplayControl];
        }
    }];
}

- (void)rightButtonDisplayControl {
    
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (!_titleColor) {
        return;
    }
    
    self.inputTitleLabel.textColor = titleColor;
    self.textField.textColor = titleColor;
    [self.countryCodeButton setTitleColor:titleColor forState:UIControlStateNormal];
}

#pragma mark - Event Response
- (void)onTapEye:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textField.secureTextEntry = sender.selected;
}


#pragma mark - Public Methods
- (void)setTextFieldLeftTitle:(NSString *)title {
    if ([NSString isBlankString:title]) {
        [self.hStackView removeArrangedSubview:self.textFieldLeftTitleLabel];
        return;
    }
    CGFloat width = 0;
    if (title.length > 0) {
        width = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont s03Font]}].width + 10;
    }
    self.textFieldLeftTitleLabel.text = title;
    
    [self.textFieldLeftTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
    if (!self.textFieldLeftTitleLabel.superview) {
        [self.hStackView insertArrangedSubview:self.textFieldLeftTitleLabel atIndex:0];
    }
}

- (void)setTextFieldRightTitle:(NSString *)title {
    if ([NSString isBlankString:title]) {
        [self.hStackView removeArrangedSubview:self.textFieldRightTitleLabel];
        return;
    }
    
    CGFloat width = 0;
    if (title.length > 0) {
        width = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont s03Font]}].width + 1;
    }
    self.textFieldRightTitleLabel.text = title;
    [self.textFieldRightTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
    if (!self.textFieldRightTitleLabel.superview) {
        [self.hStackView addArrangedSubview:self.textFieldRightTitleLabel];
    }
}

- (void)setCustomRightView:(UIView *)view {
    if (self.textFieldRightTitleLabel.superview) {
        [self.hStackView removeArrangedSubview:self.textFieldRightTitleLabel];
    }
    [self.hStackView addArrangedSubview:view];
}

- (void)setCustomFooterView:(UIView *)view {
    if (view) {
        [self.vStackView addArrangedSubview:view];
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    self.textField.placeholder = placeHolder;
    NSAttributedString *attrPlaceHolder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName: [UIFont s04Font], NSForegroundColorAttributeName: [UIColor drColorC19]}];
    self.textField.attributedPlaceholder = attrPlaceHolder;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    if (errorMessage && errorMessage.length > 0) {
        self.inputViewStatus = ETEditViewStatusError;
        self.errorMessageView.hidden = NO;
        self.errorMessageLabel.text = errorMessage;
        if (!self.errorMessageView.superview) {
            [self.vStackView addArrangedSubview:self.errorMessageView];
        }
    } else {
        self.inputViewStatus = ETEditViewStatusNormal;
        [self.vStackView removeArrangedSubview:self.errorMessageView];
    }
}

- (void)startCodeCountDown {
    if (self.inputViewStyle != ETEditViewStyleCaptcha) {
        return;
    }
    
    if (self.count > 0) {
        self.captchaButton.enabled = NO;
        NSString *backStr = NSLocalizedString(@"秒",nil);
        [self.captchaButton setTitle:[NSString stringWithFormat:@"%ld%@", (long)_count, backStr] forState:UIControlStateNormal];
        --self.count;
        [self performSelector:@selector(startCodeCountDown) withObject:nil afterDelay:1];
    } else {
        [self.captchaButton setTitle:NSLocalizedString(@"重新获取",nil) forState:UIControlStateNormal];
        self.captchaButton.enabled = YES;
#if DEBUG
        self.count = 60;
#else
        self.count = 60;
#endif
    }
}

- (void)setCaptureImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.inputViewStyle != ETEditViewStyleImageCaptcha)
            return;
        self.captureImageView.image = image;
    });
}

- (void)setSeperatorLineStatus:(BOOL)show {
    self.separateLine.hidden = !show;
}

/**
 *  设置textField文本类型，以达到对文本输入内容进行限制的目的
 **/
- (void)setTextFieldTextType:(ETEditViewTextFieldTextType)type limit:(BOOL)needLimit{
    switch (type) {
        case ETEditViewTextFieldTextTypeAmount: {
            if (needLimit) {
                [self.textField.rac_textSignal subscribeNext:^(NSString *x) {
                    static NSInteger const maxIntegerLength = 15; // 最大整数位
                    static NSInteger const maxFloatLength = 15; // 最大精确到小数位
                    if (x.length) {
                        // 第一个字符处理
                        // 第一个字符为0,且长度>1时
                        if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
                            if (x.length > 1) {
                                if ([[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                                    // 如果第二个字符还是0,即"00",则无效,改为"0"
                                    self.textField.text = @"0";
                                } else if (![[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {
                                    // 如果第二个字符不是".",比如"03",清除首位的"0"
                                    self.textField.text = [x substringFromIndex:1];
                                }
                            }
                        } else if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]) {
                            // 第一个字符为"."时,改为"0."
                            self.textField.text = @"0.";
                        }
                        // 2个以上字符的处理
                        NSRange pointRange = [x rangeOfString:@"."];
                        NSRange pointsRange = [x rangeOfString:@".."];
                        if (pointsRange.length > 0) {
                            // 含有2个小数点
                            self.textField.text = [x substringToIndex:x.length - 1];
                        } else if (pointRange.length > 0) {
                            // 含有1个小数点时,并且已经输入了数字,则不能再次输入小数点
                            if ((pointRange.location != x.length - 1) && ([[x substringFromIndex:x.length - 1] isEqualToString:@"."])) {
                                self.textField.text = [x substringToIndex:x.length - 1];
                            }
                            if (pointRange.location + maxFloatLength < x.length) {
                                // 输入位数超出精确度限制,进行截取
                                self.textField.text = [x substringToIndex:pointRange.location + maxFloatLength + 1];
                            }
                        } else {
                            if (x.length > maxIntegerLength) {
                                self.textField.text = [x substringToIndex:maxIntegerLength];
                            }
                        }
                    }
                }];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Setters/Getters
- (void)setInputViewTitle:(NSString *)inputViewTitle {
    _inputViewTitle = inputViewTitle;
    self.inputTitleLabel.text = inputViewTitle;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont s04Font];
        _textField.textColor = [UIColor drColorC10];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.enablesReturnKeyAutomatically = YES;
        CGSize size = [[NSString string] sizeWithAttributes:@{NSFontAttributeName: [UIFont s03Font]}];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(size.height + 30));
        }];
    }
    return _textField;
}

- (UIImageView *)captureImageView {
    if (!_captureImageView) {
        _captureImageView = [[UIImageView alloc] init];
        _captureImageView.backgroundColor = [UIColor whiteColor];
        _captureImageView.contentMode = UIViewContentModeScaleAspectFit;
        _captureImageView.userInteractionEnabled = YES;
        _captureImageView.layer.borderColor = [UIColor drColorC2].CGColor;
        [_captureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@88);
        }];
        [self refreshImageCaptcha];
        @weakify(self);
        [_captureImageView bk_whenTapped:^{
            @strongify(self);
            [self refreshImageCaptcha];
        }];
    }
    return _captureImageView;
}

- (UIImageView *)separateLine {
    if (!_separateLine) {
        _separateLine = [[UIImageView alloc] init];
        _separateLine.backgroundColor = [UIColor drColorC4];
        [_separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
        }];
    }
    return _separateLine;
}

- (UILabel *)inputTitleLabel {
    if (!_inputTitleLabel) {
        _inputTitleLabel = [[UILabel alloc] init];
        _inputTitleLabel.textColor = [UIColor drColorC10];
        _inputTitleLabel.font = [UIFont s04Font];
        
    }
    return _inputTitleLabel;
}

- (UILabel *)textFieldLeftTitleLabel {
    if (!_textFieldLeftTitleLabel) {
        _textFieldLeftTitleLabel = [[UILabel alloc] init];
        _textFieldLeftTitleLabel.textAlignment = NSTextAlignmentLeft;
        _textFieldLeftTitleLabel.textColor = [UIColor drColorC19];
        _textFieldLeftTitleLabel.font = [UIFont s03Font];
    }
    return _textFieldLeftTitleLabel;
}

- (UILabel *)textFieldRightTitleLabel {
    if (!_textFieldRightTitleLabel) {
        _textFieldRightTitleLabel = [[UILabel alloc] init];
        _textFieldRightTitleLabel.textAlignment = NSTextAlignmentRight;
        _textFieldRightTitleLabel.textColor = [UIColor drColorC19];
        _textFieldRightTitleLabel.font = [UIFont s03Font];
    }
    return _textFieldRightTitleLabel;
}

- (UIView *)errorMessageView {
    if (!_errorMessageView) {
        _errorMessageView = [[UIView alloc] init];
        _errorMessageView.backgroundColor = [UIColor clearColor];
        UIImageView *errorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InputError"]];
        [_errorMessageView addSubview:errorIcon];
        [errorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_errorMessageView).offset(0);
            make.centerY.equalTo(_errorMessageView);
        }];
        
        [_errorMessageView addSubview:self.errorMessageLabel];
        [_errorMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(errorIcon.mas_right).offset(8);
            make.centerY.equalTo(_errorMessageView);
            make.right.lessThanOrEqualTo(_errorMessageView);
        }];
    }
    return _errorMessageView;
}

- (UILabel *)errorMessageLabel {
    if (!_errorMessageLabel) {
        _errorMessageLabel = [[UILabel alloc] init];
        _errorMessageLabel.textColor = [UIColor drColorC6];
        _errorMessageLabel.font = [UIFont s02Font];
    }
    return _errorMessageLabel;
}

- (UIButton *)eyeBtn {
    if (!_eyeBtn) {
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _eyeBtn.adjustsImageWhenHighlighted = NO;
        [_eyeBtn setImage:[[UIImage imageNamed:@"SignInOpenEye"] imageByFilledWithColor:[UIColor drColorC11]] forState:UIControlStateNormal];
        [_eyeBtn setImage:[[UIImage imageNamed:@"SignInCloseEye"] imageByFilledWithColor:[UIColor drColorC11]] forState:UIControlStateSelected];
        [_eyeBtn addTarget:self action:@selector(onTapEye:) forControlEvents:UIControlEventTouchUpInside];
        _eyeBtn.selected = self.textField.secureTextEntry;
        _eyeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(30));
        }];
    }
    return _eyeBtn;
}

- (UIStackView *)vStackView {
    if (!_vStackView) {
        _vStackView = [UIStackView new];
        _vStackView.axis = UILayoutConstraintAxisVertical;
        _vStackView.alignment = UIStackViewAlignmentFill;
        _vStackView.distribution = UIStackViewDistributionFill;
        _vStackView.spacing = 0;
    }
    return _vStackView;
}

- (UIStackView *)hStackView {
    if (!_hStackView) {
        _hStackView = [UIStackView new];
        _hStackView.alignment = UIStackViewAlignmentFill;
        _hStackView.distribution = UIStackViewDistributionFill;
        _hStackView.spacing = 0;
        [_hStackView addArrangedSubview:self.textField];
    }
    return _hStackView;
}

- (UIButton *)captchaButton {
    if (!_captchaButton) {
        _captchaButton = [UIButton buttonWithStyle:ETButtonStyleRed height:30];
        _captchaButton.titleLabel.font = [UIFont s02Font];
        [_captchaButton setTitleColor:[UIColor drColorC0] forState:UIControlStateNormal];
        [_captchaButton setTitleColor:[[UIColor drColorC0] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_captchaButton setTitleColor:[UIColor drColorC0] forState:UIControlStateDisabled];
        [_captchaButton setTitle:NSLocalizedString(@"获取验证码",nil) forState:UIControlStateNormal];
        [_captchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@86);
        }];
        [_captchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
        }];
        @weakify(self);
        [[_captchaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.captchaButtonTappedActionHandler) {
                [ETPopover showLoading:YES];
                [self.captchaButtonTappedActionHandler() subscribeNext:^(id x) {
                    [ETPopover showSuccessWithContent:NSLocalizedString(@"验证码发送成功", nil)];
                    [self startCodeCountDown];
                } error:^(NSError *error) {
                    [ETPopover showFailureWithContent:error.message];
                }];
            }
        }];
    }
    return _captchaButton;
}

- (UIView *)countryCodeView {
    UIView *countryCodeView = [UIView new];
    countryCodeView.backgroundColor = [UIColor clearColor];
    self.countryCodeButton = [UIButton new];
    self.countryCodeButton.backgroundColor = [UIColor clearColor];
    [self.countryCodeButton setTitle:@"+86" forState:UIControlStateNormal];
    [self.countryCodeButton setTitleColor:[UIColor drColorC5] forState:UIControlStateNormal];
    [self.countryCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.countryCodeButton.titleLabel.font = [UIFont s04Font];
    
    [countryCodeView addSubview:self.countryCodeButton];
    [_countryCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countryCodeView).offset(0);
        make.width.equalTo(@50);
        make.height.greaterThanOrEqualTo(@34);
        make.top.bottom.equalTo(countryCodeView);
    }];
    
    UIView *cutLine = [UIView new];
    cutLine.backgroundColor = [UIColor colorWithHex:0xc4c4c4];
    [countryCodeView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@.5);
        make.top.equalTo(countryCodeView).offset(5);
        make.bottom.equalTo(countryCodeView).offset(-5);
        make.left.equalTo(_countryCodeButton.mas_right).offset(5);
        make.right.equalTo(countryCodeView).offset(-10);
    }];
    
    @weakify(self);
    [[_countryCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.superview endEditing:YES];
        [[[ETCountryHelper sharedInstance] syncIfNeeded] subscribeNext:^(id x) {
            [ETCountryCodeView showWithCode:[self attachText]
                              completeBlock:^(NSString *code) {
                                  [self.countryCodeButton setTitle:[NSString stringWithFormat:@"+%@",code] forState:UIControlStateNormal];
                              }];
        }];
    }];
    return countryCodeView;
}

- (NSString *)text {
    return [_textField.text trim];
}

- (NSString *)attachText {
    NSString *attachText = _countryCodeButton.titleLabel.text;
    return attachText.length < 2 ? @"86" : [attachText substringFromIndex:1];
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (BOOL)enabled {
    return self.textField.enabled;
}

- (void)setEnabled:(BOOL)enabled {
    self.textField.enabled = enabled;
    if (!enabled) {
        self.separateLine.backgroundColor = [UIColor drColorC4];
        self.textField.textColor = [UIColor drColorC10];
    } else {
        [self.separateLine setBackgroundColor:[UIColor drColorC4]];
        self.textField.textColor = [UIColor drColorC10];
    }
}

- (void)setInputViewStatus:(ETEditViewStatus)inputViewStatus {
    _inputViewStatus = inputViewStatus;
    switch (inputViewStatus) {
        case ETEditViewStatusTyping: {
            self.separateLine.backgroundColor = [UIColor drColorC8];
        } break;
        case ETEditViewStatusError: {
            self.separateLine.backgroundColor = [UIColor drColorC17];
        } break;
        default: {
            self.separateLine.backgroundColor = [UIColor drColorC4];
        } break;
    }
}

- (void)refreshImageCaptcha {
    [[[APICenter getCaptcha:nil] fetchImage] subscribeNext:^(RACTuple *x) {
        self.captureImageView.image = x.first;
    } error:^(NSError *error) {
        
    }];
}

@end
