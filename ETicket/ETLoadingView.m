//
//  ETLoadingView.m
//  ETicket
//
//  Created by chunjian wang on 2017/5/2.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import "ETLoadingView.h"
#import "ETLoadingSpinner.h"
#import "ETLoadingView.h"

@interface ETLoadingView ()

@property (nonatomic) UIView *containerView;
@property (nonatomic) UIView *contentView;
@property (nonatomic) ETLoadingSpinner *loadingSpinner;
@property (nonatomic) BOOL hiding;

@end

@implementation ETLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.contentView = [UIView new];
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 8;
    self.contentView.layer.borderColor = [UIColor drColorC2].CGColor;
    self.contentView.layer.borderWidth = .5f;
    self.contentView.backgroundColor = [UIColor drColorC0];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(.6);
    }];
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [[UIColor drColorC5] colorWithAlphaComponent:.03];
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.loadingSpinner = [ETLoadingSpinner new];
    self.loadingSpinner.backgroundColor = [UIColor clearColor];
    self.loadingSpinner.strokeColor = [UIColor drColorC5];
    [self.containerView addSubview:self.loadingSpinner];
    [self.loadingSpinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.top.equalTo(self.containerView).offset(25);
        make.centerX.equalTo(self.containerView);
    }];
    
    self.textLabel = [UILabel new];
    self.textLabel.textColor = [UIColor drColorC5];
    self.textLabel.text = NSLocalizedString(@"加载中",nil);
    self.textLabel.font = [UIFont s02Font];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView).offset(-30);
        make.top.equalTo(self.loadingSpinner.mas_bottom).offset(25);
        make.left.greaterThanOrEqualTo(self.containerView).offset(10);
        make.right.lessThanOrEqualTo(self.containerView).offset(-10);
    }];
    
    
    self.closeButton = [UIButton new];
    [self.containerView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
    }];
    
    [self.closeButton setImage:[UIImage imageNamed:@"toastCloseIcon"] forState:UIControlStateNormal];
    self.contentView.alpha = 0.0;
    self.contentView.transform = CGAffineTransformMakeScale(.5, .5);
}

- (void)show {
    [self show:nil];
}

- (void)show:(void(^)(void))completion {
    self.contentView.alpha = 0.0;
    self.contentView.transform = CGAffineTransformMakeScale(.5, .5);
    [UIView animateWithDuration:.1 delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.alpha = 1.0;
        self.contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        if (self.loadingSpinner) {
            [self.loadingSpinner startAnimation];
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)hide:(void (^)(void))completion {
    [self hide:completion isAnimate:NO];
}

- (void)hide:(void (^)(void))completion isAnimate:(BOOL)isAnimate {
    if (self.hiding) {
        return;
    }
    [self.loadingSpinner stopAnimation];
    if (isAnimate) {
        self.hiding = YES;
        [UIView animateWithDuration:.2 delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentView.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeScale(.5f, .5f);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.hiding = NO;
            if (completion) {
                completion();
            }
        }];
    } else {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }
}

@end
