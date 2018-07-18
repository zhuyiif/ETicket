//
//  ETBannerScrollView.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETBannerScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ETWebViewController.h"

@implementation ETBannerScrollView {
    UIView *_contentView;
    NSMutableArray *_pages;
    long _currentPage;
    long _nextPage;
    NSDate *_endTime;
    NSArray *_model;
    float _scrollInterval;
    NSInteger pageIndex;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _pages = [NSMutableArray array];
    _nextPage = NSNotFound;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(self.width, 0);
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.height.equalTo(self);
    }];
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];
    self.isHorizontal = YES;
    _pageIndicator = [[ETPageIndicator alloc] init];
    [self addSubview:_pageIndicator];
    [_pageIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@13);
        make.bottom.equalTo(self).offset(-7);
    }];
    _scrollInterval = 5;
}

#pragma mark - Private
- (void)setIsHorizontal:(BOOL)isHorizontal {
    _isHorizontal = isHorizontal;
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        if (_isHorizontal) {
            make.width.equalTo(_scrollView).multipliedBy(3.0);
            make.height.equalTo(_scrollView);
        } else {
            make.width.equalTo(_scrollView);
            make.height.equalTo(_scrollView).multipliedBy(3.0);
        }
    }];
    if (_isHorizontal) {
        _scrollView.contentOffset = CGPointMake(self.width, 0);
    } else {
        _scrollView.contentOffset = CGPointMake(0, self.height);
    }
}

- (void)loadPrevious {
    @synchronized(self) {
        if (_pages.count < 2) {
            return;
        }
        _nextPage = _currentPage - 1;
        if (_nextPage < 0) {
            _nextPage = _pages.count - 1;
        }
        UIView *subview = _pages[_nextPage];
        [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_contentView).offset(0);
            make.width.equalTo(@(self.width));
            make.height.equalTo(@(self.height));
        }];
    }
}

- (void)loadNext {
    @synchronized(self) {
        if (_pages.count < 2) {
            return;
        }
        _nextPage = _currentPage + 1;
        if (_nextPage > _pages.count - 1) {
            _nextPage = 0;
        }
        UIView *subview = _pages[_nextPage];
        [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (_isHorizontal) {
                make.left.equalTo(_contentView).offset(self.width * 2);
                make.top.equalTo(_contentView);
            } else {
                make.left.equalTo(_contentView).offset(0);
                make.top.equalTo(_contentView).offset(self.height * 2);
            }
            make.width.equalTo(@(self.width));
            make.height.equalTo(@(self.height));
        }];
    }
}

- (void)putCenter {
    @synchronized(self) {
        if (_pages.count < 2 || _pages.count <= _nextPage) {
            return;
        }
        _currentPage = _nextPage;
        _nextPage = NSNotFound;
        
        UIView *subview = _pages[_currentPage];
        if (_isHorizontal) {
            [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_contentView).offset(self.width);
                make.top.equalTo(_contentView);
                make.width.equalTo(@(self.width));
                make.height.equalTo(@(self.height));
            }];
            _scrollView.contentOffset = CGPointMake(self.width, 0);
        } else {
            [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_contentView).offset(0);
                make.top.equalTo(_contentView).offset(self.height);
                make.width.equalTo(@(self.width));
                make.height.equalTo(@(self.height));
            }];
            _scrollView.contentOffset = CGPointMake(0, self.height);
        }
        [_contentView bringSubviewToFront:subview];
        
        _pageIndicator.currentPage = _currentPage;
        
        _scrollView.userInteractionEnabled = YES;
    }
}

