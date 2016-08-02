//
//  EquipmentCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "EquipmentCollectionViewCell.h"

@implementation EquipmentCollectionViewCell

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width / 2 - 41 / 2, 20, 41, 41)];
        [self.contentView addSubview:_photoImageView];
    }
    return _photoImageView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, self.hd_height - 35, self.hd_width, 10)];
        _titleLB.font = [UIFont systemFontOfSize:10];
        _titleLB.textAlignment = 1;
        _titleLB.textColor = UIColorFromRGB(0x666666);
        [self.contentView addSubview:_titleLB];
    }
    return _titleLB;
}

@end
