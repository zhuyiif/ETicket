//
//  UIBarButtonItem+Helper.h
//  Brainspie
//
//  Created by chunjian wang on 16/6/11.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Helper)

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)title
                                 normalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage;

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)title
                                     isRight:(BOOL)isRight;

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)title
                                 normalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage
                           contentEdgeInsets:(UIEdgeInsets)insets;

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)title
                                  titleColor:(UIColor *)textColor
                                 normalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage
                           contentEdgeInsets:(UIEdgeInsets)insets;

@end
