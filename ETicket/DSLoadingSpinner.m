//
//  DSLoadingSpinner.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSLoadingSpinner.h"

@interface DSLoadingSpinner () {
    int retainAnimationCount;
}

@property (nonatomic) UIImageView *completeView;
@property (nonatomic) CAShapeLayer *spinnerLayer;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) CGFloat strokeWidth;

@end

@implementation DSLoadingSpinner

- (instancetype)initWithStrokeColor:(UIColor *)strokeColor
                        strokeWidth:(CGFloat)strokeWidth {
    if (self = [self init]) {
        self.strokeWidth = strokeWidth;
        self.strokeColor = strokeColor;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.strokeWidth = 2;
        self.completeView = [UIImageView new];
        self.completeView.backgroundColor = [UIColor clearColor];
        self.completeView.image = [UIImage imageNamed:@"spinnerIcon"];
        self.completeView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.completeView];
        [self.completeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(15);
            make.bottom.right.equalTo(self).offset(-15);
        }];
        self.completeView.alpha = 1;
    }
    return self;
}
- (void)layoutSubviews {
    [self createSpinnerLayer];
    self.spinnerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds),
                                         CGRectGetHeight(self.bounds));
}

- (void)createSpinnerLayer {
    if (self.spinnerLayer) {
        return;
    }
    self.spinnerLayer = [CAShapeLayer layer];
    _strokeColor = _strokeColor ?: [UIColor whiteColor];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat redius = MIN(self.bounds.size.width / 2,
                         self.bounds.size.height / 2) - self.strokeWidth / 2;
    CGFloat startAngle = -M_PI / 2;
    CGFloat endAngle = 3 * M_PI / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:redius startAngle:startAngle
                                                      endAngle:endAngle clockwise:YES];
    _spinnerLayer.fillColor = [UIColor clearColor].CGColor;
    _spinnerLayer.strokeColor = _strokeColor.CGColor;
    _spinnerLayer.lineWidth = _strokeWidth;
    _spinnerLayer.lineCap = kCALineCapRound;
    _spinnerLayer.path = path.CGPath;
    _spinnerLayer.strokeStart = 0;
    _spinnerLayer.strokeEnd = 1;
    [self.layer addSublayer:_spinnerLayer];
}

- (void)animation {
    _spinnerLayer.strokeStart = 0;
    _spinnerLayer.strokeEnd = 0;
    CABasicAnimation *animationStep1 =
    [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animationStep1.duration = 0.5;
    animationStep1.fromValue = @0;
    animationStep1.toValue = @0.75;
    animationStep1.fillMode = kCAFillModeForwards;
    animationStep1.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *animationStep2 =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animationStep2.duration = 1.0f;
    animationStep2.beginTime = 0.5;
    animationStep2.fromValue = @0;
    animationStep2.toValue = @(2 * M_PI);
    animationStep2.fillMode = kCAFillModeForwards;
    animationStep2.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *animationStep3 =
    [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animationStep3.beginTime = 1.5;
    animationStep3.fromValue = @0;
    animationStep3.toValue = @1;
    animationStep3.duration = 0.5;
    animationStep3.fillMode = kCAFillModeForwards;
    animationStep3.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *animationStep4 =
    [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animationStep4.beginTime = 1.5;
    animationStep4.duration = 0.5;
    animationStep4.fromValue = @0.75;
    animationStep4.toValue = @1.0f;
    animationStep4.fillMode = kCAFillModeForwards;
    animationStep4.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // 合并前两个动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations =
    @[animationStep1, animationStep2, animationStep3, animationStep4];
    groupAnimation.duration = 2;
    groupAnimation.repeatCount = INFINITY;
    [self.spinnerLayer addAnimation:groupAnimation forKey:@"animate"];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (![self isHidden]) {
        if (self.spinnerLayer.animationKeys.count == 0) {
            dispatch_after(
                           dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               [self startAnimation];
                           });
        }
    } else {
        [self stopAnimation];
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
    }
    [self stopAnimation];
    [self animation];
    self.completeView.alpha = 0;
}

- (void)stopAnimationWithCounter:(BOOL)counter {
    if (counter) {
        retainAnimationCount--;
        if (retainAnimationCount <= 0) {
            retainAnimationCount = 0;
            [self stopAnimation];
        }
    }
    [self.spinnerLayer removeAnimationForKey:@"animate"];
    [self.spinnerLayer removeAnimationForKey:@"rotate"];
    self.spinnerLayer.strokeEnd = 1;
    self.spinnerLayer.strokeStart = 0;
    self.completeView.alpha = 0;
    self.completeView.transform = CGAffineTransformMakeScale(2, 2);
    [UIView animateWithDuration:0.25 animations:^{
        self.completeView.alpha = 1;
        self.completeView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
    }];
}

@end