- (void)onBannerTapped:(UITapGestureRecognizer *)gesture {
    NSInteger idx = gesture.view.tag;
    ETBannerInfo *item = _model[idx];
    if ([NSString isBlankString:item.link]) {
        return;
    }
    
    UIViewController *viewController = [[ETWebViewController alloc] initWithURL:item.link title:item.name];
    [self.viewController.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Public
- (void)didMoveToWindow {
    
}

- (void)setBanners:(NSArray<ETBannerInfo *> *)items {
    self.loadImageFailed = NO;
    _model = items;
    [self removeAllPages];
    _isLoaded = items != nil;
    if ([items count] == 0) {
        return;
    }
    
    for (int i = 0; i < [items count]; ++i) {
        UIImageView *imgView = [UIImageView new];
        @weakify(imgView);
        @weakify(self);
        [imgView sd_setImageWithURL:[NSURL URLWithString:[items[i] valueForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"bannerDefault"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(imgView);
            @strongify(self);
            if (image) {
                imgView.image = image;
            } else {
                imgView.image = [UIImage imageNamed:@"bannerDefault"];
                self.loadImageFailed = YES;
            }
        }];
        
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBannerTapped:)]];
        [self addPage:imgView];
    }
    [self performSelector:@selector(startAutoRotating) withObject:nil afterDelay:_scrollInterval];
}

- (void)addPage:(UIView *)subpage {
    [_pages addObject:subpage];
    if (_pages.count == 1) {
        [self layoutIfNeeded];
        if (_isHorizontal) {
            _scrollView.contentOffset = CGPointMake(self.width, 0);
        } else {
            _scrollView.contentOffset = CGPointMake(0, self.height);
        }
    }
    [_contentView addSubview:subpage];
    [_contentView sendSubviewToBack:subpage];
    if (_pages.count > 1) { // hide when less than 2
        _pageIndicator.numberOfPages = _pages.count;
    }
    _scrollView.scrollEnabled = _pages.count > 1;
    [subpage mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_isHorizontal) {
            make.left.equalTo(_contentView).offset(self.width);
            make.top.equalTo(_contentView);
        } else {
            make.left.equalTo(_contentView);
            make.top.equalTo(_contentView).offset(self.height);
        }
        make.width.equalTo(@(self.width));
        make.height.equalTo(@(self.height));
    }];
}

- (void)removeAllPages {
    [self stopAutoRotating];
    [_contentView removeAllSubviews];
    [_pages removeAllObjects];
    _pageIndicator.numberOfPages = 0;
    _pageIndicator.currentPage = 0;
    _currentPage = 0;
    _nextPage = NSNotFound;
}

- (void)startAutoRotating {
    if (_pages.count < 2) {
        return;
    }
    if (_scrollView.isDragging || _scrollView.isDecelerating) {
        [self performSelector:@selector(startAutoRotating) withObject:nil afterDelay:7.5];
        return;
    }
    float delay = [_endTime timeIntervalSinceNow] + _scrollInterval;
    if (_endTime && delay > 0) {
        [self performSelector:@selector(startAutoRotating) withObject:nil afterDelay:delay];
        return;
    }
    
    _scrollView.userInteractionEnabled = NO;
    
    [self loadNext];
    if (_isHorizontal) {
        [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * 2, 0, _scrollView.width, _scrollView.height) animated:YES];
    } else {
        [_scrollView scrollRectToVisible:CGRectMake(0, _scrollView.height * 2, _scrollView.width, _scrollView.height) animated:YES];
    }
    [self performSelector:@selector(putCenter) withObject:nil afterDelay:.3];
    [self performSelector:@selector(startAutoRotating) withObject:nil afterDelay:_scrollInterval];
}

- (void)stopAutoRotating {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)invalidate {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_nextPage == NSNotFound) { // not loaded yet
        if (_isHorizontal) {
            if (scrollView.contentOffset.x < scrollView.width) {
                [self loadPrevious];
            } else if (scrollView.contentOffset.x > scrollView.width) {
                [self loadNext];
            }
        } else {
            if (scrollView.contentOffset.y < scrollView.height) {
                [self loadPrevious];
            } else if (scrollView.contentOffset.y > scrollView.height) {
                [self loadNext];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = 0;
    if (_isHorizontal) {
        page = scrollView.contentOffset.x / scrollView.width;
    } else {
        page = scrollView.contentOffset.y / scrollView.height;
    }
    if (page != 1 && _nextPage != NSNotFound) {
        [self putCenter];
    } else {
        _nextPage = NSNotFound;
    }
    _endTime = [NSDate date];
}


@end
