//
//  ImageUtil.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ImageUtil.h"

#include <sys/time.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

CGContextRef CreatRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n"); return NULL;
    }
    
    bitmapData = malloc(bitmapByteCount);
    if(bitmapData == NULL)
    {
        fprintf(stderr, "Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast);
    if (context == NULL) {
        free(bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

unsigned char * RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    CGContextRef cgctx = CreatRGBABitmapContext(img);
    if (cgctx == NULL) {
        return NULL;
    }
    
    CGRect rect = {{0,0},{size.width, size.height}};
    CGContextDrawImage(cgctx, rect, img);
    unsigned char * data = CGBitmapContextGetData(cgctx);
    CGContextRelease(cgctx);
    return data;
}

@implementation ImageUtil

+ (UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage * grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

+ (UIImage *)imageBlackToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        //if (*pCurPtr & 0xFFFFFF00) == 0xffffff00) // 为白色的部分
        //else if ((*pCurPtr & 0xFFFFFF00) == 0) // 为黑色的部分
        
        uint8_t* ptr = (uint8_t*)pCurPtr;
        //下面是颜色反转,黑色变白色,白色变黑色,其他类似对调
        //            ptr[0] ; //这个表示alpha
        ptr[1] = 255 - ptr[1]; ////0~255
        ptr[2] = 255 - ptr[2];
        ptr[3] = 255 - ptr[3];
        //        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}
//遍历图片像素，更改图片颜色
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

+ (UIImage *)splashInk:(UIImage *)image
{
    unsigned char *imgPixel = RequestImagePixelData(image);
    CGImageRef inImageRef = [image CGImage];
    GLuint w = CGImageGetWidth(inImageRef);
    GLuint h = CGImageGetHeight(inImageRef);
    
    int wOff = 0;
    int pixOff = 0;
    
    for (GLuint y = 0; y<h; y++) {
        pixOff = wOff;
        
        for (GLuint x = 0; x < w; x++) {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            
            int ava = (int)((red+green+blue)/3.0);
            
            int newAva = ava > 128 ? 255:0;
            
            imgPixel[pixOff] = newAva;
            imgPixel[pixOff+1] = newAva;
            imgPixel[pixOff+2] = newAva;
            
            pixOff += 4;
        }
        wOff += w * 4;
    }
    
    NSInteger dataLength = w*h*4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageref = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *my_Image = [UIImage imageWithCGImage:imageref];
    
    CFRelease(imageref);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
    
    return image;
}
+ (UIImage*)memory:(UIImage*)inImage
{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    GLuint w = CGImageGetWidth(inImageRef);
    GLuint h = CGImageGetHeight(inImageRef);
    
    int wOff = 0;
    int pixOff = 0;
    
    for(GLuint y = 0;y< h;y++)
    {
        pixOff = wOff;
        
        for (GLuint x = 0; x<w; x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            
            red = green = blue = ( red + green + blue ) /3;
            
            blue += blue*2;
            green = green*2;
            
            if(blue > 255)
                blue = 255;
            if(green > 255)
                green = 255;
            
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            
            pixOff += 4;
        }
        wOff += w * 4;
    }
    
    NSInteger dataLength = w*h* 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef, 
                                        bitmapInfo, 
                                        provider, NULL, NO, renderingIntent);
    
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return my_Image;
}


@end
