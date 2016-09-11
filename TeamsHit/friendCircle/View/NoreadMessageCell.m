//
//  NoreadMessageCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "NoreadMessageCell.h"

NSString * const KNoreadFriendCircleMessgaeCellIdentifire = @"NoreadFriendCircleMessgaeCellIdentifire";

@implementation NoreadMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)creatCellWithFrame:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backView = [[UIView alloc]initWithFrame:CGRectMake((self.hd_width - 160) / 2, 10, 160, 40)];
    _backView.backgroundColor = [UIColor colorWithWhite:.4 alpha:1];
    CALayer * layer = _backView.layer;
    layer.cornerRadius = 3;
    layer.masksToBounds = YES;
    [self.contentView addSubview:_backView];
    NSLog(@"height %f", self.hd_height);
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, _backView.hd_height - 16, _backView.hd_height - 16)];
    [_backView addSubview:_iconImageView];
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.hd_height + _iconImageView.hd_x + 20, (_backView.hd_height - 15) / 2, _backView.hd_width -(_iconImageView.hd_height + _iconImageView.hd_x + 20 + 10) , 15)];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_numberLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
