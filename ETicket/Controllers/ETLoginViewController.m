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
#import "ETSignUpViewController.h"
#import "ETForgetPsdViewController.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "UIButton+Style.h"

@interface ETLoginViewController ()<TTTAttributedLabelDelegate>

@property (nonatomic) UIView *contentView;
@property (nonatomic) ETEditView *phoneEditView;
@property (nonatomic) ETEditView *passwordEditView;
@property (nonatomic) ETPlatformView *platformView;
@property (nonatomic) TTTAttributedLabel *forgetPassordLabel;
@property (nonatomic) TTTAttributedLabel *registerLabel;
@property (nonatomic) UIButton *submitButton;
@property (nonatomic) id<RACSubscriber> subscriber;

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
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gInstance];
            [UIApplication presentViewController:nav completion:nil];
            
        }
        return nil;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"登录", nil);
    self.view.backgroundColor = [UIColor drColorC0];
    UIScrollView *scrollView = [TPKeyboardAvoidingScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        
        self.phoneEditView = [ETEditView inputViewWithStyle:ETEditViewStylePhone placeHolder:NSLocalizedString(@"手机号", nil)];
        [_contentView addSubview:self.phoneEditView];
        [self.phoneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(55);
            make.left.equalTo(_contentView).offset(30);
            make.right.equalTo(_contentView).offset(-30);
        }];
        
        self.passwordEditView = [ETEditView inputViewWithStyle:ETEditViewStyleInputPassWord placeHolder:NSLocalizedString(@"密码", nil)];
        [_contentView addSubview:self.passwordEditView];
        [self.passwordEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneEditView.mas_bottom).offset(15);
            make.left.right.height.equalTo(self.phoneEditView);
        }];
        
        UIView *actionView = [self actionView];
        [_contentView addSubview:actionView];
        [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordEditView.mas_bottom).offset(10);
            make.left.right.equalTo(self.passwordEditView);
        }];
        
        @weakify(self);
        self.platformView = [ETPlatformView viewWithBlock:^(SSDKPlatformType platform) {
            @strongify(self);
            [self requestAuthorize:platform];
        }];
        [_contentView addSubview:self.platformView];
        [self.platformView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.top.equalTo(actionView.mas_bottom).offset(45);
            make.bottom.equalTo(_contentView).offset(-20);
        }];
        
    }
    return _contentView;
}


- (UIView *)actionView {
    
    UIView *actionView = [UIView new];
    actionView.backgroundColor = [UIColor clearColor];
    
    self.forgetPassordLabel = [TTTAttributedLabel attributedWithLinkColor:[UIColor drColorC5] activeLinkColor:[UIColor drColorC4] underLine:YES];
    self.forgetPassordLabel.textAlignment = NSTextAlignmentRight;
    self.forgetPassordLabel.text = NSLocalizedString(@"忘记密码?", nil);
    [self.forgetPassordLabel addLinkToTransitInformation:@{@"type": @"forgetpassword"} withRange:[_forgetPassordLabel.text rangeOfString:NSLocalizedString(@"忘记密码?", nil)]];
    self.forgetPassordLabel.delegate = self;
    [actionView addSubview:self.forgetPassordLabel];
    [self.forgetPassordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(actionView);
    }];
    
    self.submitButton = [UIButton buttonWithStyle:ETButtonStyleBlue height:44];
    [self.submitButton setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [actionView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(actionView).offset(64);
        make.centerX.equalTo(actionView);
        make.height.equalTo(@44);
        make.left.equalTo(actionView).offset(15);
        make.right.equalTo(actionView).offset(-15);
    }];
    
    self.registerLabel = [TTTAttributedLabel boldAttributedWithLinkColor:[UIColor drColorC4] activeLinkColor:[UIColor drColorC5]];
    self.registerLabel.textColor = [UIColor drColorC4];
    self.registerLabel.textAlignment = NSTextAlignmentCenter;
    self.registerLabel.text = NSLocalizedString(@"还没有账户？点击注册>>", nil);
    [self.registerLabel addLinkToTransitInformation:@{@"type": @"register"} withRange:[_registerLabel.text rangeOfString:NSLocalizedString(@"点击注册>>",nil)]];
    self.registerLabel.delegate = self;
    [actionView addSubview:self.registerLabel];
    
    [self.registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitButton.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(actionView);
    }];
    [self bindActions];
    return actionView;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if ([[components objectForKey:@"type"] isEqualToString:@"register"]) {
        RACSubject *subject = [RACSubject subject];
        [subject subscribeNext:^(id x) {
            [self dismiss];
        }];
        ETSignUpViewController *vc = [[ETSignUpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if([[components objectForKey:@"type"] isEqualToString:@"forgetpassword"]) {
        ETForgetPsdViewController *vc = [[ETForgetPsdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dismiss {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            gInstance = nil;
            if (_subscriber) {
                [_subscriber sendNext:@(YES)];
                [_subscriber sendCompleted];
            }
        }];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    gInstance = nil;
    if (_subscriber) {
        [_subscriber sendNext:@(YES)];
        [_subscriber sendCompleted];
    }
}

- (void)bindActions {
    RAC(self.submitButton, enabled)  = [self.passwordEditView.textField.rac_textSignal map:^id(id value) {
        return @([NSString isNotBlank:value]);
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
    [[[ETActor instance] loginWithAccount:account password:self.passwordEditView.textField.text] subscribeNext:^(id x) {
        [ETPopover showLoading:NO];
        [self dismiss];
    } error:^(NSError *error) {
        [ETPopover showFailureWithContent:[error message]];
    }];
}

- (void)requestAuthorize:(SSDKPlatformType)type {
    [ETActor instance].login = YES;
    [self dismiss];
    return;
    
    [ETPopover showLoading:YES];
    @weakify(self);
    [[[ETActor instance] thirdPlatformLogin:type] subscribeNext:^(id x) {
        @strongify(self);
        [ETPopover showLoading:NO];
        [self dismiss];
    } error:^(NSError *error) {
        if (!error) {
            [ETPopover showLoading:NO];
            return;
        }
        [ETPopover showFailureWithContent:error.message];
    }];
}

@end
