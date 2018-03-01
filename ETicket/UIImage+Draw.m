// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Draw.h"

@implementation UIImage (Draw)

+ (instancetype)blankImageWithSize:(CGSize)size {
    return [self blankImageWithSize:size fillColor:[UIColor whiteColor] strokeColor:[UIColor grayColor]];
}

+ (instancetype)blankImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)arrowImageWithSize:(CGSize)size direction:(TTArrowDirection)direction color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor);

    static CGFloat gPoints[][6] = {
        {0, 1, .5, 0, 1, 1},
        {0, 0, 1, 0, .5, 1},
        {0, .5, 1, 0, 1, 1},
        {0, 0, 0, 1, 1, .5},
    };

    CGFloat *p = (CGFloat *)gPoints[(int)direction];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, p[0] * size.width, p[1] * size.height);
    CGContextAddLineToPoint(context, p[2] * size.width, p[3] * size.height);
    CGContextAddLineToPoint(context, p[4] * size.width, p[5] * size.height);
    CGContextClosePath(context);
    CGContextFillPath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// from https://github.com/youknowone/UI7Kit
- (UIImage *)imageByFilledWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [color set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectZero;
    bounds.size = self.size;
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextClipToMask(context, bounds, self.CGImage);
    CGContextFillRect(context, bounds);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

CGFloat degreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat radiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

- (UIImage *)imageWithRotate:(CGFloat)angle {
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degreesToRadians(angle));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, degreesToRadians(angle));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
