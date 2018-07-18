//
//  ETToastView.m
//  ETicket
//
//  Created by chunjian wang on 2017/5/2.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

//#import <Lottie/LOTAnimationView.h>

#import "TTTAttributedLabel+additions.h"
#import "UIImage+Draw.h"
#import "ETToastView.h"

#define kTextLabelMinLen 140

@interface ETToastView ()

@property (nonatomic) ETToastStyle style;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UIImageView *failureIconView;
//@property (nonatomic) LOTAnimationView *lottieView;
@property (nonatomic) TTTAttributedLabel *textLabel;
@property (nonatomic) NSString *content;

@end

@implementation ETToastView

- (instancetype)initWithStyle:(ETToastStyle)style content:(NSString *)content {
    if (self = [super initWithFrame:CGRectZero]) {
        self.style = style;
        self.content = content;
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
        if (_style == ETToastText) {
            make.height.greaterThanOrEqualTo(@90);
            make.width.lessThanOrEqualTo(self.mas_width).multipliedBy(.6).priority(800);
        } else {
            make.width.equalTo(self.mas_width).multipliedBy(.6);
        }
    }];
    
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.contentView.alpha = 0.0;
    self.contentView.transform = CGAffineTransformMakeScale(.5, .5);
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [self containerColor];
        switch (self.style) {
                //            case ETToastSuccess: {
                //                self.lottieView = [LOTAnimationView animationNamed:@"toastSuccess"];
                //                [_containerView addSubview:self.lottieView];
                //                [self.lottieView mas_makeConstraints:^(MASConstraintMaker *make) {
                //                    make.width.height.equalTo(@50);
                //                    make.centerX.equalTo(_containerView);
                //                    make.top.equalTo(_containerView).offset(25);
                //                }];
                //
                //                [_containerView addSubview:self.textLabel];
                //                [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                //                    make.centerX.equalTo(_containerView);
                //                    make.bottom.equalTo(_containerView).offset(-30);
                //                    make.top.equalTo(self.lottieView.mas_bottom).offset(25);
                //                    make.left.greaterThanOrEqualTo(_containerView).offset(20);
                //                    make.right.lessThanOrEqualTo(_containerView).offset(-20);
                //                }];
                //            } break;
            case ETToastFailure: {
                self.failureIconView = [UIImageView new];
                self.failureIconView.backgroundColor = [UIColor clearColor];
                self.failureIconView.image = [[UIImage imageNamed:@"toastErrorIcon"] imageByFilledWithColor:[UIColor drColorC17]];
                [_containerView addSubview:self.failureIconView];
                [self.failureIconView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@50);
                    make.centerX.equalTo(_containerView);
                    make.top.equalTo(_containerView).offset(25);
                }];
                
                [_containerView addSubview:self.textLabel];
                [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_containerView);
                    make.bottom.equalTo(_containerView).offset(-30);
                    make.top.equalTo(self.failureIconView.mas_bottom).offset(25);
                    make.left.greaterThanOrEqualTo(_containerView).offset(20);
                    make.right.lessThanOrEqualTo(_containerView).offset(-20);
                }];
            } break;
            case ETToastSuccess:
            case ETToastText: {
                [_containerView addSubview:self.textLabel];
                [self.textLabel sizeToFit];
                self.textLabel.textAlignment = _textLabel.frame.size.width > kTextLabelMinLen ? NSTextAlignmentLeft : NSTextAlignmentCenter;
                [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_containerView);
                    make.bottom.equalTo(_containerView).offset(-20);
                    make.top.equalTo(_containerView).offset(20);
                    make.width.greaterThanOrEqualTo(@(kTextLabelMinLen));
                    make.left.equalTo(_containerView).offset(20);
                    make.right.equalTo(_containerView).offset(-20);
                }];
            } break;
                
            default:
                break;
        }
    }
    return _containerView;
}

- (void)show {
    self.contentView.alpha = 0.0;
    self.contentView.transform = CGAffineTransformMakeScale(.5, .5);
    [UIView animateWithDuration:.2 delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.alpha = 1.0;
        self.contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
//        if (self.lottieView) {
//            [self.lottieView play];
//        }
    }];
}

- (void)hide:(void (^)(void))completion {
    [UIView animateWithDuration:.2 delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(.5f, .5f);
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (TTTAttributedLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [TTTAttributedLabel new];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [self textColor];
        _textLabel.font = [UIFont s03Font];
        _textLabel.numberOfLines = 0;
        _textLabel.lineSpacing = 4;
        _textLabel.text = self.content;
    }
    return _textLabel;
}

- (UIColor *)containerColor {
    return [[self textColor] colorWithAlphaComponent:.03];
}

- (UIColor *)textColor {
    UIColor *color = [UIColor drColorC5];
    if (ETToastFailure == self.style) {
        color = [UIColor drColorC17];
    } else if (ETToastSuccess == self.style) {
        color = [UIColor drColorC5];
    }
    return color;
}

@end
