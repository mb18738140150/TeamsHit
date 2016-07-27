//
//  QRCode.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "QRCode.h"

@implementation QRCode

+(QRCode *)shareQRCode
{
    static QRCode * qrCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qrCode = [[QRCode alloc]init];
    });
    return qrCode;
}

- (UIImage *)createQRCodeForString:(NSString *)qrString withWidth:(CGFloat)width
{
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData * data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage * outputImage = [filter outputImage];
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage * image = [UIImage imageWithCGImage:cgImage scale:0.1 orientation:UIImageOrientationUp];
    
    UIImage * resized = [self resizeImage:image withQuality:kCGInterpolationNone rate:5.0];
    UIImage * endImage = [self scaleWithFixedWidth:width image:resized];
    CGImageRelease(cgImage);
    
    return endImage;
}

- (UIImage *)resizeImage:(UIImage *)image withQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate
{
    UIImage * resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized;
}

- (UIImage *)scaleWithFixedWidth:(CGFloat)width image:(UIImage *)image
{
    float newHeight = image.size.height * (width / image.size.width);
    CGSize size = CGSizeMake(width, newHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    UIImage * outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

@end
