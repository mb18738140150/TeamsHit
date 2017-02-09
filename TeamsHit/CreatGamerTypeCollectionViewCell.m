//
//  CreatGamerTypeCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CreatGamerTypeCollectionViewCell.h"

@implementation CreatGamerTypeCollectionViewCell

- (UIImageView *)typeIconImageview
{
    if (!_typeIconImageview) {
        self.typeIconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.width)];
        [self.contentView addSubview:_typeIconImageview];
    }
    return _typeIconImageview;
}

- (UILabel *)typeNamelabel
{
    if (!_typeNamelabel) {
        self.typeNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.contentView.bounds.size.width + 5, self.contentView.bounds.size.width, 15)];
        self.typeNamelabel.textColor = [UIColor whiteColor];
        self.typeNamelabel.font = [UIFont systemFontOfSize:14];
        self.typeNamelabel.textAlignment = 1;
        [self.contentView addSubview:_typeNamelabel];
    }
    return _typeNamelabel;
}

@end
