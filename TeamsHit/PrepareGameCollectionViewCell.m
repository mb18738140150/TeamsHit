//
//  PrepareGameCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PrepareGameCollectionViewCell.h"

@implementation PrepareGameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    [self.contentView removeAllSubviews];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 5, self.hd_width - 5)];
    self.iconImageView.layer.cornerRadius = (self.hd_width - 5) / 2;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.prepareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width - 22, 0, 22, 22)];
    self.prepareImageView.image = [UIImage imageNamed:@"preparegameSign"];
    [self.contentView addSubview:self.prepareImageView];
    self.prepareImageView.hidden = YES;
    
}

@end
