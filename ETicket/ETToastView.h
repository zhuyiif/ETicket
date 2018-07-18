//
//  ETToastView.h
//  ETicket
//
//  Created by chunjian wang on 2017/5/2.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ETToastStyle) {
    ETToastSuccess,
    ETToastFailure,
    ETToastText
};

@interface ETToastView : UIView

- (instancetype)initWithStyle:(ETToastStyle)style content:(NSString *)content;
- (void)show;
- (void)hide:(void (^)(void))completion;

@end
