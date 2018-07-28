//
//  UIBarButtonItem+Helper.m
//  Brainspie
//
//  Created by chunjian wang on 16/6/11.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "UIBarButtonItem+Helper.h"

@implementation UIBarButtonItem (Helper)
+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)aTitle
                                 normalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage {
    return [[self class] barButtonItemWithTarget:target
                                          action:action
                                           title:aTitle
                                     normalImage:normalImage
                                highlightedImage:highlightedImage
                               contentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)title
                                     isRight:(BOOL)isRight {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor white2] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.titleLabel.font = [UIFont fontWithSize:15];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    }
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    button.frame = CGRectMake(0, 0, 80, 20);
    button.contentHorizontalAlignment = isRight ? UIControlContentHorizontalAlignmentRight : UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)aTitle
                                 normalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage
                           contentEdgeInsets:(UIEdgeInsets)insets {
    return [self.class barButtonItemWithTarget:target
                                        action:action
                                         title:aTitle
                                    titleColor:[UIColor whiteColor]
                                   normalImage:normalImage
                              highlightedImage:highlightedImage
                             contentEdgeInsets:insets];
}

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)action
                                       title:(NSString *)aTitle
                                  titleColor:(UIColor *)textColor
                                 normalImage:(UIImage *)normalImage
                            highlightedImage:(UIImage *)highlightedImage
                           contentEdgeInsets:(UIEdgeInsets)insets {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (!aTitle) {
        if (normalImage) {
            [button setImage:normalImage forState:UIControlStateNormal];
        }
        
        if (highlightedImage) {
            [button setImage:highlightedImage forState:UIControlStateHighlighted];
        }
    } else {
        [button setTitle:aTitle forState:UIControlStateNormal];
        [button setTitleColor:textColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithSize:15];
        
        if (normalImage) {
            [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        }
        if (highlightedImage) {
            [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        }
    }
    
    if (normalImage) {
        button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    } else {
        button.frame = CGRectMake(0, 0, 40, 20);
    }
    
    [button setContentEdgeInsets:insets];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
