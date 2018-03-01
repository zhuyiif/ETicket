//
//  DSGuideViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSGuideViewController.h"

#define KGUIDE_PAGE_COUNT 3

@interface DSGuideViewController () <UIScrollViewDelegate>

@property (nonatomic, copy) void (^completeBlock)(void);
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *completeTimer;

@end

@implementation DSGuideViewController

- (instancetype)initWithCompleteBlock:(void (^)(void))completeBlock {
    if (self = [super init]) {
        self.completeBlock = completeBlock;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor drColorC0];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.userInteractionEnabled = YES;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    NSArray *colors = @[[UIColor colorWithHex:0xb0dad9],[UIColor colorWithHex:0x377e92],[UIColor colorWithHex:0x81c9c8]];
    UIImageView *preView = nil;
    for (int index = 0; index < KGUIDE_PAGE_COUNT; index++) {
        NSString *path = [NSString stringWithFormat:@"guide%i.jpg", index + 1];
        UIImageView *imageView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:path]];
        imageView.backgroundColor = colors[index];
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preView == nil ? contentView.mas_left
                              : preView.mas_right);
            make.width.equalTo(self.view);
            make.top.equalTo(contentView);
            make.bottom.equalTo(contentView);
        }];
        preView = imageView;
    }
    
    if (preView) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(preView.mas_right);
        }];
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = KGUIDE_PAGE_COUNT;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.bottom.equalTo(self.view).offset(-20);
    }];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    // Do any additional setup after loading the view.
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = self.scrollView.contentOffset;
    
    if (point.x <= 1) {
        // scrollView.contentOffset = CGPointZero;//CGPointMake(0, 0);
        [self.scrollView setContentOffset:CGPointZero animated:NO];
        return;
    }
    
    int itemWidth = self.scrollView.bounds.size.width;
    int page = (self.scrollView.contentOffset.x + itemWidth / 2.0) / itemWidth;
    
    self.pageControl.currentPage = page;
    //    CGFloat pageWidth = scrollView.frame.size.width;
    if (page == KGUIDE_PAGE_COUNT - 1) {
        
        if ([self.completeTimer isValid]) {
            return;
        }
        self.completeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self
                                                            selector:@selector(onDismissTapped)
                                                            userInfo:nil repeats:NO];
    }
}

- (void)onDismissTapped {
    if (_completeBlock) {
        _completeBlock();
    }
}

@end
