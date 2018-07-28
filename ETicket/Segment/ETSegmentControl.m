//
//  ETSegmentControl.m
//  ETicket
//
//  Created by chunjian wang on 2017/3/1.
//  Copyright © 2017年 Bkex Technology Co.Ltd. All rights reserved.
//

#import "ETSegmentControl.h"
#import "UIView+SepLine.h"

@interface ETSegmentControl () <UIScrollViewDelegate>

@property (nonatomic, assign) CGRect lastSelectRect;
@property (nonatomic, assign) CGFloat beginOffsetX;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)segmentItemClicked:(ETSegmentItem *)item;

@end

@implementation ETSegmentControl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews {
    CGSize size = self.frame.size;
    self.scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    ETSegmentItem *item = [self.items lastObject];
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), CGRectGetHeight(self.scrollView.frame));
}

#pragma mark - Initialize Method
- (void)initialize {
    _selectIndex = 0;
    self.highlightColor = Default_Highlight_Color;
    self.titleColor = Default_Color;
    self.titleFont = Default_Title_Font;
    self.lineHeight = Default_Line_Height;
    self.backgroundColor = [UIColor drColorC0];

    self.items = [[NSMutableArray alloc] init];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.scrollEnabled = self.segmentScrollEnable;
    [self addSubview:self.scrollView];

    //底部高亮线
    self.lineLayer = [[CALayer alloc] init];
    self.lineLayer.borderColor = self.bottomLineColor ? self.bottomLineColor.CGColor : [UIColor drColorC5].CGColor;
    [self.scrollView.layer addSublayer:self.lineLayer];
    self.sepLineStyle = UIViewAddSepLineStyleBottom;
}

- (void)createItems {
    if (!self.titles || self.titles.count == 0) {
        return;
    }
    CGFloat segmentWidth = CGRectGetWidth(self.frame);
    CGFloat totalItemWidth = .0f;
    for (int i = 0; i < self.titles.count; i++) {
        CGFloat itemWidth = [ETSegmentItem caculateWidthWithtitle:self.titles[i] titleFont:self.titleFont];
        totalItemWidth += itemWidth;
    }
    
    if (totalItemWidth > segmentWidth) {
        self.segmentScrollEnable = YES;
    }

    NSMutableArray *arrayItem = [[NSMutableArray alloc] initWithCapacity:self.titles.count];
    CGFloat itemHeight = CGRectGetHeight(self.frame);
    CGRect itemRect = CGRectZero;
    for (int i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        CGFloat itemWidth = totalItemWidth < segmentWidth ? (segmentWidth / self.titles.count ): [ETSegmentItem caculateWidthWithtitle:title titleFont:self.titleFont];
        ETSegmentItem *lastItem = [arrayItem lastObject];
        if (!lastItem && (totalItemWidth < segmentWidth)) {
            itemRect = CGRectMake(0, .0f, itemWidth, itemHeight);
        } else {
            itemRect = CGRectMake(CGRectGetMaxX(lastItem.frame), .0f, itemWidth, itemHeight);
        }
        
        ETSegmentItem *item = [self createItem:itemRect title:title];
        [arrayItem addObject:item];
    }

    self.items = [arrayItem mutableCopy];
}

- (ETSegmentItem *)createItem:(CGRect)rect title:(NSString *)title {
    ETSegmentItem *item = [[ETSegmentItem alloc] initWithFrame:rect];
    item.title = title;
    item.titleColor = self.titleColor;
    item.titleFont = self.titleFont;
    item.highlightColor = self.highlightColor;
    [item addTarget:self action:@selector(segmentItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:item];
    return item;
}

#pragma mark - Public Method
- (void)refresh {
    for (ETSegmentItem *item in self.items) {
        item.titleColor = Default_Color;
        item.highlightColor = self.highlightColor;
        [item refresh];
    }
}

- (void)load {
    if (self.backgroundImage) {
        self.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    }

    self.lineLayer.backgroundColor = self.bottomLineColor ? self.bottomLineColor.CGColor : [UIColor drColorC5].CGColor;
    self.lineLayer.frame = CGRectMake(CGRectGetMinX(self.lineLayer.frame), CGRectGetHeight(self.frame) - self.lineHeight, CGRectGetWidth(self.lineLayer.frame), self.lineHeight);

    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self createItems];
    if(_selectIndex > self.items.count - 1) {
        _selectIndex = self.items.count - 1;
    }
    self.selectIndex = _selectIndex;
    [self layoutSubviews];
}

