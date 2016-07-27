//
//  ProcessImageTypeCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ProcessImageTypeCollectionViewCell.h"

@implementation ProcessImageTypeCollectionViewCell

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 3, self.hd_width - 12, self.hd_height - 6)];
        [self.contentView addSubview:_photoImageView];
    }
    return _photoImageView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, self.hd_height - 8, self.hd_width, 7)];
        if (_photoImageView) {
            _photoImageView.frame = CGRectMake(6, 3, self.hd_width - 12, self.hd_height - 13);
        }else
        {
            _titleLB.frame = CGRectMake(6, 3, self.hd_width - 12, self.hd_height - 6);
        }
        _titleLB.font = [UIFont systemFontOfSize:7];
        _titleLB.textAlignment = 1;
        _titleLB.textColor = [UIColor grayColor];
        [self.contentView addSubview:_titleLB];
    }
    return _titleLB;
}

@end
