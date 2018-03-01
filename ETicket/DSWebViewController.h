//
//  DSWebViewController.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSWebViewController : UIViewController<UIWebViewDelegate>

- (id)initWithURL:(NSString *)url title:(NSString *)viewTitle;
- (id)initWithData:(NSString *)content title:(NSString *)viewTitle;

@end
