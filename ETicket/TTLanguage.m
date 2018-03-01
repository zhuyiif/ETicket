//
//  TTLanguage.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "TTLanguage.h"

static NSBundle *gPreferredLanguageBundle;

void TTSetPreferredLanguage(NSString *language) {
    // an empty resource or nil will return the first file encountered that matches the extension
    if ([language length]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
        gPreferredLanguageBundle = [[NSBundle alloc] initWithPath:path];
    } else {
        gPreferredLanguageBundle = nil;
    }
}

NSString *TTLocalizedString(NSString *key) {
    NSBundle *bundle = gPreferredLanguageBundle ?: [NSBundle mainBundle];
    return [bundle localizedStringForKey:key value:nil table:nil];
}
