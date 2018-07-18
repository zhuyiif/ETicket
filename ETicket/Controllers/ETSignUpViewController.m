//
//  ETSignUpViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETSignUpViewController.h"
#import "TTTAttributedLabel+additions.h"
#import <TTTAttributedLabel.h>
#import "ETEditView.h"
#import "ETAccountPresenter.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "ETSignupItem.h"

#define kHPadding 10

@interface ETSignUpViewController () <TTTAttributedLabelDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ETEditView *phoneEditView;
@property (nonatomic, strong) ETEditView *nickNameEditView;
@property (nonatomic, strong) ETEditView *verifyCodeEditView;
@property (nonatomic, strong) ETEditView *passwordEditView;
@property (nonatomic, strong) ETEditView *confirmPasswordEditView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic) TTTAttributedLabel *gobackLabel;
@property (nonatomic, strong) id<RACSubscriber> subscriber;
@property (nonatomic) ETAccountPresenter *presenter;
@property (nonatomic) UIButton *checkBox;

@end

@implementation ETSignUpViewController

- (instancetype)initWithSubscriber:(id<RACSubscriber>)delegate {
    if (self = [super init]) {
        _subscriber = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor drColorC0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"注册", nil);
    self.presenter = [ETAccountPresenter new];
    UIScrollView *scrollView = [self setupScrollView];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];
}

- (UIScrollView *)setupScrollView {
    UIScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    [_contentView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(25);
        make.left.equalTo(_contentView).offset(20);
        make.right.equalTo(_contentView).offset(-20);
    }];
    
    UIView *protocolView = [self protocolView];
    [_contentView addSubview:protocolView];
    [protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stackView.mas_bottom).offset(kHPadding);
        make.left.greaterThanOrEqualTo(self.stackView);
        make.right.lessThanOrEqualTo(self.stackView);
        make.centerX.equalTo(_contentView);
    }];
    
    UIButton *submitButton = [self submitButton];
    [self.contentView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(protocolView.mas_bottom).offset(kHPadding);
        make.height.equalTo(@44);
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    
    [self.contentView addSubview:self.gobackLabel];
    [self.gobackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(submitButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gobackLabel.mas_bottom).offset(kHPadding);
    }];
    return scrollView;
}

- (UIButton *)submitButton {
    UIButton *submitButton = [UIButton buttonWithStyle:ETButtonStyleRed height:44];
    [submitButton setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    RAC(submitButton, enabled) = [RACSignal combineLatest:@[_verifyCodeEditView.textField.rac_textSignal,
                                                            _passwordEditView.textField.rac_textSignal,
                                                            _nickNameEditView.textField.rac_textSignal]
                                                   reduce:^id(NSString *verifyCode, NSString *password,NSString *nickName) {
                                                       
                                                       if (![NSString isNotBlank:verifyCode] || verifyCode.length != 6) {
                                                           return @(NO);
                                                       }
                                                       
                                                       if (![NSString isNotBlank:password] || password.length < 6) {
                                                           return @(NO);
                                                       }
                                                       return @([NSString isNotBlank:nickName]);
                                                   }];
    
    @weakify(self);
    [[submitButton eventSingal] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        [self submit];
        
    }];
    return submitButton;
}

- (TTTAttributedLabel *)gobackLabel {
    if (!_gobackLabel) {
        _gobackLabel = [TTTAttributedLabel boldAttributedWithLinkColor:[UIColor drColorC4] activeLinkColor:[UIColor drColorC5]];
        _gobackLabel.textColor = [UIColor drColorC4];
        _gobackLabel.text = NSLocalizedString(@"已有账号？点击登录>>", nil);
        _gobackLabel.delegate = self;
        [_gobackLabel addLinkToTransitInformation:@{@"type": @"register"} withRange:[_gobackLabel.text rangeOfString:NSLocalizedString(@"点击登录>>", nil)]];
    }
    return _gobackLabel;
}

