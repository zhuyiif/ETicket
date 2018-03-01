//
//  ETAppConfigurations.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETAppConfigurations.h"
#import "UIImage+Draw.h"

@implementation ETAppConfigurations

+ (void)configTheme {
   
    // TabBar
    [[UITabBar appearance] setBackgroundImage:[UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:[UIColor drColorC0] strokeColor:[UIColor drColorC0]]];
    [[UITabBar appearance] setShadowImage:[UIImage blankImageWithSize:CGSizeMake(0.5, 0.5) fillColor:[UIColor colorWithWhite:0 alpha:0.1] strokeColor:[UIColor colorWithWhite:0 alpha:0.1]]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor drColorC4], NSFontAttributeName: [UIFont fontWithSize:12] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor drColorC8], NSFontAttributeName: [UIFont fontWithSize:12] } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    // NaviBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage blankImageWithSize:CGSizeMake(1, 1) fillColor:[UIColor drColorC0] strokeColor:[UIColor drColorC0]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    UIImage *backImage = [[UIImage imageNamed:@"navBack"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [[UINavigationBar appearance] setBackIndicatorImage:[backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithSize:16], NSForegroundColorAttributeName: [UIColor drColorC5]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithSize:14], NSForegroundColorAttributeName: [UIColor drColorC8] } forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[UIColor drColorC8]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:UIToolbar.class, nil] setTintColor:[UIColor drColorC8]];
    [[UITableView appearance] setSeparatorColor:[UIColor drColorC2]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [[UITableView appearance] setSeparatorColor:[UIColor seperatorLineColor]];
}

+ (void)configSNSPlatforms {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login
     * 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
                                                         @(SSDKPlatformTypeQQ),
                                                         @(SSDKPlatformTypeFacebook),
                                                         @(SSDKPlatformTypeTwitter),
                                                         @(SSDKPlatformTypeMail)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType) {
                         case SSDKPlatformTypeWechat: {
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                         }
                             break;
                         case SSDKPlatformTypeQQ: {
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                         }
                             break;
                         default:
                             break;
                     }
                     
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:KWeiXinKey appSecret:KWeiXinSecret];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:KQQAppId appKey:KQQSercet
                                                authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeFacebook:
                             //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                             [appInfo SSDKSetupFacebookByApiKey:@"304471046617925"
                                                      appSecret:@"ee7f98a7fcd6374ebf35e00d94666833"
                                                       authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeTwitter:
                             [appInfo SSDKSetupTwitterByConsumerKey:@"OnYTMiknizvkBCdF5gCZAnEd2"
                                                     consumerSecret:@"AgJirs18OxlNDpCljQTgu2nWxtyPOMKFKvUgPZIfPDOM0bml6q"
                                                        redirectUri:@"http://www.baidu.com/"];
                             break;
                         default:
                             break;
                     }
                 }];
}

+ (void)configPopoverController {
    WYPopoverBackgroundView *popoverAppearance = [WYPopoverBackgroundView appearance];
    
    [popoverAppearance setOuterCornerRadius:4];
    [popoverAppearance setMinOuterCornerRadius:4];
    [popoverAppearance setOuterShadowBlurRadius:0];
    [popoverAppearance setOuterShadowColor:[UIColor drColorC8]];
    [popoverAppearance setOuterShadowOffset:CGSizeMake(0, 0)];
    
    [popoverAppearance setGlossShadowColor:[UIColor drColorC8]];
    [popoverAppearance setGlossShadowOffset:CGSizeMake(0, 0)];
    [popoverAppearance setBorderWidth:4];
    [popoverAppearance setArrowHeight:10];
    [popoverAppearance setArrowBase:20];
    [popoverAppearance setInnerCornerRadius:4];
    [popoverAppearance setInnerShadowBlurRadius:0];
    [popoverAppearance setInnerShadowColor:[UIColor drColorC8]];
    [popoverAppearance setInnerShadowOffset:CGSizeMake(0, 0)];
    [popoverAppearance setFillTopColor:[UIColor drColorC8]];
    [popoverAppearance setFillBottomColor:[UIColor drColorC8]];
}

@end
