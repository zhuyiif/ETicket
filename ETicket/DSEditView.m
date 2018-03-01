//
//  DSEditView.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSEditView.h"
#import "UIButton+Style.h"
#import "UIImage+Draw.h"
#import "DSCountryCodeView.h"


typedef NS_ENUM(NSUInteger, DSEditViewTextFieldTextType) {
    DSEditViewTextFieldTextTypeDefalut,
    DSEditViewTextFieldTextTypeAmount,
};

@interface DSEditView ()

@property (nonatomic) UIImageView *captureImageView; //图片验证码
@property (nonatomic) UIButton *eyeBtn;
@property (nonatomic) UIButton *rightBtn;
@property (nonatomic) UIImageView *separateLine;
@property (nonatomic) UIView *errorMessageView;
@property (nonatomic) UILabel *errorMessageLabel;
@property (nonatomic) UILabel *inputTitleLabel;
@property (nonatomic) UILabel *textFieldLeftTitleLabel;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) DSEditViewStyle inputViewStyle;

@property (nonatomic) NSString *textFieldRightText;
@property (nonatomic) UIImage *textFieldRightImage;



@end

@implementation DSEditView

+ (instancetype)inputViewWithStyle:(DSEditViewStyle)style title:(NSString *)title {
    return [[self class] inputViewWithStyle:style title:title limitInput:YES];
}

+ (instancetype)inputViewWithStyle:(DSEditViewStyle)style title:(NSString *)title limitInput:(BOOL)limit{
    DSEditView *inputView = [[DSEditView alloc] init];
    inputView.inputViewStyle = style;
    inputView.inputViewTitle = title;
    if(style == DSEditViewStyleInputMoney) {
        [inputView setTextFieldTextType:DSEditViewTextFieldTextTypeAmount limit:limit];
    }
    [inputView setupNotification];
    [inputView setupUI];
    return inputView;
}

+ (instancetype)inputViewWithStyle:(DSEditViewStyle)style placeHolder:(NSString *)title {
    DSEditView *editView = [self inputViewWithStyle:style title:nil];
    [editView setPlaceHolder:title];
    return editView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#if DEBUG
        self.count = 6;
#else
        self.count = 60;
#endif
        self.backgroundColor = [UIColor drColorC0];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupUI {
    [self addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
    
    [self addSubview:self.textField];
    CGSize size = [[NSString string] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithSize:20]}];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(@(size.height + 30));
        make.bottom.equalTo(self.separateLine.mas_top).offset(0);
    }];
    
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.height.equalTo(@33);
        make.centerY.equalTo(self.textField);
        make.width.equalTo(@0);
    }];
    
    [self addSubview:self.textFieldLeftTitleLabel];
    [self.textFieldLeftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textField);
        make.left.equalTo(self);
        make.centerY.equalTo(self.textField);
        make.width.equalTo(@0);
    }];
    
    if (self.inputViewStyle == DSEditViewStyleInputMoney) {
        self.textField.font = [UIFont fontWithSize:20];
        if (self.inputViewTitle.length > 0) {
            self.inputTitleLabel.text = self.inputViewTitle;
            [self addSubview:self.inputTitleLabel];
            [self.inputTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(0);
                make.top.equalTo(self).offset(15);
            }];
        }
        
        [self.separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-35);
        }];
        
        [self addSubview:self.errorMessageView];
        [self.errorMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.separateLine.mas_bottom);
        }];
        
        UIImageView *errorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InputError"]];
        [self.errorMessageView addSubview:errorIcon];
        [errorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.errorMessageView).offset(0);
            make.centerY.equalTo(self.errorMessageView);
        }];
        
        [self.errorMessageView addSubview:self.errorMessageLabel];
        [self.errorMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(errorIcon.mas_right).offset(8);
            make.centerY.equalTo(self.errorMessageView);
            make.right.lessThanOrEqualTo(self.errorMessageView);
        }];
    }
    
    if (self.inputViewStyle == DSEditViewStyleInputPassWord) {
        self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.textField.secureTextEntry = YES;
        self.eyeBtn.adjustsImageWhenHighlighted = NO;
        [self.eyeBtn setImage:[[UIImage imageNamed:@"SignInOpenEye"] imageByFilledWithColor:[UIColor drColorC8]] forState:UIControlStateNormal];
        [self.eyeBtn setImage:[[UIImage imageNamed:@"SignInCloseEye"] imageByFilledWithColor:[UIColor drColorC8]] forState:UIControlStateSelected];
        [self.eyeBtn addTarget:self action:@selector(onTapEye:) forControlEvents:UIControlEventTouchUpInside];
        self.eyeBtn.selected = self.textField.secureTextEntry;
        self.eyeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:self.eyeBtn];
        [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.textField);
            make.width.equalTo(@(30));
            make.right.equalTo(self).offset(0);
        }];
        
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-30);
        }];
    }
    
    if (self.inputViewStyle == DSEditViewStylePhone) {
        UIView *countryCode = [self countryCodeView];
        [self addSubview:countryCode];
        [countryCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.centerY.equalTo(self.textField);
        }];
        self.textField.keyboardType = UIKeyboardTypePhonePad;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(55);
        }];
    }
    
    if (self.inputViewStyle == DSEditViewStyleImageCaptcha) {
        [self addSubview:self.captureImageView];
        [self.captureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(0);
            make.height.equalTo(@33);
            make.width.equalTo(@88);
            make.centerY.equalTo(self.textField);
        }];
        
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-98);
        }];
    }
    
    if (self.inputViewStyle == DSEditViewStyleCaptcha) {
        [self addSubview:self.captchaButton];
        [self.captchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(0);
            make.height.equalTo(@30);
            make.width.equalTo(@76);
            make.centerY.equalTo(self.textField);
        }];
        
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-78);
        }];
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.inputViewHeight));
    }];
}

