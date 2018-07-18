//
//  ETLoadingSpinner.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETLoadingSpinner.h"

@interface ETLoadingSpinner() {
    int retainAnimationCount;
}

@property (nonatomic) CAShapeLayer *spinnerLayer;

@end

@implementation ETLoadingSpinner

- (instancetype)init {
    if (self = [super init]) {
        [self createSpinnerLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self createSpinnerLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [self updateSpinnerLayer];
}

- (void)updateSpinnerLayer {
    if (!self.spinnerLayer) {
        [self createSpinnerLayer];
    }
    CGFloat lineWidth = _spinnerLayer.lineWidth;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat redius = MIN(self.bounds.size.width / 2, self.bounds.size.height/2) - lineWidth / 2;
    CGFloat startAngle = 0;
    CGFloat endAngle = 2 * M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:redius startAngle:startAngle endAngle:endAngle clockwise:YES];
    _spinnerLayer.path = path.CGPath;
    self.spinnerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
}

- (void)createSpinnerLayer {
    if (self.spinnerLayer) {
        return;
    }
    self.spinnerLayer = [CAShapeLayer layer];
    _strokeColor = _strokeColor ?: [UIColor whiteColor];
    CGFloat lineWidth = 1;
    _spinnerLayer.fillColor = [UIColor clearColor].CGColor;
    _spinnerLayer.strokeColor = _strokeColor.CGColor;
    _spinnerLayer.lineWidth = lineWidth;
    _spinnerLayer.lineCap = kCALineCapRound;
    _spinnerLayer.strokeStart = 1;
    _spinnerLayer.strokeEnd = 0;
    [self.layer addSublayer:_spinnerLayer];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    self.spinnerLayer.strokeColor = strokeColor.CGColor;
}

- (void)animation {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = 3;
    rotation.fromValue = @0;
    rotation.toValue = @(2 * M_PI);
    rotation.repeatCount = INFINITY;
    [self.spinnerLayer addAnimation:rotation forKey:@"rotate"];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation.duration = 1;
    headAnimation.fromValue = @0;
    headAnimation.toValue = @0.25;
    headAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation.duration = 1;
    tailAnimation.fromValue = @0;
    tailAnimation.toValue = @1;
    tailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    endHeadAnimation.beginTime = 1;
    endHeadAnimation.duration = 0.5;
    endHeadAnimation.fromValue = @0.25;
    endHeadAnimation.toValue = @1;
    endHeadAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endTailAnimation.beginTime = 1;
    endTailAnimation.duration = 0.5;
    endTailAnimation.fromValue = @1;
    endTailAnimation.toValue = @1;
    endTailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // 合并前两个动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[headAnimation,tailAnimation,endHeadAnimation,endTailAnimation];
    groupAnimation.duration = 1.5;
    groupAnimation.repeatCount = INFINITY;
    [self.spinnerLayer addAnimation:groupAnimation forKey:@"animate"];
    
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    if (![self isHidden]) {
        if (self.spinnerLayer.animationKeys.count == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startAnimation];
            });
        }
    }
    else{
        if (self.spinnerLayer.animationKeys.count > 0) {
            [self stopAnimation];
        }
    }
}

- (void)startAnimation {
    [self startAnimationWithCounter:NO];
}

- (void)stopAnimation {
    [self stopAnimationWithCounter:NO];
}

- (void)startAnimationWithCounter:(BOOL)counter {
    if (counter) {
        retainAnimationCount++;
        self.hidden = NO;
    }
    NSLog(@"----%@",self.spinnerLayer.animationKeys);
    if (![self.spinnerLayer.animationKeys containsObject:@"animate"]) {
        [self animation];
    }
}

- (void)stopAnimationWithCounter:(BOOL)counter {
    if (counter) {
        retainAnimationCount--;
        if(retainAnimationCount <= 0) {
            retainAnimationCount = 0;
            [self stopAnimation];
            self.hidden = YES;
        }
    }
    else{
        [self.spinnerLayer removeAnimationForKey:@"animate"];
        [self.spinnerLayer removeAnimationForKey:@"rotate"];
    }
}


@end

