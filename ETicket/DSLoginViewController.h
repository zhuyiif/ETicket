//
//  DSLoginViewController.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLoginViewController : UIViewController

+ (RACSignal *)showIfNeeded;
+ (RACSignal *)show;

@end