- (void)setupNotification {
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *_Nonnull note) {
        @strongify(self);
        if ([note.object isEqual:self.textField]) {
            self.inputViewStatus = DSEditViewStatusTyping;
            self.errorMessageLabel.text = nil;
            self.errorMessageView.hidden = YES;
            [self rightButtonDisplayControl];
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidEndEditingNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *_Nonnull note) {
        @strongify(self);
        if ([note.object isEqual:self.textField]) {
            self.inputViewStatus = DSEditViewStatusNormal;
            [self rightButtonDisplayControl];
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *_Nonnull note) {
        @strongify(self);
        if ([note.object isEqual:self.textField]) {
            if (self.textField.text.length < 1) {
                self.inputViewStatus = DSEditViewStyleNormal;
            }
            [self rightButtonDisplayControl];
        }
    }];
}

- (void)rightButtonDisplayControl {
    if (self.inputViewStyle == DSEditViewStyleInputMoney) {
        if (self.textField.text.length > 0) {
            self.rightBtn.hidden = YES;
        } else {
            self.rightBtn.hidden = NO;
        }
    } else if (self.textFieldRightImage) {
        self.rightBtn.hidden = NO;
    }
}

#pragma mark - Event Response

- (void)onTapEye:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textField.secureTextEntry = sender.selected;
}

- (void)onRightButtonTapped:(UIButton *)sender {
    if (self.rightButtonActionHandler) {
        NSInteger curLen = self.textField.text.length;
        self.rightButtonActionHandler();
        if(curLen != self.textField.text.length) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textField];
        }
    }
}

#pragma mark - Public Methods

- (void)setTextFieldRightButtonTitle:(NSString *)title {
    if (self.inputViewStyle != DSEditViewStyleInputMoney)
        return;
    CGFloat width = 0;
    if (title.length > 0) {
        width = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithSize:14]}].width + 10;
    }
    self.textFieldRightText = title;
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    [self.rightBtn setTitle:title forState:UIControlStateHighlighted];
    
    [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
}

- (void)setTextFieldRightButtonImage:(UIImage *)image {
    self.textFieldRightImage = image;
    [self.rightBtn setImage:image forState:UIControlStateNormal];
    if (image) {
        self.rightBtn.hidden = NO;
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@33);
        }];
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    } else {
        self.rightBtn.hidden = YES;
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
}

- (void)setTextFieldLeftTitle:(NSString *)title {
    if (self.inputViewStyle != DSEditViewStyleInputMoney)
        return;
    CGFloat width = 0;
    if (title.length > 0) {
        width = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithSize:28]}].width + 10;
    }
    self.textFieldLeftTitleLabel.text = title;
    
    [self.textFieldLeftTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(width);
    }];
}

