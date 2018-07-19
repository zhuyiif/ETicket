//
//  ETHomeNewsTVCell.m
//  ETicket
//
//  Created by chunjian wang on 2018/7/19.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#import "ETHomeNewsTVCell.h"

@implementation ETHomeNewsTVCell

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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.coverView = [UIImageView new];
    self.coverView.backgroundColor = [UIColor clearColor];
    self.coverView.clipsToBounds = YES;
    self.coverView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverView.layer.cornerRadius = 2;
    self.coverView.layer.borderColor = [UIColor clearColor].CGColor;
    self.coverView.layer.borderWidth = 1;
    self.coverView.image = [UIImage imageNamed:@"homeMidImage"];
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-16);
        make.width.height.equalTo(@88);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithSize:16];
    self.titleLabel.textColor = [UIColor black];
    self.titleLabel.text = @"大唐世家都是分建安费都是返回杀佛啊速递费";
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView.mas_right).offset(8);
        make.top.equalTo(self.coverView);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.authorIcon = [UIImageView new];
    self.authorIcon.backgroundColor = [UIColor clearColor];
    self.authorIcon.clipsToBounds = YES;
    self.authorIcon.layer.borderWidth = 1;
    self.authorIcon.layer.borderWidth = 7;
    self.authorIcon.layer.borderColor = [UIColor clearColor].CGColor;
    self.authorIcon.image = [UIImage imageNamed:@"authorIcon"];
    [self addSubview:self.authorIcon];
   
    
    self.authorLabel = [UILabel new];
    self.authorLabel.backgroundColor = [UIColor clearColor];
    self.authorLabel.font = [UIFont fontWithSize:14 name:nil];
    self.authorLabel.textColor = [UIColor warmGrey];
    self.authorLabel.text = @"熊小虎";
    [self addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverView);
        make.left.equalTo(self.authorIcon.mas_right).offset(4);
    }];
    
    [self.authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.centerY.equalTo(self.authorLabel);
        make.width.height.equalTo(@14);
    }];
    
    self.seeCountIcon = [UIImageView  new];
    self.seeCountIcon.backgroundColor = [UIColor clearColor];
    self.seeCountIcon.image = [UIImage imageNamed:@"readCountIcon"];
    [self addSubview:self.seeCountIcon];
   
    
    self.seeCountLabel = [UILabel new];
    self.seeCountLabel.text = @"121313";
    self.seeCountLabel.backgroundColor = [UIColor clearColor];
    self.seeCountLabel.font = [UIFont fontWithSize:14 name:nil];
    self.seeCountLabel.textColor = [UIColor warmGrey];
    [self addSubview:self.seeCountLabel];
    [self.seeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverView);
        make.left.equalTo(self.seeCountIcon.mas_right).offset(4);
    }];
    
    [self.seeCountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_right).offset(16);
        make.centerY.equalTo(self.seeCountLabel);
    }];
    
    self.likeButton = [UIButton new];
    self.likeButton.backgroundColor = [UIColor clearColor];
    [self.likeButton setImage:[UIImage imageNamed:@"likeIconNor"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"likeIconPress"] forState:UIControlStateSelected];
    self.likeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.authorIcon);
        make.width.height.equalTo(@40);
    }];
}

@end
