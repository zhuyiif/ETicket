//
//  UIViewController+ErrorView.m
//  Brainspie
//
//  Created by chunjian wang on 16/6/8.
//  Copyright © 2016年 chunjian wang. All rights reserved.
//

#import "UIViewController+ErrorView.h"

@implementation UIViewController (ErrorView)

- (void)showAssistWithStatus:(NSString *)errorMessage {
  
}

- (void)hideAssist {
 
}

// private
- (UIScrollView *)_scrollView {
    if ([self respondsToSelector:@selector(tableView)]) {
        return [(id)self tableView];
    }
    if ([self respondsToSelector:@selector(collectionView)]) {
        return [(id)self collectionView];
    }
    if ([self respondsToSelector:@selector(scrollView)]) {
        return [(id)self scrollView];
    }
    
    return nil;
}

@end
