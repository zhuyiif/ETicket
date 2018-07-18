//
//  ETPageIndicator.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETPageIndicator.h"

@implementation ETPageIndicator

- (instancetype)init {
    if (self = [super init]) {
        self.highlightedColor = [UIColor colorWithWhite:1.0f alpha:.9f];
        self.normalColor = [UIColor colorWithWhite:1.0f alpha:.5f];
    }
    return self;
}

#pragma mark - Private
- (void)reloadData {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *lastDot = nil;
    for (int i = 0; i < _numberOfPages; ++i) {
        UIView *dot = [[UIView alloc] init];
        [self addSubview:dot];
        [dot mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            if (lastDot) {
                make.left.equalTo(lastDot.mas_right).offset(7.5);
            } else {
                make.left.equalTo(self);
            }
            make.height.equalTo(@6);
            make.width.equalTo(i == self.currentPage ? @(12) : @6);
        }];
        lastDot = dot;
        if (i == _currentPage) {
            dot.backgroundColor = self.highlightedColor;
        } else {
            dot.backgroundColor = self.normalColor;
        }
        dot.layer.cornerRadius = 3;
    }
    
    if (lastDot) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastDot);
        }];
    }
}

#pragma mark - Public
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self reloadData];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (CGAffineTransformIsIdentity(scrollView.transform)) {
        int page = scrollView.contentOffset.x / scrollView.width;
        self.currentPage = page % _numberOfPages;
    } else { // rotated
        int page = scrollView.contentOffset.y / scrollView.width;
        self.currentPage = _numberOfPages - 1 - page % _numberOfPages;
    }
}

@end
