// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TTArrowDirection) {
    TTArrowDirectionUp,
    TTArrowDirectionDown,
    TTArrowDirectionLeft,
    TTArrowDirectionRight,
};


@interface UIImage (Draw)

+ (instancetype)blankImageWithSize:(CGSize)size;
+ (instancetype)blankImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;
+ (instancetype)arrowImageWithSize:(CGSize)size direction:(TTArrowDirection)direction color:(UIColor *)color;

- (UIImage *)imageByFilledWithColor:(UIColor *)color;
- (UIImage *)imageWithRotate:(CGFloat)angle;

@end
