//
//  DSConstant.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#ifndef DSConstant_h
#define DSConstant_h

#ifdef DEBUG
#define DLog(fmt, ...) \
NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define RGBCOLOR_0XFF(r, g, b)                                                  \
[UIColor colorWithRed:(((float)r) / ((float)0xff)) green:(((float)g) /      \
((float)0xff)) \
blue:(((float)b) / ((float)0xff)) alpha:1]

#define RGBA_COLOR_F(r, g, b, a)                                                \
[UIColor colorWithRed:(((float)r) / ((float)0xff)) green:(((float)g) /      \
((float)0xff)) \
blue:(((float)b) / ((float)0xff)) alpha:(a)]

#define Bundle_FILE_PATH(FILE_NAME)       \
[[[NSBundle mainBundle] resourcePath] \
stringByAppendingPathComponent:FILE_NAME]

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define OS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

#define KShareSDKKey @"c938386165ef"


#define KWeiXinKey @"wxb47ab60c5974a878"
#define KWeiXinSecret @"96dbdcb664e805baaa1d3d3da62a1625"

#define KQQPushID 2200250398
#define KQQPushKey @"I3W59B2WYW1E"
#define KQQPushSecret @"3afcc205bb88462179ad0ef8b617bf65"

#define KAppID @"1153626434"

#define KQQAppId @"1105658032"
#define KQQSercet @"wl6sNGeaKQsJSjqX"

#define KBDAPI_KEY \
@"xYm11wlyxx3bucOYESwNyhwy" // 请修改为您在百度开发者平台申请的API_KEY
#define KBDSECRET_KEY \
@"2095e2171a3aa918c26972e03dbcb5ca" // 请修改您在百度开发者平台申请的SECRET_KEY
#define KBDAPPID @"9504511" // 请修改为您在百度开发者平台申请的APP ID

#define KFULL_DATE_FORMAT @"YYYY-MM-dd HH:mm"
#define KYEAR_DATE_FORMAT @"YYYY-MM-dd"


#define KAcceptHeaderKey @"Accept"

#define KAcceptHeaderValue @"application/json"

#define kAppleLookupURLTemplate @"http://itunes.apple.com/lookup?id=%@"

#define kAppStoreURLTemplate @"itms-apps://itunes.apple.com/app/id%@"

#define KVersion           \
[[NSBundle mainBundle] \
objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define KProdName \
[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

#define kNetworkErrorCode -10008
#define kEmptyMessage NSLocalizedString(@"空空如也", nil)
#define kLoadErrorMessage NSLocalizedString(@"加载失败", nil)
#define kTranslateErrorMessage NSLocalizedString(@"小博没翻译出来...", nil)
#endif /* DSConstant_h */
