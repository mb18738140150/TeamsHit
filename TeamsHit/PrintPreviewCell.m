//
//  PrintPreviewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PrintPreviewCell.h"

@implementation PrintPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)creatSubView:(CGFloat)width
{
    [self.contentView removeAllSubviews];
    
    CGFloat imageWidth = 0.0;
    if (width > screenWidth - 70) {
        imageWidth = screenWidth - 70;
    }else
    {
        imageWidth = width;
    }
    
    self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.contentView.hd_width - imageWidth) / 2, 3, imageWidth, self.contentView.hd_height - 6)];
    [self.contentView addSubview:_photoImageView];
}

- (void)setImage:(UIImage *)image
{
    CGFloat height;
    CGSize size = image.size;
    if (size.width <= screenWidth - 70) {
        height = size.height;
        self.photoImageView.hd_width = size.width;
        self.photoImageView.hd_height = height;
    }else
    {
        height = size.height * (screenWidth - 70) / size.width;
        self.photoImageView.hd_width = screenWidth - 70;
        self.photoImageView.hd_height = height;
    }
    self.photoImageView.image = image;
    self.photoImageView.center = self.contentView.center;
}

//- (UIImageView *)photoImageView
//{
//    if (!_photoImageView) {
//        self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 3, self.contentView.hd_width - 40, self.contentView.hd_height - 6)];
//        [self.contentView addSubview:_photoImageView];
//    }
//    return _photoImageView;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