- (void)scrollToRate:(CGFloat)rate {
    if (!self.items || self.items.count == 0) {
        return;
    }
    ETSegmentItem *currentItem = self.items[self.selectIndex];
    ETSegmentItem *previousItem = self.selectIndex > 0 ? self.items[self.selectIndex - 1] : nil;
    ETSegmentItem *nextItem = (self.selectIndex < self.items.count - 1) ? self.items[self.selectIndex + 1] : nil;
    if (fabs(rate) > 0.2) {
        if (rate > 0) {
            if (nextItem) {
                [self segmentItemSelected:nextItem];
            }
        } else if (rate < 0) {
            if (previousItem) {
                [self segmentItemSelected:previousItem];
            }
        }
    } else {
        if (currentItem) {
            [self segmentItemSelected:currentItem];
        }
    }

    CGFloat dx = 0.;
    CGFloat dw = 0.;
    if (rate > 0) {
        if (nextItem) {
            dx = CGRectGetMinX(nextItem.frame) - CGRectGetMinX(currentItem.frame);
            dw = CGRectGetWidth(nextItem.frame) - CGRectGetWidth(currentItem.frame);
        } else {
            dx = CGRectGetWidth(currentItem.frame);
        }
    } else if (rate < 0) {
        if (previousItem) {
            dx = CGRectGetMinX(currentItem.frame) - CGRectGetMinX(previousItem.frame);
            dw = CGRectGetWidth(currentItem.frame) - CGRectGetWidth(previousItem.frame);
        } else {
            dx = CGRectGetWidth(currentItem.frame);
        }
    }

    CGFloat x = CGRectGetMinX(self.lastSelectRect) + rate * dx;
    CGFloat w = CGRectGetWidth(self.lastSelectRect) + rate * dw;

    self.lineLayer.frame = CGRectMake(x, CGRectGetMinY(self.lastSelectRect), w, CGRectGetHeight(self.lastSelectRect));
}

#pragma mark - Private Method
- (void)segmentItemClicked:(ETSegmentItem *)item {
    [self setSelectIndex:[self.items indexOfObject:item] animation:NO];
}

- (void)segmentItemSelected:(ETSegmentItem *)item {
    for (ETSegmentItem *i in self.items) {
        i.selected = NO;
        [item refresh];
    }
    item.selected = YES;
}

#pragma mark - Setters
- (void)setSelectIndex:(NSInteger)selectIndex animation:(BOOL)animation {
    _selectIndex = selectIndex;
    if (selectIndex < self.items.count) {
        ETSegmentItem *item = self.items[selectIndex];
        [self segmentItemSelected:item];
        self.lineLayer.frame = CGRectMake(CGRectGetMinX(item.frame), CGRectGetHeight(item.frame) - self.lineHeight, CGRectGetWidth(item.frame), self.lineHeight);
        self.lastSelectRect = self.lineLayer.frame;
        [self.scrollView scrollRectToVisible:item.frame animated:YES];
        if ([self.delegate respondsToSelector:@selector(segmentSelectAtIndex:animation:)]) {
            [self.delegate segmentSelectAtIndex:selectIndex animation:animation];
        }
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self setSelectIndex:selectIndex animation:YES];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
}

- (void)setSegmentScrollEnable:(BOOL)segmentScrollEnable {
    _segmentScrollEnable = segmentScrollEnable;
    self.scrollView.scrollEnabled = segmentScrollEnable;
}

- (void)setIsInNaviBar:(BOOL)isInNaviBar {
    _isInNaviBar = isInNaviBar;
    [self layoutSubviews];
    if ([self.delegate respondsToSelector:@selector(updateSegmentBarPosition)]) {
        [self.delegate updateSegmentBarPosition];
    }
}

@end
