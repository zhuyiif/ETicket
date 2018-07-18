//
//  ETConstant.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#ifndef ETConstant_h
#define ETConstant_h

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

#define PIXEL_SCALE (([[UIScreen mainScreen] bounds].size.width) / 375.0)
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

//商户PID
#define kAlipayPartner @"2017062007529743"
//商户收款账号
#define kAlipaySeller @"1213784580@qq.com"
//商户私钥，pkcs8格式
#define kAlipayRSAPrivate @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC00Bk0K5bfzBA+jsW6oh9M5adFDu+3eo1lfdMlY0VFfr69x0EZmixhDTddMDpialanEDERVeHA3Su/EiDIqcgB65MEkGGP7RhCKmdSLOT+iN6czzeID/PeDEvHxg/hP/hTH5pMEWMUPVpBl8Z25NHksxQxlRnrOpOoFTWSCyw84iogAk1jaHQVK5gCnlN1TL7QVGePPu0Lk6d6VWFH7jNKMw+qO0u+tt4LwEAmxnI+7WLzHrVYt5p7Xv7wf6Zcu3m2Fk3OfRFfJbaXHPunODNcxL4HtMEd50Yhud3PmftK87Dg2iIG7jZO1tLXAh1Hd1hX/zhSf+RLt5lNPxhqsFxlAgMBAAECggEAed+ifWW8JlEXyfLWGDxauKw7GPM+ZP+3+ubawWKuOG98BdMecDFZJHmSDcAKOnfOvIDPcg3fQu5RJFMFwfuekpzE1dizyh1XspF+Xwdfuqlq02tg1Ndb2xmSoq8/2OYTbYPprsgxbl0ETx4MaetGBs8mF12WwNUU3cCeATiCsu3jEfeZB/fqjUyLylG9tvQzWjgr+EdYVXU0e22n7o4YPDjjB30NH6T7eE20q5+aVA8h/ZhMHLpuX+5EV7JjfFtySgWNpQPzMim3YTq/Jw0hbnNfDhKnQL8ZjovcsaRtsomm7qXSaUpHoq5JVaiquyu+DLyxfF8qSiK5lnnqpqsLqQKBgQDv4AONR87/aEx+sQnMAMtuwY1CNERzS6B1XYfgl9kISDb0ALxBuMADGKgn+VWX4k1u9Ct6nu4QWfw4dFMe4sAjkpR4fDtr/JQZqGvl5TCilLG63sekCDXYCTwML8DR+iQjQZgrCBq1uuhHfNXhsoqeGWAVIdXlObVrnblG8qo4awKBgQDA97CFKTCL//4NBxcwXxYZO2pxm1su85OttdHyEK2ROQiGnghiJF2ZThKtD81hZLfXRTXRlQTafz4CMx1WuO+mRGD53+Ipe0w2KlAL//e652kQM9Kw7Odqv4C1lAT6N76EqS+3FyOcUeyY2AvA+mKtYFiD3Er2OB+2dWA8NtcybwKBgEARNOGnLEJLOSMdZeB21d7fEzt7ekzRBipSsNfrtqvfnc3N5HopPh+VllQW5CWM6+GWlYZKrIrxfcwWRZ0aMvdNTxpfE//jlirEMQ1WCYdi75VZqzjEeJ0a2k7m8jki9kP0YRAdOgUPxrpRPU7qwNs5K9B5GQgAQdRca//nEE/BAoGAP6Vyo3kiegrFUKa2D05Ni6T9RttnB+VvICyIQr8dgHi/Ryd4vGYiOR53Kn270BPYTziUt7vfDfJKEY+qbaAx6zVChyhBAE2apYLvRAX5P7xz+tQc+h4pdhwT59AalC0uubLT+h+3ryeWUhNwTQZI5caRa2yNjQiV7ShpxXKRKCECgYEAlR5ft7akFfBjUEF9qYbBbXwAv9cG4hSVPvrWvcv1iP0bMOA+199wEm4mUJLePAZ9Mz6NB4dpH1EF30+lSWAoBVTIOJbqmySpUCmqLqkZPJMKcdjS6xU+kG5YGeRawYBbrCIk7CTCC0QURabLKcB2nAFfSqvZZFMyMUfYXf1V9xw="
//支付宝公钥
#define kAplipayRSAPublic @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

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
#define KBETECRET_KEY \
@"2095e2171a3aa918c26972e03dbcb5ca" // 请修改您在百度开发者平台申请的SECRET_KEY
#define KBDAPPID @"9504511" // 请修改为您在百度开发者平台申请的APP ID

#define KFULL_DATE_FORMAT @"YYYY-MM-dd HH:mm"
#define KYEAR_DATE_FORMAT @"YYYY-MM-dd"
#define kPaddingLeftSize 15

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
#endif /* ETConstant_h */
