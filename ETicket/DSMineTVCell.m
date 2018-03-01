//
//  DSMineTVCell.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/14.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSMineTVCell.h"

@interface DSMineTVCell ()

@property (nonatomic) UIView *separatorLine;

@end

@implementation DSMineTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowNextGrey"]];
    [self.contentView addSubview:accessoryView];
    [accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    
    self.titleLabel.textColor = [UIColor drColorC4];
    self.titleLabel.font = [UIFont fontWithSize:14];
    self.detailLabel.textColor = [UIColor drColorC5];
    self.detailLabel.font = [UIFont fontWithSize:12];
    
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@18);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.unReadDot];
    [self.unReadDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.width.height.equalTo(@5);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(accessoryView.mas_left).offset(1);
        make.centerY.equalTo(self.contentView);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(2);
    }];
    
    [self.contentView addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.height.equalTo(@0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Setters/Getters

- (UIView *)unReadDot {
    if(!_unReadDot) {
        _unReadDot = [[UIView alloc] init];
        _unReadDot.backgroundColor = [UIColor drColorC6];
        _unReadDot.hidden = YES;
        _unReadDot.layer.cornerRadius = 2.5;
    }
    return _unReadDot;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.minimumScaleFactor = 0.8;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor drColorC2];
    }
    return _separatorLine;
}

- (void)setIsHiddenSeparatorLine:(BOOL)isHiddenSeparatorLine {
    _isHiddenSeparatorLine = isHiddenSeparatorLine;
    self.separatorLine.hidden = _isHiddenSeparatorLine;
}

@end
