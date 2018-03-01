//
//  ETPlatformView.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETPlatformView.h"
#import "UIButton+Style.h"

@implementation ETPlatformView

+ (instancetype)viewWithBlock:(void (^)(SSDKPlatformType))completeBlock {
    ETPlatformView *platformView = [ETPlatformView new];
    [platformView setupWithBlock:completeBlock];
    return platformView;
}

- (void)setupWithBlock:(void (^)(SSDKPlatformType))completeBlock {
    self.backgroundColor = [UIColor clearColor];
    UIView *separatorView = [self separatorView];
    [self addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
    }];
    
    UIView *buttonArea = [UIView new];
    buttonArea.backgroundColor = [UIColor clearColor];
    [self addSubview:buttonArea];
    [buttonArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorView.mas_bottom).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    
    UIButton *wechat = [UIButton buttonWithNormalImage:@"loginWechatNor" hightImage:@"loginWechatNor"];
    if ([self isInstallWeChat]) {
        [buttonArea addSubview:wechat];
    }
    
    UIButton *qq = [UIButton buttonWithNormalImage:@"loginQQNor" hightImage:@"loginWechatNor"];
    [buttonArea addSubview:qq];
    
    UIButton *facebook = [UIButton buttonWithNormalImage:@"loginFacebookNor" hightImage:@"loginWechatNor"];
    [buttonArea addSubview:facebook];
    
    
    NSArray *buttons = [self isInstallWeChat] ? @[wechat, qq, facebook] : @[qq, facebook];
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(buttonArea);
        make.height.equalTo(qq.mas_width);
    }];
    
    if (completeBlock) {
        [[qq eventSingal] subscribeNext:^(id x) {
            completeBlock(SSDKPlatformTypeQQ);
        }];
        
        [[wechat eventSingal] subscribeNext:^(id x) {
            completeBlock(SSDKPlatformTypeWechat);
        }];
        
        [[facebook eventSingal] subscribeNext:^(id x) {
            completeBlock(SSDKPlatformTypeFacebook);
        }];
    }
}

- (UIView *)separatorView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UILabel *tipLabel = [UILabel new];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = [UIColor drColorC4];
    tipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont fontWithSize:14];
    
    tipLabel.text = NSLocalizedString(@"使用第三方账号",nil);
    [view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = [UIColor colorWithHex:0xe5bb88];
    [view addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipLabel);
        make.left.equalTo(view).offset(30);
        make.right.equalTo(tipLabel.mas_left).offset(-25);
        make.height.equalTo(@.5);
    }];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = [UIColor drColorC3];
    [view addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-30);
        make.left.equalTo(tipLabel.mas_right).offset(25);
        make.height.equalTo(@.5);
        make.centerY.equalTo(leftLine);
    }];
    return view;
}

- (BOOL)isInstallWeChat {
    return  YES;
    BOOL weixinInstalled = NO;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        weixinInstalled = YES;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]){
        weixinInstalled = YES;
    }
    return weixinInstalled;
}

@end
