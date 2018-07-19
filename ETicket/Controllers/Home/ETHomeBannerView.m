//
//  ETHomeBannerView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/18.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHomeBannerView.h"
#import "ETBannerScrollView.h"

@interface ETHomeBannerView ()

@property (nonatomic) CAShapeLayer *maskLayer;

@end

@implementation ETHomeBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.bannerView = [ETBannerScrollView new];
        self.bannerView.backgroundColor = [UIColor drColorC0];
        self.bannerView.isHorizontal = YES;
        [self addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    if (!self.maskLayer) {
        [self createMaskLayer];
    }
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    [path addQuadCurveToPoint:CGPointMake(self.width, self.height) controlPoint:CGPointMake(self.width/2, self.height - 15)];
    [path addLineToPoint:CGPointMake(self.width, 0)];
    [path closePath];
    self.maskLayer.path = path.CGPath;
}

- (void)createMaskLayer {
    self.maskLayer = [CAShapeLayer new];
    self.maskLayer.fillColor = [UIColor whiteColor].CGColor;
    self.maskLayer.strokeColor = [UIColor clearColor].CGColor;
    self.maskLayer.lineWidth = 1;
    self.maskLayer.lineCap = kCALineCapRound;
    self.maskLayer.strokeStart = 1;
    self.maskLayer.strokeEnd = 0;
    self.layer.mask = self.maskLayer;
}

@end
