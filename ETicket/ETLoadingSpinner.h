//
//  ETLoadingSpinner.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETLoadingSpinner : UIView

@property (nonatomic) BOOL hidesWhenStopped;

- (instancetype)initWithStrokeColor:(UIColor *)strokeColor
                        strokeWidth:(CGFloat)strokeWidth;
- (void)startAnimation;
- (void)stopAnimation;
- (void)startAnimationWithCounter:(BOOL)counter;
- (void)stopAnimationWithCounter:(BOOL)counter;

@end