- (void)setTextFieldRightTitle:(NSString *)title {
    CGFloat width = 0;
    if (title.length > 0) {
        width = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithSize:16]}].width + 10;
    }
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor drColorC4];
    rightLabel.font = [UIFont fontWithSize:16];
    [self addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.textField);
        make.width.equalTo(@(width));
    }];
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-width);
    }];
    rightLabel.text = title;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    self.textField.placeholder = placeHolder;
    NSAttributedString *attrPlaceHolder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName: [UIFont fontWithSize:20], NSForegroundColorAttributeName: [UIColor drColorC3]}];
    self.textField.attributedPlaceholder = attrPlaceHolder;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    if (self.inputViewStyle != DSEditViewStyleInputMoney)
        return;
    if (errorMessage && errorMessage.length > 0) {
        self.inputViewStatus = DSEditViewStatusError;
        self.errorMessageView.hidden = NO;
        self.errorMessageLabel.text = errorMessage;
    } else {
        self.inputViewStatus = DSEditViewStatusNormal;
        self.errorMessageLabel.text = nil;
        self.errorMessageView.hidden = YES;
    }
}

- (void)startCodeCountDown {
    if (self.inputViewStyle != DSEditViewStyleCaptcha)
        return;
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
        self.count = 6;
#else
        self.count = 60;
#endif
    }
}

- (void)setCaptureImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.inputViewStyle != DSEditViewStyleImageCaptcha)
            return;
        self.captureImageView.image = image;
    });
}

- (void)setTextFieldStateError {
    self.inputViewStatus = DSEditViewStatusError;
}

/**
 *  设置textField文本类型，以达到对文本输入内容进行限制的目的
 **/
