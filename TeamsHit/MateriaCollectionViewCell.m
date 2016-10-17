//
//  MateriaCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MateriaCollectionViewCell.h"

@implementation MateriaCollectionViewCell

- (void)creatContantViewWith:(CGSize)imageSize
{
    [self.contentView removeAllSubviews];
    self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [self.contentView addSubview:_photoImageView];
}

@end
