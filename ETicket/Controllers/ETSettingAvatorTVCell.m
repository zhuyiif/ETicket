//
//  ETSettingAvatorTVCell.m
//  ETicket
//
//  Created by chunjian wang on 2018/8/21.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETSettingAvatorTVCell.h"

@implementation ETSettingAvatorTVCell

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
        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont s04Font];
        self.titleLabel.textColor = [UIColor greyishBrown];
        self.titleLabel.text = @"头像";
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        self.avatorView = [UIImageView new];
        self.avatorView.backgroundColor = [UIColor clearColor];
        self.avatorView.clipsToBounds = YES;
        self.avatorView.layer.borderWidth = 1.0f;
        self.avatorView.layer.borderColor = [UIColor clearColor].CGColor;
        self.avatorView.layer.cornerRadius = 30;
        self.avatorView.image = [UIImage imageNamed:@"homeMidImage"];
        self.avatorView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.avatorView];
        [self.avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.width.height.equalTo(@60);
            make.right.equalTo(self).offset(-34);
        }];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowNextGrey"]];
    }
    return self;
}

@end
