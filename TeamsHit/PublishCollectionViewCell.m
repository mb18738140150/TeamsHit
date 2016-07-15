//
//  PublishCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PublishCollectionViewCell.h"

@implementation PublishCollectionViewCell

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        self.photoImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_photoImageView];
    }
    return _photoImageView;
}

@end
