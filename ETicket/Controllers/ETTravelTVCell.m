//
//  ETTravelTVCell.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/31.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETTravelTVCell.h"

@implementation ETTravelTVCell

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
        self.backgroundColor = [UIColor white2];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line = [UIView new];
        line.backgroundColor = [[UIColor greyish] colorWithAlphaComponent:0.1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@1);
            make.left.equalTo(self).offset(15);
        }];
        
        UIImageView *bgView = [UIImageView new];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.image = [UIImage imageNamed:@"travelCellBg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-10);
            make.left.equalTo(line.mas_right).offset(12);
            make.right.equalTo(self).offset(-15);
        }];
        
        UIImageView *stationIcon = [UIImageView new];
        stationIcon.image = [UIImage imageNamed:@"travelStationIcon"];
        [bgView addSubview:stationIcon];
        [stationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(13);
            make.top.equalTo(bgView).offset(12);
            make.width.equalTo(@18);
            make.height.equalTo(@20);
        }];
        
        self.stationLabel = [UILabel new];
        self.stationLabel.backgroundColor = [UIColor clearColor];
        self.stationLabel.font = [UIFont fontWithSize:14];
        self.stationLabel.textColor = [UIColor greyishBrown];
        self.stationLabel.text = @"小寒 - 大明宫";
        [bgView addSubview:self.stationLabel];
        [self.stationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(stationIcon);
            make.left.equalTo(stationIcon.mas_right).offset(8);
        }];
        
        self.statusLabel = [UILabel new];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.text = @"已支付";
        self.statusLabel.textColor = [UIColor appleGreen];
        self.statusLabel.font = [UIFont s02Font];
        [bgView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-12);
            make.left.equalTo(self.stationLabel.mas_right).offset(10);
            make.centerY.equalTo(self.stationLabel);
        }];
        
        [self.statusLabel setContentCompressionResistancePriority:900 forAxis:UILayoutConstraintAxisHorizontal];
        [self.statusLabel setContentHuggingPriority:900 forAxis:UILayoutConstraintAxisHorizontal];
        [self.stationLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
        [self.stationLabel setContentHuggingPriority:800 forAxis:UILayoutConstraintAxisHorizontal];
        UIView *cutLine = [UIView new];
        cutLine.backgroundColor = [[UIColor warmGreyTwo] colorWithAlphaComponent:0.1];
        [bgView addSubview:cutLine];
        [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.equalTo(stationIcon);
            make.right.equalTo(self.statusLabel);
            make.top.equalTo(stationIcon.mas_bottom).offset(12);
        }];
        
        UIImageView *timeIcon = [UIImageView new];
        timeIcon.backgroundColor = [UIColor clearColor];
        timeIcon.image = [UIImage imageNamed:@"travelTimeIcon"];
        [bgView addSubview:timeIcon];
        [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(stationIcon);
            make.top.equalTo(cutLine.mas_bottom).offset(13);
            make.bottom.equalTo(bgView).offset(-16);
            make.width.equalTo(@18);
            make.height.equalTo(@18);
        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor greyishBrown];
        self.timeLabel.font = [UIFont s02Font];
        self.timeLabel.attributedText = [self timeAttributedWithStart:@"08:40" end:@"09:32"];
        [bgView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stationLabel);
            make.centerY.equalTo(timeIcon);
            make.right.equalTo(self.statusLabel);
        }];
    }
    return self;
}

- (NSAttributedString *)timeAttributedWithStart:(NSString *)start end:(NSString *)end {
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:start attributes:@{NSFontAttributeName:[UIFont fontWithSize:14],NSForegroundColorAttributeName:[UIColor greyishBrown]}];
    NSAttributedString *startStation = [[NSAttributedString alloc] initWithString:@" 进站" attributes:@{NSFontAttributeName:[UIFont s02Font],NSForegroundColorAttributeName:[UIColor warmGrey]}];
    [resultString appendAttributedString:startStation];
    
    NSAttributedString *sepLine = [[NSAttributedString alloc] initWithString:@" - " attributes:@{NSFontAttributeName:[UIFont fontWithSize:14],NSForegroundColorAttributeName:[UIColor greyishBrown]}];
    [resultString appendAttributedString:sepLine];
    
    
    NSAttributedString *endTime = [[NSAttributedString alloc] initWithString:end attributes:@{NSFontAttributeName:[UIFont fontWithSize:14],NSForegroundColorAttributeName:[UIColor greyishBrown]}];
    [resultString appendAttributedString:endTime];
    NSAttributedString *endStation = [[NSAttributedString alloc] initWithString:@" 出站" attributes:@{NSFontAttributeName:[UIFont s02Font],NSForegroundColorAttributeName:[UIColor warmGrey]}];
    [resultString appendAttributedString:endStation];
    return resultString;
    
}

@end