- (void)setTextFieldTextType:(DSEditViewTextFieldTextType)type limit:(BOOL)needLimit{
    switch (type) {
        case DSEditViewTextFieldTextTypeAmount: {
            if (needLimit) {
                [self.textField.rac_textSignal subscribeNext:^(NSString *x) {
                    static NSInteger const maxIntegerLength = 10; // 最大整数位
                    static NSInteger const maxFloatLength = 2; // 最大精确到小数位
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

- (void)setReloadViewWhenError:(UIView *)view {
    [self.errorMessageView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.errorMessageLabel.mas_right).offset(10);
        make.centerY.equalTo(self.errorMessageLabel);
    }];
}

- (void)setPasswordDisplayStatus:(BOOL)display {
    if(self.inputViewStyle == DSEditViewStyleInputPassWord) {
        self.eyeBtn.selected = !display;
        self.textField.secureTextEntry = self.eyeBtn.selected;
    }
}

#pragma mark - Setters/Getters
- (void)setInputViewTitle:(NSString *)inputViewTitle {
    _inputViewTitle = inputViewTitle;
    self.inputTitleLabel.text = inputViewTitle;
}

- (CGFloat)inputViewHeight {
    CGFloat height = 60;
    if (self.inputViewStyle == DSEditViewStyleInputMoney) {
        height = 95;
        if (self.inputViewTitle && self.inputViewTitle.length > 0) {
            height = 130;
        }
    }
    return height;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont fontWithSize:16];
        _textField.textColor = [UIColor drColorC5];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.enablesReturnKeyAutomatically = YES;
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
        @weakify(self);
        [_captureImageView bk_whenTapped:^{
            @strongify(self);
            if (self.captureImageViewTappedHandler) {
                self.captureImageViewTappedHandler();
            }
        }];
    }
    return _captureImageView;
}

- (UIImageView *)separateLine {
    if (!_separateLine) {
        _separateLine = [[UIImageView alloc] init];
        _separateLine.backgroundColor = [UIColor drColorC3];
    }
    return _separateLine;
}

- (UILabel *)inputTitleLabel {
    if (!_inputTitleLabel) {
        _inputTitleLabel = [[UILabel alloc] init];
        _inputTitleLabel.textColor = [UIColor drColorC4];
        _inputTitleLabel.font = [UIFont fontWithSize:14];
    }
    return _inputTitleLabel;
}

- (UILabel *)textFieldLeftTitleLabel {
    if (!_textFieldLeftTitleLabel) {
        _textFieldLeftTitleLabel = [[UILabel alloc] init];
        _textFieldLeftTitleLabel.textAlignment = NSTextAlignmentLeft;
        _textFieldLeftTitleLabel.textColor = [UIColor drColorC5];
        _textFieldLeftTitleLabel.font = [UIFont fontWithSize:28];
    }
    return _textFieldLeftTitleLabel;
}

- (UIView *)errorMessageView {
    if (!_errorMessageView) {
        _errorMessageView = [[UIView alloc] init];
        _errorMessageView.backgroundColor = [UIColor clearColor];
        _errorMessageView.hidden = YES;
    }
    return _errorMessageView;
}

- (UILabel *)errorMessageLabel {
    if (!_errorMessageLabel) {
        _errorMessageLabel = [[UILabel alloc] init];
        _errorMessageLabel.textColor = [UIColor drColorC6];
        _errorMessageLabel.font = [UIFont fontWithSize:12];
    }
    return _errorMessageLabel;
}

- (UIButton *)captchaButton {
    if (!_captchaButton) {
        _captchaButton = [UIButton buttonWithStyle:DSButtonStyleBorderOrange height:30];
        _captchaButton.titleLabel.font = [UIFont fontWithSize:10];
        [_captchaButton setTitleColor:[UIColor drColorC7] forState:UIControlStateNormal];
        [_captchaButton setTitleColor:[[UIColor drColorC7] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_captchaButton setTitleColor:[UIColor drColorC2] forState:UIControlStateDisabled];
        [_captchaButton setTitle:NSLocalizedString(@"获取验证码",nil) forState:UIControlStateNormal];
        [_captchaButton addTarget:self action:@selector(onRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captchaButton;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(onRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[UIColor drColorC8] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor drColorC8] forState:UIControlStateHighlighted];
        _rightBtn.titleLabel.font = [UIFont fontWithSize:14];
    }
    return _rightBtn;
}

- (UIView *)countryCodeView {
    UIView *countryCodeView = [UIView new];
    countryCodeView.backgroundColor = [UIColor clearColor];

    
    self.countryCodeButton = [UIButton new];
    self.countryCodeButton.backgroundColor = [UIColor clearColor];
    [self.countryCodeButton setTitle:@"+86" forState:UIControlStateNormal];
    [self.countryCodeButton setTitleColor:[UIColor drColorC5] forState:UIControlStateNormal];
    [self.countryCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.countryCodeButton.titleLabel.font = [UIFont fontWithSize:16];
    
    [countryCodeView addSubview:self.countryCodeButton];
    [_countryCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countryCodeView).offset(0);
        make.width.equalTo(@40);
        make.height.equalTo(@34);
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
        make.right.equalTo(countryCodeView);
    }];
    
    @weakify(self);
    [[_countryCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.superview endEditing:YES];
        [DSCountryCodeView showWithCode:_countryCodeButton.titleLabel.text
                          completeBlock:^(NSString *countryCode) {
                              [self.countryCodeButton setTitle:countryCode forState:UIControlStateNormal];
                          }];
    }];
    return countryCodeView;
}

- (NSString *)text {
    if (!_countryCodeButton) {
        return [_textField.text trim];
    }
    
    NSString *tel = _textField.text;
    if (![NSString isNotBlank:tel]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@-%@",_countryCodeButton.titleLabel.text, [tel trim]];
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
        [self.separateLine setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashedLine"]]];
        self.textField.textColor = [UIColor drColorC2];
    } else {
        [self.separateLine setBackgroundColor:[UIColor drColorC3]];
        self.textField.textColor = [UIColor drColorC5];
    }
}

- (void)setInputViewStatus:(DSEditViewStatus)inputViewStatus {
    _inputViewStatus = inputViewStatus;
    switch (inputViewStatus) {
        case DSEditViewStatusTyping: {
            self.separateLine.backgroundColor = [UIColor drColorC8];
        } break;
        case DSEditViewStatusError: {
            self.separateLine.backgroundColor = [UIColor drColorC6];
        } break;
        default: {
            self.separateLine.backgroundColor = [UIColor drColorC3];
        } break;
    }
}

@end
