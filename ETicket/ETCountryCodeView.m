//
//  ETCountryCodeView.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/15.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "ETCountryCodeView.h"
#import "ETCountryHelper.h"

@interface ETCountryCodeView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picekerView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) ETCountryCode *currentCountry;
@property (nonatomic, copy) void (^completeBlock)(NSString *code);

@end

@implementation ETCountryCodeView

+ (void)showWithCode:(NSString *)countryCode completeBlock:(void (^)(NSString *code ))completeBlock {
    UIView *parentView = [UIApplication topView];
    for (UIView *view in parentView.subviews) {
        if ([view isKindOfClass:[ETCountryCodeView class]]) {
            return;
        }
    }
    ETCountryCodeView *countryCodeView = [[ETCountryCodeView alloc] initWithCountryCode:countryCode completeBlock:completeBlock];
    [parentView addSubview:countryCodeView];
    [countryCodeView show];
}

- (id)initWithCountryCode:(NSString *)code completeBlock:(void (^)(NSString *code))completeBlock {
    if (self = [super initWithFrame:[UIApplication topView].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        self.completeBlock = completeBlock;
        [self setupView];
        NSInteger index = 0;
        for (ETCountryCode *country in [ETCountryHelper sharedInstance].countryCodes) {
            if ([country.code isEqualToString:code]) {
                index = [[ETCountryHelper sharedInstance].countryCodes indexOfObject:country];
                self.currentCountry = country;
                break;
            }
        }
        
        if (index >= 0) {
            [self.picekerView selectRow:index inComponent:0 animated:YES];
        }
    }
    return self;
}

- (void)setupView {
    _mainView = [UIView new];
    _mainView.backgroundColor = [UIColor clearColor];
    [self addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor drColorC1];
    [_mainView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@216);
    }];
    UIButton *cancel = [UIButton new];
    [cancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont s05Font];
    [cancel setTitleColor:[UIColor drColorC8] forState:UIControlStateNormal];
    [contentView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(contentView).offset(7);
        make.height.equalTo(@40);
    }];
    @weakify(self);
    [[cancel rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismiss];
     }];
    
    UIButton *confirm = [UIButton new];
    [confirm setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont s05Font];
    [confirm setTitleColor:[UIColor drColorC17] forState:UIControlStateNormal];
    [contentView addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-15);
        make.top.equalTo(contentView).offset(7);
        make.height.equalTo(cancel);
    }];
    
    [[confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.completeBlock) {
            self.completeBlock(self.currentCountry.code);
        }
        [self dismiss];
    }];
    
    UIView *cutLine = [UIView new];
    cutLine.backgroundColor = [UIColor drColorC2];
    [contentView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirm.mas_bottom).offset(7);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@1);
    }];
    
    _picekerView = [UIPickerView new];
    _picekerView.backgroundColor = [UIColor clearColor];
    _picekerView.dataSource = self;
    _picekerView.delegate = self;
    [contentView addSubview:_picekerView];
    [_picekerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cutLine.mas_bottom);
        make.left.right.bottom.equalTo(contentView);
    }];
    [_picekerView reloadAllComponents];
}

- (void)show {
    _mainView.alpha = 0;
    _mainView.transform = CGAffineTransformMakeTranslation(0, [UIApplication topView].height);
    [UIView animateWithDuration:.3 animations:^{
        _mainView.alpha = 1;
        _mainView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        _mainView.transform = CGAffineTransformMakeTranslation(0, [UIApplication topView].height);
        _mainView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ETCountryCode *country = [ETCountryHelper sharedInstance].countryCodes[row];
    return [NSString stringWithFormat:@"+%@ %@",country.code,country.zh];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row < [ETCountryHelper sharedInstance].countryCodes.count) {
        self.currentCountry = [ETCountryHelper sharedInstance].countryCodes[row];
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [ETCountryHelper sharedInstance].countryCodes.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

@end

