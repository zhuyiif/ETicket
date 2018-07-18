//
//  ETAnouncementScrollView.m
//  ETicket
//
//  Created by chunjian wang on 2017/4/20.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import "ETAnouncementScrollView.h"
#import "ETWebViewController.h"

@interface ETAnouncementScrollView () <CAAnimationDelegate>

@property (nonatomic) UIView *contentView;
@property (nonatomic) NSArray<ETAnouncementInfo *> *items;
@property (nonatomic) NSInteger index;
@property (nonatomic) UIImageView *iconView;

@end

@implementation ETAnouncementScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor drColorC0];
        self.clipsToBounds = YES;
        
        UIImageView *hornImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlanDetailAnnouncement"]];
        self.iconView = hornImg;
        [self addSubview:hornImg];
        [hornImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.width.height.equalTo(@14);
            make.centerY.equalTo(self);
        }];
        
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = YES;
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self);
            make.left.equalTo(self.iconView.mas_right).offset(5);
        }];
    }
    return self;
}

- (void)invalidate {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)setAnouncements:(NSArray<ETAnouncementInfo *> *)items {
    self.items = items;
    self.index = -1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.contentView removeAllSubviews];
    [self showAnouncement];
}

- (void)showAnouncement {
    if (!self.items || self.items.count == 0) {
        return;
    }
    self.index++;
    self.index = self.index >= self.items.count ? 0 : self.index;
    ETAnouncementInfo *info = self.items[self.index];
    UIView *anouncementview = [self viewWithAnouncement:info];
    if(self.contentView.subviews.count > 0) {
        CATransition *transition = [CATransition animation];
        transition.duration = .5f;
        transition.type = kCATransitionPush;
        transition.removedOnCompletion = YES;
        transition.delegate = self;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.subtype = kCATransitionFromTop;
        [self.contentView.layer addAnimation:transition forKey:@"Push"];
    }
    [self.contentView addSubview:anouncementview];
    [anouncementview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    if (self.items.count > 1) {
        [self performSelector:@selector(showAnouncement) withObject:nil afterDelay:3];
    }
}

- (UIView *)viewWithAnouncement:(ETAnouncementInfo *)info {
    return [self anouncementWithTitle:info.title];
}

- (UIView *)anouncementWithTitle:(NSString *)title {
    UIView *anounceView = [[UIView alloc] init];
    anounceView.backgroundColor = [UIColor drColorC0];
    [anounceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAnouncementTapped:)]];
    
    UIView *anounceContentView = [[UIView alloc] init];
    [anounceView addSubview:anounceContentView];
    [anounceContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(anounceView);
        make.left.equalTo(anounceView);
        make.right.lessThanOrEqualTo(anounceView).offset(-5);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor drColorC5];
    label.font = [UIFont s03Font];
    label.text = title;
    [anounceContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(anounceContentView);
        make.centerY.equalTo(anounceContentView);
        make.right.equalTo(anounceContentView);
    }];
    return anounceView;
}

- (void)onAnouncementTapped:(UITapGestureRecognizer *)gesture {
    
    ETAnouncementInfo *item = self.items[self.index];
    if ([NSString isBlankString:item.content]) {
        return;
    }
    
    UIViewController *viewController = [[ETWebViewController alloc] initWithData:item.content title:NSLocalizedString(@"公告详情",nil)];
    [self.viewController.navigationController pushViewController:viewController animated:YES];
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    while (self.contentView.subviews.count > 1) {
        [[self.contentView.subviews firstObject] removeFromSuperview];
    }
}

@end
