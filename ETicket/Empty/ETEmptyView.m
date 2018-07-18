//
//  ETEmptyView.m
//  ETicket
//
//  Created by chunjian wang on 2018/5/17.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETEmptyView.h"


#define kDefaultEmptyImageName @"EmptyDefault"

@interface ETEmptyView ()

@property (nonatomic, copy) void (^clickBlock)(void);

@property (nonatomic) UIView *containerView;

@property (nonatomic) UIImageView *emptyImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;
@property (nonatomic) UIButton *actionButton;
@property (nonatomic) UILabel *footerLabel;

@end

@implementation ETEmptyView

- (instancetype)init {
    return [self initWithClickBlock:nil];
}

- (instancetype)initWithClickBlock:(void (^)(void))block {
    ETEmptyViewModel *model = [[ETEmptyViewModel alloc] initWithModel:@{ @"iconName": kDefaultEmptyImageName, @"tipText": NSLocalizedString(@"暂无记录",nil)}];
    return [self initWithModel:model clickBlock:block];
}

- (instancetype)initWithModel:(ETEmptyViewModel *)model clickBlock:(void (^)(void))block {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor drColorC0];
        if (model.iconName.length == 0) {
            model.iconName = kDefaultEmptyImageName;
        }
        if (model.tipText.length == 0) {
            model.tipText = NSLocalizedString(@"暂无记录",nil);
        }
        
        self.containerView = [UIView new];
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(@(kPaddingLeftSize));
            make.right.equalTo(@(-kPaddingLeftSize)).priorityHigh();
        }];
        
        [self buildAndAddEmptyImageView:model.iconName];
        [self buildAndAddTitleLabel:model.tipText];
        [self buildAndAddSubTitleLabel:model.subText];
        [self buildAndAddActionButton:model.buttonTitle];
        [self buildAndAddFooterLabel:model.footerTitle];
        
        UIView *lastView = nil;
        MASViewAttribute *attribute = self.containerView.mas_top;
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(attribute).offset(model.contentInsets.top);
            make.centerX.equalTo(self.containerView);
            make.width.height.equalTo(@165);
        }];
        
        lastView = self.emptyImageView;
        attribute = self.emptyImageView.mas_bottom;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(attribute).offset(10);
            make.left.right.equalTo(self.containerView);
            make.height.equalTo(@(self.titleLabel.height));
        }];
        
        lastView = self.titleLabel;
        attribute = self.titleLabel.mas_bottom;
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(attribute).offset(10);
        }];
        
        if (self.subTitleLabel) {
            attribute = self.subTitleLabel.mas_bottom;
            lastView = self.subTitleLabel;
        }
        
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(attribute).offset(25);
            make.width.equalTo(@(self.actionButton.width));
            make.height.equalTo(@(self.actionButton.height));
        }];
        
        if (self.actionButton) {
            attribute = self.actionButton.mas_bottom;
            lastView = self.actionButton;
        }
        [self.footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(attribute).offset(10);
            make.left.right.equalTo(self.titleLabel);
        }];
        
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.containerView).offset(-model.contentInsets.bottom);
        }];
        self.clickBlock = block;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGFloat height = [self.containerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        self.height = height;
    }
    return self;
}

- (void)onButtonTapped {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma Property
- (void)buildAndAddEmptyImageView:(NSString *)iconName {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:_emptyImageView];
    }
}

- (void)buildAndAddTitleLabel:(NSString *)title {
    if (title.length == 0) {
        return;
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor drColorC5];
        _titleLabel.font = [UIFont s04Font];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - kPaddingLeftSize * 2;
        [_titleLabel sizeToFit];
        [self.containerView addSubview:_titleLabel];
    }
}

- (void)buildAndAddSubTitleLabel:(NSString *)subTitle {
    if (subTitle.length == 0) {
        return;
    }
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - kPaddingLeftSize * 2;
        _subTitleLabel.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        _subTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:subTitle attributes:@{NSFontAttributeName : [UIFont s03Font],
                                                                                                         NSForegroundColorAttributeName : [UIColor drColorC3],
                                                                                                         NSParagraphStyleAttributeName : paragraphStyle}];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        _subTitleLabel.userInteractionEnabled = YES;
        [_subTitleLabel addGestureRecognizer:tapGesture];
        @weakify(self);
        [tapGesture.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            if (self.subTitleClickedBlock) {
                self.subTitleClickedBlock();
            }
        }];
        [self.containerView addSubview:_subTitleLabel];
    }
}

- (void)buildAndAddActionButton:(NSString *)actionTitle {
    if (actionTitle.length == 0) {
        return;
    }
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithStyle:ETButtonStyleBlue height:40];
        [_actionButton setTitle:actionTitle forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(onButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:_actionButton];
    }
}

- (void)buildAndAddFooterLabel:(NSString *)footerTitle {
    if (footerTitle.length == 0) {
        return;
    }
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc] init];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.text = footerTitle;
        _footerLabel.font = [UIFont s03Font];
        _footerLabel.textColor = [UIColor drColorC4];
        _footerLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [_footerLabel addGestureRecognizer:tapGesture];
        @weakify(self);
        [tapGesture.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            if (self.footerClickedBlock) {
                self.footerClickedBlock();
            }
        }];
        [self.containerView addSubview:_footerLabel];
    }
}

@end

@implementation ETEmptyView (NetworkError)

+ (instancetype)networkErrorView {
    ETEmptyViewModel *model = [ETEmptyViewModel new];
    model.iconName = @"EmptyNetworkError";
    model.tipText = NSLocalizedString(@"网络异常",nil);
    model.subText = NSLocalizedString(@"请检查网络连接后点击屏幕刷新",nil);
    ETEmptyView *emptyView = [[ETEmptyView alloc] initWithModel:model clickBlock:nil];
    emptyView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    [emptyView addGestureRecognizer:gesture];
    @weakify(emptyView);
    [gesture.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(emptyView);
        [emptyView.viewController reload];
    }];
    return emptyView;
}

@end

@implementation ETEmptyView (ServiceError)

+ (instancetype)serviceErrorView {
    ETEmptyViewModel *model = [ETEmptyViewModel new];
    model.iconName = @"EmptyServiceError";
    model.tipText = NSLocalizedString(@"服务器繁忙，请刷新重试",nil);
    model.buttonTitle = NSLocalizedString(@"刷新",nil);
    ETEmptyView *emptyView = [[ETEmptyView alloc] initWithModel:model clickBlock:nil];
    @weakify(emptyView);
    emptyView.clickBlock = ^{
        @strongify(emptyView);
        [emptyView.viewController reload];
    };
    return emptyView;
}

@end
