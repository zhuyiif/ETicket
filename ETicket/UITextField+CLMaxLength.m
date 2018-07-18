//
//  UITextField+CLMaxLength.m
//  CLKitDemo
//
//  Created by 普拉斯 on 2017/10/18.
//  Copyright © 2017年 chao. All rights reserved.
//

#import "UITextField+CLMaxLength.h"
#import <objc/runtime.h>
#import "UITextField+CLShaker.h"
#import "SwizzleMethod.h"

static char maxLengthKey;
static char addObserverKey;

@implementation UITextField (CLMaxLength)

+ (void)load {
    [SwizzleMethod swizzleMethod:self.class originalSelector:NSSelectorFromString(@"dealloc") swizzledSelector:@selector(zwlimitCounter_swizzled_dealloc)];
}

#pragma mark - swizzled
- (void)zwlimitCounter_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self zwlimitCounter_swizzled_dealloc];
}

- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, &maxLengthKey) unsignedIntegerValue];
    
}

- (void)setMaxLength:(NSUInteger)maxLength {
    [self addObserve];
    objc_setAssociatedObject(self, &maxLengthKey, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addObserve {
    NSNumber *observer = objc_getAssociatedObject(self, &addObserverKey);
    if (!observer) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:)
                                                    name:UITextFieldTextDidChangeNotification object:self];
        objc_setAssociatedObject(self, &addObserverKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - update
- (void)textFieldEditChanged:(NSNotification *)notification {
    if (self.maxLength > 0 && self.text.length > self.maxLength) {
        UITextRange *markedRange = [self markedTextRange];
        if (markedRange) {
            return;
        }
        NSRange range = [self.text rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        self.text = [self.text substringToIndex:range.location];
        [self shake];
    }
}

@end
