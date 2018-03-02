//
//  APICenter.h
//  Brainspie
//
//  Created by chunjian wang on 16/5/4.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Query.h"

@interface APICenter : NSObject

/*
 除去少数显示网页、图片的特殊API，其余的返回格式都是基于 JSON。且分三大类:
 Type A: get a list             对应 getXxx -> Query queryGET...      listKey 不为空
 Type B: get a single item      对应 getXxx -> Query queryGET...      listKey 为空
 Type C: submit a POST          对应 postXxx -> Query queryPOST...

 其中，部分无需登录，部分未登录则会返回 result = login

 其中，Type A 和 B，可先使用缓存的数据，然后请求最新内容。
 Type C 一律禁用缓存。

 所有必选参数都是显式参数名传入，可选参数都在 parameters 字典中传入


 HTML:
/api/v2/contract?loanId=%@&orderId=%@


 Image:
/images/captcha.jpg

 API 转为方法的命名算法如下：
 1. 忽略 namespace，如 /api/v2
 2. 去除特殊字符 / - _，并将它们之后的第一个字母转为大写
 3. get, post 动词接在开头
 4. 路径中的 {xxxId} 都转为命名参数 xxxId:(id)xxxId
 5. 统一先接上 :(NSDictionary *)parameters 作为第一个参数
 */

+ (Query *)getBanner:(NSDictionary *)parameters;
+ (Query *)getAgreementProtocol:(NSDictionary *)parameters;
+ (Query *)getPaymentSN:(NSDictionary *)parameters;
+ (Query *)getUserProfile:(NSDictionary*)parameters;
+ (Query *)postSMS:(NSDictionary *)parameters;
+ (Query *)postForgetPassword:(NSDictionary *)parameters;
+ (Query *)putPaymentConfirmation:(NSDictionary *)parameters;
+ (Query *)postLogin:(NSDictionary *)parameters;
+ (Query *)postGetCode:(NSDictionary *)parameters;

@end
