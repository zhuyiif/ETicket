//
//  ETRouteTVCell.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/20.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETRouteTVCell.h"

@implementation ETRouteTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor drColorC0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor white];
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = 3.0f;
    containerView.layer.borderColor = [UIColor clearColor].CGColor;
    containerView.layer.borderWidth = 1.0f;
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-8);
        make.top.equalTo(self);
    }];
    
    self.stationLabel = [UILabel new];
    self.stationLabel.backgroundColor = [UIColor clearColor];
    self.stationLabel.font = [UIFont fontWithSize:14 name:nil];
    self.stationLabel.textColor = [UIColor greyishBrown];
    self.stationLabel.text = @"四和-天府广场";
    [containerView addSubview:self.stationLabel];
    [self.stationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(12);
        make.top.equalTo(containerView).offset(8);
    }];
    
    self.lineLabel = [UILabel new];
    self.lineLabel.backgroundColor = [UIColor clearColor];
    self.lineLabel.font = [UIFont s02Font];
    self.lineLabel.textColor = [UIColor warmGrey];
    self.lineLabel.text = @"一号线";
    [containerView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stationLabel.mas_bottom).offset(2);
        make.left.equalTo(self.stationLabel);
    }];
    
    
    self.timeLabel = [UILabel new];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font =  [UIFont s02Font];
    self.timeLabel.textColor = [UIColor warmGrey];
    self.timeLabel.text =  @"出行时间：2018-7-18 18:30";
    [containerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLabel.mas_bottom).offset(2);
        make.left.equalTo(self.lineLabel);
        make.bottom.equalTo(containerView).offset(-8);
    }];
    
    self.statusLabel = [UILabel new];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.font = [UIFont s02Font];
    self.statusLabel.textColor = [UIColor appleGreen];
    self.statusLabel.text = @"未付款";
    [containerView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-12);
        make.top.equalTo(containerView).offset(11);
    }];
}

@end
