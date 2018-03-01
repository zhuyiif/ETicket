//
//  DSForgetPsdViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSForgetPsdViewController.h"
#import "DSAccountPresenter.h"
#import "DSEditView.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface DSForgetPsdViewController ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) DSEditView *phoneEditView;
@property (nonatomic, strong) DSEditView *verifyCodeEditView;
@property (nonatomic, strong) DSEditView *passwordEditView;
@property (nonatomic, strong) DSEditView *verifyPsdEditView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) DSAccountPresenter *presenter;

@end

@implementation DSForgetPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor drColorC0];
    self.title = NSLocalizedString(@"重置密码", nil);
    self.presenter = [DSAccountPresenter new];
    
    UIScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [scrollView addSubview:self.contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(35);
            make.left.equalTo(_contentView).offset(30);
            make.right.equalTo(_contentView).offset(-30);
        }];
        
        [_contentView addSubview:self.errorLabel];
        [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stackView.mas_bottom).offset(5);
            make.centerX.equalTo(_contentView);
        }];
        
        self.submitButton = [UIButton buttonWithStyle:DSButtonStyleOrange height:44];
        [self.submitButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stackView.mas_bottom).offset(45);
            make.height.equalTo(@44);
            make.left.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.contentView).offset(-30);
        }];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_submitButton.mas_bottom).offset(60);
        }];
        [self bindActions];
    }
    return _contentView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [UILabel new];
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.text = NSLocalizedString(@"两次密码不一致", nil);
        _errorLabel.font = [UIFont s03Font];
        _errorLabel.textColor = [UIColor redColor];
        _errorLabel.hidden = YES;
    }
    return _errorLabel;
}

- (UIStackView *)stackView {
    
    if (!_stackView) {
        _phoneEditView = [DSEditView inputViewWithStyle:DSEditViewStylePhone placeHolder:NSLocalizedString(@"手机号", nil)];
        _verifyCodeEditView = [DSEditView inputViewWithStyle:DSEditViewStyleCaptcha placeHolder:NSLocalizedString(@"验证码", nil)];
        @weakify(self);
        _verifyCodeEditView.rightButtonActionHandler = ^(){
            @strongify(self);
            [self.view endEditing:YES];
            [self.presenter fetchVerificationCode:[self.phoneEditView text]];
        };
        _passwordEditView = [DSEditView inputViewWithStyle:DSEditViewStyleInputPassWord placeHolder:NSLocalizedString(@"输入新密码", nil)];
        _verifyPsdEditView = [DSEditView inputViewWithStyle:DSEditViewStyleInputPassWord placeHolder:NSLocalizedString(@"确认新密码", nil)];
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_phoneEditView,_verifyCodeEditView,_passwordEditView,_verifyPsdEditView]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 5;
        stackView.distribution = UIStackViewDistributionFill;
        stackView.alignment = UIStackViewAlignmentFill;
        _stackView = stackView;
        
    }
    return _stackView;
}

- (void)bindActions {
    RAC(self.errorLabel, hidden) = [RACSignal combineLatest:@[_passwordEditView.textField.rac_textSignal,_verifyPsdEditView.textField.rac_textSignal] reduce:^id(NSString *password, NSString *confirmPassword) {
        BOOL invalidate = (password.length >= 6 && confirmPassword.length >= 6 && ![password isEqualToString:confirmPassword]);
        return @(!invalidate);
    }];
    
    NSArray *signals = @[_verifyCodeEditView.textField.rac_textSignal,_passwordEditView.textField.rac_textSignal,_verifyPsdEditView.textField.rac_textSignal];
    RAC(self.submitButton, enabled) = [RACSignal combineLatest:signals
                                                        reduce:^id(NSString *verifyCode, NSString *password,NSString *confirmPassword) {
                                                            BOOL invalidate = (verifyCode.length != 6 ||
                                                                               ![NSString isNotBlank:password] ||
                                                                               password.length < 6 ||
                                                                               ![confirmPassword isEqualToString:password]);
                                                            return @(!invalidate);
                                                        }];
    
    // Do any additional setup after loading the view.
    @weakify(self);
    [[self.submitButton eventSingal] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        [self requestResetPassword];
    }];
}

- (void)requestResetPassword {
    if (![[self.phoneEditView text] isMobile]) {
        [DSPopover showFailureWithContent:NSLocalizedString(@"手机号错误", nil)];
        return;
    }
    [DSPopover showLoading:YES];
    NSDictionary *params = @{@"mobile": [self.phoneEditView text],
                             @"verifyCode": [self.verifyCodeEditView text],
                             @"newPwd": [self.passwordEditView text]};
    [[[APICenter postForgetPassword:params] execute] subscribeNext:^(id x) {
        [DSPopover showLoading:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self popController];
                       });
    } error:^(NSError *error) {
        [DSPopover showFailureWithContent:error.message];
    }];
}

@end
