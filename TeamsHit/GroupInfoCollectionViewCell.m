//
//  GroupInfoCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GroupInfoCollectionViewCell.h"

@implementation GroupInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_width)];
    [self.contentView addSubview:self.iconImageView];
    
    self.tipView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_width - 11, self.hd_width, 11)];
    self.tipView.backgroundColor = [UIColor clearColor];
    self.tipView.hidden = YES;
    [self.contentView addSubview:self.tipView];
    
    UIView * viewb = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, 11)];
    viewb.backgroundColor = [UIColor whiteColor];
    viewb.alpha = .4;
    [self.tipView addSubview:viewb];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, 11)];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.text = @"群主";
    self.tipLabel.font = [UIFont systemFontOfSize:9];
    self.tipLabel.textAlignment = 1;
    self.tipLabel.textColor = UIColorFromRGB(0x12B7F5);
    [self.tipView addSubview:self.tipLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.hd_width + 3 , self.hd_width, 13)];
    self.titleLabel.textAlignment = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.titleLabel];
}

@end
