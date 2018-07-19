//
//  ETHighlightedStyleControl.m
//  ETicket
//
//  Created by chunjian wang on 2018/5/2.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHighlightedStyleControl.h"

@implementation ETHighlightedStyleControl

- (instancetype)init {
    if (self = [super init]) {
        [self addTarget:self action:@selector(onTapBegin:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(onTapCanceled:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragExit | UIControlEventEditingDidEnd | UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onTapBegin:(UIControl *)control {
    self.backgroundColor = [UIColor clearColor];
}

- (void)onTapCanceled:(UIControl *)control {
    self.backgroundColor = [UIColor clearColor];
}

@end
