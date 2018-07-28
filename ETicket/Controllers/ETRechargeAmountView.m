//
//  ETRechargeAmountView.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/28.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETRechargeAmountView.h"
#import "UITextField+CLMaxLength.h"

@interface ETRechargeAmountView ()

@property (nonatomic) UIImageView *topImageView;
@property (nonatomic) UILabel *balanceLabel;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIView *inputViewContainer;
@property (nonatomic) UIView *quickAmountsView;
@property (nonatomic) NSMutableArray *buttons;

@end

@implementation ETRechargeAmountView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.buttons = [NSMutableArray new];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.topImageView = [UIImageView new];
    self.topImageView.backgroundColor = [UIColor clearColor];
    self.topImageView.clipsToBounds = YES;
    self.topImageView.image = [UIImage imageNamed:@"rechargeHeaderBG"];
    [self addSubview:self.topImageView];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(statusBarHeight + 44 + 147));
    }];
    
    UILabel *balanceTip = [UILabel new];
    balanceTip.backgroundColor = [UIColor clearColor];
    balanceTip.font = [UIFont fontWithSize:14 name:nil];
    balanceTip.textColor = [UIColor white2];
    balanceTip.text = @"余额(元)";
    [self addSubview:balanceTip];
    [balanceTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12 + 44 + statusBarHeight);
        make.left.equalTo(self).offset(16);
    }];
    
    self.balanceLabel = [UILabel new];
    self.balanceLabel.backgroundColor = [UIColor clearColor];
    self.balanceLabel.font = [UIFont fontWithSize:38];
    self.balanceLabel.textColor = [UIColor white2];
    self.balanceLabel.text = @"0.00";
    [self addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceTip);
        make.top.equalTo(balanceTip.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-16);
    }];
    
    [self addSubview:self.inputViewContainer];
    [self.inputViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topImageView.mas_bottom);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
    }];
    
    [self addSubview:self.quickAmountsView];
    [self.quickAmountsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputViewContainer);
        make.top.equalTo(self.inputViewContainer.mas_bottom).offset(15);
        make.bottom.equalTo(self).offset(-20);
    }];
}

- (UIView *)inputViewContainer {
    if (!_inputViewContainer) {
        _inputViewContainer = [UIView new];
        _inputViewContainer.backgroundColor = [UIColor clearColor];
        UIImageView *bgView = [UIImageView new];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.image = [UIImage imageNamed:@"rechargeTextBG"];
        [_inputViewContainer addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_inputViewContainer);
        }];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont fontWithSize:14 name:nil];
        tipLabel.textColor = [UIColor greyishBrown];
        tipLabel.text = @"余额:";
        [_inputViewContainer addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_inputViewContainer).offset(15);
            make.top.equalTo(_inputViewContainer).offset(20);
            make.bottom.equalTo(_inputViewContainer).offset(-18);
        }];
        
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [UIColor warmGreyTwo];
        [_inputViewContainer addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.left.equalTo(tipLabel.mas_right).offset(8);
            make.top.equalTo(_inputViewContainer).offset(12);
            make.bottom.equalTo(_inputViewContainer).offset(-10);
        }];
        
        self.textField = [UITextField new];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.textColor = [UIColor greyishBrown];
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
        self.textField.maxLength = 10;
        self.textField.font = [UIFont fontWithSize:16];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.tintColor = [UIColor warmGreyTwo];
        NSAttributedString *attrPlaceHolder = [[NSAttributedString alloc] initWithString:@"请输入您要充值的金额" attributes:@{NSFontAttributeName: [UIFont fontWithSize:16], NSForegroundColorAttributeName: [UIColor warmGrey]}];
        self.textField.attributedPlaceholder = attrPlaceHolder;
        [_inputViewContainer addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cutLine.mas_right).offset(8);
            make.right.equalTo(_inputViewContainer).offset(-12);
            make.centerY.equalTo(_inputViewContainer);
        }];
        
        [tipLabel setContentCompressionResistancePriority:900 forAxis:UILayoutConstraintAxisHorizontal];
        [self.textField setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
        [tipLabel setContentHuggingPriority:900 forAxis:UILayoutConstraintAxisHorizontal];
        [self.textField setContentHuggingPriority:800 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _inputViewContainer;
}

- (UIView *)quickAmountsView {
    if (!_quickAmountsView) {
        _quickAmountsView = [UIView new];
        _quickAmountsView.backgroundColor = [UIColor clearColor];
        UIImageView *bgView = [UIImageView new];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.image = [UIImage imageNamed:@"rechargeTextBG"];
        [_quickAmountsView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_quickAmountsView);
        }];
        UIStackView *vStackView = [UIStackView new];
        vStackView.backgroundColor = [UIColor clearColor];
        vStackView.axis = UILayoutConstraintAxisVertical;
        vStackView.alignment = UIStackViewAlignmentFill;
        vStackView.distribution = UIStackViewDistributionFill;
        vStackView.spacing = 12;
        [_quickAmountsView addSubview:vStackView];
        [vStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_quickAmountsView).offset(15);
            make.right.equalTo(_quickAmountsView).offset(-15);
            make.top.equalTo(_quickAmountsView).offset(15);
            make.bottom.equalTo(_quickAmountsView).offset(-15);
        }];
        [vStackView addArrangedSubview:[self lineWithTexts:@[@"100元",@"50元",@"30元"]]];
        [vStackView addArrangedSubview:[self lineWithTexts:@[@"20元",@"10元",@"5元"]]];

    }
    return _quickAmountsView;
}

- (UIStackView *)lineWithTexts:(NSArray *)texts {
    UIStackView *vStackView = [UIStackView new];
    vStackView.backgroundColor = [UIColor clearColor];
    vStackView.axis = UILayoutConstraintAxisHorizontal;
    vStackView.alignment = UIStackViewAlignmentFill;
    vStackView.distribution = UIStackViewDistributionFillEqually;
    vStackView.spacing = 12;
    for (NSString *text in texts) {
        UIButton *button = [UIButton buttonWithStyle:ETButtonStyleRed height:20];
        [button addTarget:self action:@selector(amountButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont fontWithSize:14 name:nil];
        [button setTitle:text forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@35);
        }];
        [self.buttons addObject:button];
        [vStackView addArrangedSubview:button];
    }
    return vStackView;
}

- (void)amountButtonPressed:(UIButton *)button {
    
}

@end
