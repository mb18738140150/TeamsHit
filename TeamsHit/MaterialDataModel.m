//
//  MaterialDataModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MaterialDataModel.h"
#import "ImageUtil.h"
#define SELF_WIDTH 384

@implementation MaterialDataModel

- (void)setImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    
    if (imageSize.width > 384) {
        image = [self calculateImagesize:image];
        NSLog(@"适应宽度");
    }else
    {
        image = [self integerCalculateImagesize:image];
    }
    _dealImage = image;
    _image = image;
    if (!self.isprocessImage) {
        if (self.imageModel == MateriaModel) {
            image = [ImageUtil ditherImage:image];
            _dealImage = [ImageUtil erzhiBMPImage:image];
        }else
        {
            _dealImage = [ImageUtil erzhiBMPImage:image];
        }
    }
    self.height = [self getImageHeight:_dealImage.size];
}

- (UIImage *)calculateImagesize:(UIImage *)image
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(SELF_WIDTH, (int )(SELF_WIDTH *size.height / size.width)));
    [image drawInRect:CGRectMake(0, 0, SELF_WIDTH, (int )(SELF_WIDTH *size.height / size.width))];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)integerCalculateImagesize:(UIImage *)image
{
    CGSize size = image.size;
    int width = (int )size.width;
    int height = (int)size.height;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)integerRightCalculateImagesize:(UIImage *)image
{
    CGSize size = image.size;
    int width = (int )size.width;
    int height = (int)size.height;
    UIGraphicsBeginImageContext(CGSizeMake(width - 3, height));
    [image drawInRect:CGRectMake(0, 0, width - 3, height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGFloat)getImageHeight:(CGSize)size
{
    CGFloat height;
    
    if (size.width <= screenWidth - 90) {
        height = size.height;
    }else
    {
        height = size.height * (screenWidth - 90) / size.width;
    }
    
//    NSLog(@"%f *** %f", size.width, height);
    
    return height;
}

- (UIImage *)getDownImge:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextTranslateCTM(context, image.size.width, 0);
    CGContextScaleCTM(context, -1.f, 1.f);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage * downImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return downImage;
}
- (UIImage *)getMirrorImage:(UIImage *)image
{
    CGRect  rect =  CGRectMake(0, 0, image.size.width , image.size.height);
    UIGraphicsBeginImageContextWithOptions(image.size, false, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, rect);
    CGContextRotateCTM(context, M_PI);
    CGContextTranslateCTM(context, -rect.size.width, -rect.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    UIImage * downImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return downImage;
}

@end
