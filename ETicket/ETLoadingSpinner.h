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
@property (nonatomic) UIColor *strokeColor;

- (void)startAnimation;
- (void)stopAnimation;
- (void)startAnimationWithCounter:(BOOL)counter;
- (void)stopAnimationWithCounter:(BOOL)counter;

@end
