//
//  ExpressionImageCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/17.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ExpressionImageCollectionViewCell.h"

static CGSize minSize = {10, 10};

@implementation ExpressionImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.tag = 1000;
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setExpressionImage:(UIImage *)expressionImage
{
    UIImageView * imageView = [self.contentView viewWithTag:1000];
    imageView.image = expressionImage;
    CGSize size = [self getImageSizeForPreview:expressionImage];
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    imageView.center = self.contentView.center;
}

- (CGSize)getImageSizeForPreview:(UIImage *)image
{
    CGFloat maxWidth = self.frame.size.width,maxHeight = self.frame.size.height;
    
    CGSize size = image.size;
    
    if (size.width > maxWidth) {
        size.height *= (maxWidth / size.width);
        size.width = maxWidth;
    }
    
    if (size.height > maxHeight) {
        size.width *= (maxHeight / size.height);
        size.height = maxHeight;
    }
    
    if (size.width < minSize.width) {
        size.height *= (minSize.width / size.width);
        size.width = minSize.width;
    }
    
    if (size.height < minSize.height) {
        size.width *= (minSize.height / size.height);
        size.height = minSize.height;
    }
    return size;
    
}

@end
