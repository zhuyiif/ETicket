// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)cropFromScrollView:(UIScrollView *)scrollView withSize:(CGSize)size;

+ (CGFloat)minimumScaleFromSize:(CGSize)size toFitTargetSize:(CGSize)targetSize;

@end