- (UIView *)protocolView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"protocolCheckBoxNor"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"protocolCheckBoxPress"] forState:UIControlStateSelected];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(view);
        make.bottom.lessThanOrEqualTo(view);
        make.width.height.equalTo(@35);
    }];
    [[button eventSingal] subscribeNext:^(id x) {
        button.selected = !button.selected;
    }];
    
    _checkBox = button;
    TTTAttributedLabel *protocolLabel = [TTTAttributedLabel boldAttributedWithLinkColor:[UIColor drColorC4] activeLinkColor:[UIColor drColorC5]];
    protocolLabel.textColor = [UIColor drColorC4];
    protocolLabel.text = NSLocalizedString(@"我已阅读并同意《服务条款》", nil);
    protocolLabel.delegate = self;
    [protocolLabel addLinkToTransitInformation:@{@"type": @"protocol"} withRange:[protocolLabel.text rangeOfString:NSLocalizedString(@"《服务条款》", nil)]];
    [view addSubview:protocolLabel];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(view);
        make.right.equalTo(view);
        make.bottom.lessThanOrEqualTo(view);
        make.centerY.equalTo(view);
        make.left.equalTo(button.mas_right).offset(2);
    }];
    return view;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _phoneEditView = [ETEditView inputViewWithStyle:ETEditViewStylePhone placeHolder:NSLocalizedString(@"手机号", nil)];
        
        _nickNameEditView = [ETEditView inputViewWithStyle:ETEditViewStyleNormal placeHolder:NSLocalizedString(@"昵称", nil)];
        
        _verifyCodeEditView = [ETEditView inputViewWithStyle:ETEditViewStyleCaptcha placeHolder:NSLocalizedString(@"短信验证码", nil)];
        @weakify(self);
        _verifyCodeEditView.captchaButtonTappedActionHandler = ^RACSignal *{
            @strongify(self);
            [self.view endEditing:YES];
          return [self.presenter fetchVerificationCode:[self.phoneEditView text]];
        };
        _passwordEditView = [ETEditView inputViewWithStyle:ETEditViewStyleInputPassWord placeHolder:NSLocalizedString(@"密码大于6位字符", nil)];
        _confirmPasswordEditView = [ETEditView inputViewWithStyle:ETEditViewStyleInputPassWord placeHolder:NSLocalizedString(@"密码大于6位字符", nil)];
        
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_phoneEditView,_nickNameEditView,_verifyCodeEditView,_passwordEditView,_confirmPasswordEditView]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = kHPadding;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.alignment = UIStackViewAlignmentFill;
    }
    return _stackView;
}

- (UIImageView *)starView {
    UIImageView *starView = [UIImageView new];
    starView.backgroundColor = [UIColor clearColor];
    starView.clipsToBounds = YES;
    starView.image = [UIImage imageNamed:@"mustIcon"];
    return starView;
}

#pragma mark UITextEditDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if ([components[@"type"] isEqualToString:@"protocol"]) {
        [ETPopover showLoading:YES];
        [[[APICenter getAgreementProtocol:nil] execute] subscribeNext:^(NSString *x) {
            [ETPopover showLoading:NO];
        } error:^(NSError *error) {
            [ETPopover showLoading:NO];
        }];
        
        return;
    }
    [self popController];
}

- (void)popController {
    [_subscriber sendCompleted];
    [super popController];
}

- (void)submit {
    if (!self.checkBox.selected) {
        [ETPopover showFailureWithContent:NSLocalizedString(@"请先同意服务条款", nil)];
        return;
    }
    
    if (![[self.phoneEditView text] isMobile]) {
        [ETPopover showFailureWithContent:NSLocalizedString(@"手机号错误", nil)];
        return;
    }
    
    [ETPopover showLoading:YES];
    ETSignupItem *item = [ETSignupItem new];
    item.verifyCode = [self.verifyCodeEditView text];
    item.password = [self.passwordEditView text];
    item.nickname = [self.nickNameEditView text];
    item.username = [self.phoneEditView text];
    
    @weakify(self);
    [[[[ETActor instance] signupWithItem:item] flattenMap:^RACStream *(id value) {
        @strongify(self);
        NSString *password = [self.passwordEditView text];
        NSString *userName = [self.phoneEditView text];
        return [[ETActor instance] loginWithAccount:userName password:password];
    }] subscribeNext:^(id x) {
        @strongify(self);
        [ETPopover showSuccessWithContent:NSLocalizedString(@"注册成功", nil)];
        [self.subscriber sendNext:@"success"];
        [self popController];
    } error:^(NSError *error) {
        [ETPopover showFailureWithContent:error.message];
    }];;
}

@end
