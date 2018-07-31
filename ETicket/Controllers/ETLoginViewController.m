//
//  ETLoginViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETLoginViewController.h"
#import "ETEditView.h"
#import "ETPlatformView.h"
#import <TTTAttributedLabel.h>
#import "TTTAttributedLabel+additions.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "UIButton+Style.h"
#import "NSString+Additions.h"
#import "ETAccountPresenter.h"

@interface ETLoginViewController ()<TTTAttributedLabelDelegate>

@property (nonatomic) UIView *contentView;
@property (nonatomic) ETEditView *phoneEditView;
@property (nonatomic) ETEditView *verfiyCodeEditView;
@property (nonatomic) UIButton *submitButton;
@property (nonatomic) id<RACSubscriber> subscriber;
@property (nonatomic) ETAccountPresenter *presenter;

@end

static ETLoginViewController *gInstance;

@implementation ETLoginViewController

+ (RACSignal *)showIfNeeded {
    if ([ETActor instance].isLogin) {
        return [RACSignal return:@YES];
    }
    return [self show];
}

+ (RACSignal *)show {
    return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (!gInstance) {
            gInstance = [ETLoginViewController new];
            gInstance.subscriber = subscriber;
            RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:gInstance];
            [UIApplication presentViewController:nav completion:nil];
            
        }
        return nil;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor drColorC0];
    self.presenter = [ETAccountPresenter new];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginViewBG"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *closeButton = [UIButton new];
    [closeButton setImage:[UIImage imageNamed:@"ArrowBackWhite"] forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view).offset(25);
        }
        make.left.equalTo(self.view).offset(5);
        make.width.height.equalTo(@40);
    }];
    [[closeButton eventSingal] subscribeNext:^(id x) {
        [self dismiss:NO];
    }];
    
    UIScrollView *scrollView = [TPKeyboardAvoidingScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(closeButton.mas_bottom).offset(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view).offset(25);
        }
    }];
    
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    [self bindActions];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *iconView  = [UIImageView new];
        iconView.image = [UIImage imageNamed:@"xianIcon"];
        [_contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(35);
            make.left.equalTo(_contentView).offset(25);
        }];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont fontWithSize:22];
        tipLabel.textColor = [UIColor drColorC0];
        tipLabel.text = @"欢迎回家 ^_^";
        [_contentView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom).offset(10);
            make.left.equalTo(iconView);
            make.right.equalTo(_contentView).offset(-25);
        }];
        
        self.phoneEditView = [ETEditView inputViewWithStyle:ETEditViewStylePhone title:@"手机号码"];
        self.phoneEditView.titleColor = [UIColor drColorC0];
        [self.phoneEditView setPlaceHolder:@"请输入手机号"];
        [_contentView addSubview:self.phoneEditView];
        [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(tipLabel);
            make.top.equalTo(tipLabel.mas_bottom).offset(25);
        }];
        
        self.verfiyCodeEditView = [ETEditView inputViewWithStyle:ETEditViewStyleCaptcha title:@"验证码"];
        [self.verfiyCodeEditView setTitleColor:[UIColor drColorC0]];
        [self.verfiyCodeEditView setPlaceHolder:@"请输入验证码"];
        @weakify(self);
        self.verfiyCodeEditView.captchaButtonTappedActionHandler = ^RACSignal * {
            @strongify(self);
            [self.view endEditing:YES];
            return [self.presenter fetchVerificationCode:[self.phoneEditView text]];
        };
        [_contentView addSubview:self.verfiyCodeEditView];
        [self.verfiyCodeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneEditView.mas_bottom).offset(15);
            make.left.right.equalTo(self.phoneEditView);
        }];
        
        
        self.submitButton = [UIButton buttonWithStyle:ETButtonStyleRed height:44];
        [self.submitButton setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        [_contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.verfiyCodeEditView.mas_bottom).offset(45);
            make.height.equalTo(@44);
            make.left.right.equalTo(self.verfiyCodeEditView);
            make.bottom.equalTo(_contentView).offset(-15);
        }];
        
    }
    return _contentView;
}

- (void)dismiss:(BOOL)value {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            gInstance = nil;
            if (_subscriber) {
                [_subscriber sendNext:@(value)];
                [_subscriber sendCompleted];
            }
        }];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    gInstance = nil;
    if (_subscriber) {
        [_subscriber sendNext:@(value)];
        [_subscriber sendCompleted];
    }
}

- (void)bindActions {
    RAC(self.submitButton,hidden) =  [self.phoneEditView.textField.rac_textSignal map:^id(NSString *value) {
        return @(![value isMobile]);
    }];
    
    RAC(self.submitButton, enabled)  = [self.verfiyCodeEditView.textField.rac_textSignal map:^id(id value) {
        return @([NSString isNotBlank:value]);
    }];
    
    RAC(self.verfiyCodeEditView.captchaButton,enabled) = [self.phoneEditView.textField.rac_textSignal map:^id(NSString *value) {
        return @([value isMobile]);
    }];
    @weakify(self);
    [[self.submitButton eventSingal] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        [self requestLogin];
    }];
}

#pragma mark http functions
- (void)requestLogin {
    NSString *account = [self.phoneEditView text];
    if (![account isMobile]) {
        [ETPopover showFailureWithContent:NSLocalizedString(@"手机号错误", nil)];
        return ;
    }
    [ETPopover showLoading:YES];
    [[[ETActor instance] loginWithAccount:account password:self.verfiyCodeEditView.textField.text] subscribeNext:^(id x) {
        [ETPopover showLoading:NO];
        [self dismiss:YES];
    } error:^(NSError *error) {
        [ETPopover showFailureWithContent:[error message]];
    }];
}

@end
