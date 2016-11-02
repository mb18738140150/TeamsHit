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
    }
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }else{
        
        data = UIImagePNGRepresentation(image);
    }
    CGFloat mm = data.length / 1024.0 / 1024;
    
    float i = 1.0;
    while (mm > 0.02) {
        data = UIImageJPEGRepresentation(image, i);
        mm = data.length / 1024.0 / 1024;
        i  -= 0.01;
        
        if (i <= 0.0) {
            image = [UIImage imageWithData:data];
            break;
        }
        
        NSLog(@"图片大小是%.3f M 格式是%@  " , mm , image ? @"PNG" : @"JPEG");
    }
    
    _dealImage = image;
    _image = image;
//    if (self.isprocessImage) {
//        dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", NULL);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            _dealImage = [ImageUtil ditherImage:image];
//        });
//    }
    self.height = [self getImageHeight:_dealImage.size];
    
}

- (UIImage *)calculateImagesize:(UIImage *)image
{
     CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [image drawInRect:CGRectMake(0, 0, SELF_WIDTH, SELF_WIDTH *size.height / size.width)];
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
    
    NSLog(@"%f *** %f", size.width, height);
    
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
