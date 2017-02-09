//
//  CollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/6.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "GameBackImageCollectionViewCell.h"

@implementation GameBackImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatSubviews];
    }
    return self;
}

- (void)creatSubviews
{
    self.backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 42)];
    [self.contentView addSubview:self.backImage];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake((self.hd_width - 50) / 2, self.hd_height - 30, 50, 20);
    self.selectButton.layer.cornerRadius = 3;
    self.selectButton.layer.masksToBounds = YES;
    self.selectButton.backgroundColor = UIColorFromRGB(0x12B7F5);
    [self.selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.selectButton];
    [self.selectButton addTarget:self action:@selector(selectimage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectimage
{
    if (self.myblock ) {
        self.myblock();
    }
}

- (void)selectgamebackImage:(SelectbackImageBlock)block
{
    self.myblock = [block copy];
}

@end
