//
//  DSThemeHelper.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSThemeHelper.h"

@interface DSThemeHelper()

@property (nonatomic) NSDictionary *colorValues;


@end

static DSThemeHelper *instance = nil;

@implementation DSThemeHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DSThemeHelper alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Color" ofType:@"plist"];
        self.colorValues = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return self;
}

- (NSString *)colorValueWithName:(NSString *)colorName {
    return [[self currentColorValues] objectForKey:colorName] ?: @"0XFFFFFF";
}

- (NSDictionary *)currentColorValues {
    return self.colorValues[@"DefaultTheme"];
}

@end
