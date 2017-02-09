//
//  ImageUtil.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ImageUtil.h"
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import "UserInfo.h"

#ifdef DEBUG

#define NSLog1(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else

#define NSLog1(FORMAT, ...) nil

#endif

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
    void * data = CGBitmapContextGetData(cgctx);
    CGContextRelease(cgctx);
    return (unsigned char *)data;
}

char* cgeGenBufferWithCGImage(CGImageRef imgRef)
{
    if(imgRef == nil)
        return nullptr;
    
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    size_t stride;
    
    CGContextRef context;
    
    char* imageBuffer = nullptr;
    
    stride = width;
    imageBuffer = (char*) malloc(stride * height);
    context = CGBitmapContextCreate(imageBuffer, width, height, 8, stride, CGColorSpaceCreateDeviceGray(), kCGImageAlphaNone);
    
    if(context != nil)
    {
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
        CGContextRelease(context);
    }
    
    return imageBuffer;
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

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

+ (UIImage *)ditherImage:(UIImage *)image
{
    ImageUtil * imageU = [[ImageUtil alloc]init];
    
    return  [imageU ditherBlackWhite:image];
    
    /*
     
     CGSize size = image.size;
     int width = size.width;
     int height = size.height;
     
     // the pixels will be painted to this array
     uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
     
     // clear the pixels so any transparency is preserved
     memset(pixels, 0, width * height * sizeof(uint32_t));
     
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     
     // create a context with RGBA pixels
     CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
     kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
     
     // paint the bitmap to our context which will fill in the pixels array
     CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
     
     for(int y = 0; y < height; y++) {
     for(int x = 0; x < width; x++) {
     uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
     
     // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
     uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
     
     // set the pixels to gray
     rgbaPixel[RED] = gray;
     rgbaPixel[GREEN] = gray;
     rgbaPixel[BLUE] = gray;
     }
     }
     
     // create a new CGImageRef from our context with the modified pixels
     CGImageRef img = CGBitmapContextCreateImage(context);
     
     // we're done with the context, color space, and pixels
     CGContextRelease(context);
     CGColorSpaceRelease(colorSpace);
     free(pixels);
     
     // make a new UIImage to return
     UIImage *resultUIImage = [UIImage imageWithCGImage:img];
     
     // we're done with image now too
     CGImageRelease(img);
     
     UIImage * newImage = [self FloydSteinberg:resultUIImage];
     
     return newImage;
     */
}

- (UIImage *)FloydSteinberg:(UIImage *)image
{
    
    CGSize size = image.size;
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    int error,displayed;
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            int  Y  =  rgbaPixel[RED];
            
            if (Y > 128) displayed = 255;
            else                         displayed = 0;
            
            error = Y - displayed;
            Y = displayed;
            rgbaPixel[RED] = Y;
            rgbaPixel[GREEN] = Y;
            rgbaPixel[BLUE] = Y;
            if (x + 1 < width)
            {// 右侧
                uint8_t *rgbaPixel_right = (uint8_t *) &pixels[y * width + x + 1];
                rgbaPixel_right[RED]   += 7 * error / 16 ;
                rgbaPixel_right[GREEN] += 7 * error / 16;
                rgbaPixel_right[BLUE] += 7 * error / 16;
            }
            if (y + 1 < height) {
                if (x - 1 > 0)
                {// 左下侧
                    uint8_t *rgbaPixel_leftButtom = (uint8_t *) &pixels[y * width + x - 1 + width];
                    rgbaPixel_leftButtom[RED] += 3 * error / 16 ;
                    rgbaPixel_leftButtom[GREEN] += 3 * error / 16 ;
                    rgbaPixel_leftButtom[BLUE] += 3 * error / 16 ;
                }
                // 下
                uint8_t *rgbaPixel_buttom = (uint8_t *) &pixels[y * width + x + width];
                rgbaPixel_buttom[RED] += 5 * error / 16 ;
                rgbaPixel_buttom[GREEN] += 5 * error / 16 ;
                rgbaPixel_buttom[BLUE] += 5 * error / 16 ;
                
                if (x + 1 < width)
                {// 右下侧
                    uint8_t *rgbaPixel_rightbuttom = (uint8_t *) &pixels[y * width + x + 1 + width];
                    rgbaPixel_rightbuttom[RED] += 1 * error / 16 ;
                    rgbaPixel_rightbuttom[GREEN] += 1 * error / 16 ;
                    rgbaPixel_rightbuttom[BLUE] += 1 * error / 16 ;
                }
            }
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef img = CGBitmapContextCreateImage(context);
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:img];
    
    // we're done with image now too
    CGImageRelease(img);
    
    return resultUIImage;
    /*
     unsigned char *imgPixel = RequestImagePixelData(image);
     CGImageRef inImageRef = [image CGImage];
     GLuint w = CGImageGetWidth(inImageRef);
     GLuint h = CGImageGetHeight(inImageRef);
     
     int wOff = 0;
     int pixOff = 0;
     int error,displayed;
     for(GLuint y = 1;y< h;y++)
     {
     pixOff = wOff;
     for (GLuint x = 1; x<w; x++)
     {
     int red = (unsigned char)imgPixel[pixOff];
     int  Y  =  red;
     
     if (Y > 128) displayed = 255;
     else                         displayed = 0;
     
     error = Y - displayed;
     Y = displayed;
     imgPixel[pixOff] = Y;
     imgPixel[pixOff+1] = Y;
     imgPixel[pixOff+2] = Y;
     if (x + 1 < w)
     {// 右侧
     imgPixel[pixOff + 4]   += 7 * error / 16 ;
     imgPixel[pixOff+1 + 4] += 7 * error / 16;
     imgPixel[pixOff+2 + 4] += 7 * error / 16;
     }
     if (y + 1 < h) {
     if (x - 1 > 0)
     {// 左下侧
     imgPixel[pixOff - 4 + w*4] += 3 * error / 16 ;
     imgPixel[pixOff - 4 + 1 + w*4] += 3 * error / 16 ;
     imgPixel[pixOff - 4 + 2 + w*4] += 3 * error / 16 ;
     }
     // 下
     imgPixel[pixOff + w*4] += 5 * error / 16 ;
     imgPixel[pixOff + 1 + w*4] += 5 * error / 16 ;
     imgPixel[pixOff + 2 + w*4] += 5 * error / 16 ;
     
     if (x + 1 < w)
     {// 右下侧
     imgPixel[pixOff + 4 + w*4] += 1 * error / 16 ;
     imgPixel[pixOff + 1 + 4 + w*4] += 1 * error / 16 ;
     imgPixel[pixOff + 2 + 4 + w*4] += 1 * error / 16 ;
     }
     }
     
     pixOff += 4;
     
     }
     wOff += w * 4;
     }
     
     NSInteger dataLength = w*h*4;
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
     
     */
}

- (UIImage *)ditherBlackWhite:(UIImage *)image
{
    int imageHeight = image.size.height;

        if (imageHeight > 681) {
            if (imageHeight - screenHeight > 200 && imageHeight - screenHeight < 400)  {
                image = [self getbeganImage1With:image height:imageHeight - 200];
            }else if(imageHeight - screenHeight < 200)
            {
                if (imageHeight > 683) {
                    image = [self getbeganImageWith:image height:imageHeight - 100];
                }else
                {
                    image = [self getbeganImageWith:image height:imageHeight - 10];
                }
            }else
            {
                image = [self FloydSteinberg:image];
                return image;
            }
        }else
        {
            image = [self getbeganImageWith:image height:imageHeight - 10];
        }
    NSLog(@"imagesize width = %.2f, height = %.2f , screenHeight = %f", image.size.width, image.size.height, screenHeight);
    unsigned char *imgPixel = RequestImagePixelData(image);
    
    CGImageRef inImageRef = [image CGImage];
    GLuint w = CGImageGetWidth(inImageRef);
    GLuint h = CGImageGetHeight(inImageRef);
    
    int pixelsArray[w*h];
    int wOff = 0;
    int pixOff = 0;
    for(GLuint y = 1;y< h;y++)
    {
        pixOff = wOff;
        for (GLuint x = 1; x<w; x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            
//            int  Y  =  0.299*red + 0.587*green + 0.114*blue;
            int  Y  =  0.3*red + 0.6*green + 0.1*blue;
            pixelsArray[x+y*w] = Y;
            pixOff += 4;
            
        }
        wOff += w * 4;
    }
//    int x,y;
    int error,displayed;
    
    for (GLuint y=1; y<h; y++) {
        for (GLuint x=1; x<w; x++) {
            
            int oldPixel = pixelsArray[x+y*w];
            if (pixelsArray[x+y*w] > 128) displayed = 255;
            else                         displayed = 0;
            
            error = oldPixel - displayed;
            pixelsArray[x+y*w] = displayed;
            
            if (x + 1 < w)     pixelsArray[x+1 + w*y]   += 7 * error / 16 ;
            if (y + 1 < h) {
                if (x - 1 > 0)      pixelsArray[x-1 + w * (y+1)] += 3 * error / 16 ;
                pixelsArray[x + w * (y+1)] += 5 * error / 16 ;
                if (x + 1 < w) pixelsArray[x+1 + w * (y+1)] += 1 * error / 16 ;
            }
            
        }
    }
    
    pixOff = 0;
    wOff = 0;
    for(GLuint y = 1;y< h;y++)
    {
        pixOff = wOff;
        for (GLuint x = 1; x<w; x++)
        {
            imgPixel[pixOff] = pixelsArray[x+y*w];
            imgPixel[pixOff+1] = pixelsArray[x+y*w];
            imgPixel[pixOff+2] = pixelsArray[x+y*w];
            
            pixOff += 4;
        }
        wOff += w * 4;
    }
    
    NSInteger dataLength = w*h*4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(imgPixel, imgPixel, dataLength, NULL);
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
    
    
//    ImageUtil * imageUtil = [[ImageUtil alloc]init];
//    UIImage * defaultImage = [[UIImage alloc]init];
//    defaultImage = [imageUtil getDownImge:my_Image];
//    defaultImage = [imageUtil getMirrorImage:defaultImage];
//    
//    unsigned char* buffer = (unsigned char*)cgeGenBufferWithCGImage(defaultImage.CGImage);
//    
//    NSDate * nowdate = [NSDate date];
//    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[nowdate timeIntervalSince1970]];
//    
//    NSString* fileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.bmp", timeSp]];
//    int otsu = OTSU(buffer, my_Image.size.width, my_Image.size.height);
//    [UserInfo shareUserInfo].timeStr = timeSp;
//    [self saveToBMPAndConvert8BitData:buffer filename:[fileName UTF8String]  width:my_Image.size.width height:my_Image.size.height linesize:my_Image.size.width otsu:otsu];
////    NSLog(@"filePath = %@", fileName);
////    NSLog(@"创建新图片");
//    UIImage *bmpImage = [UIImage imageWithContentsOfFile:fileName];
//    bmpImage = [imageUtil getDownImge:bmpImage];
//    bmpImage = [imageUtil getMirrorImage:bmpImage];
    
//    if (imageHeight > screenHeight) {
//        my_Image = [self getbeganImageWith:my_Image height:imageHeight];
//    }
    
//    NSLog(@"screenHeight = %.2f", screenHeight);
//    NSLog(@"imagesize width = %.2f, height = %.2f", my_Image.size.width, my_Image.size.height);
    return my_Image;
}
+ (UIImage *)erzhiBMPImage:(UIImage *)image
{
    NSLog(@"erzhiBMPImage width = %.2f, height = %.2f", image.size.width, image.size.height);
    
    AppDelegate * delegate = ShareApplicationDelegate;
    MBProgressHUD * hud= [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    [hud show:YES];
    
    ImageUtil * imageUtil = [[ImageUtil alloc]init];
    UIImage * defaultImage = [[UIImage alloc]init];
    defaultImage = [imageUtil getDownImge:image];
    defaultImage = [imageUtil getMirrorImage:defaultImage];
    
    unsigned char* buffer = (unsigned char*)cgeGenBufferWithCGImage(defaultImage.CGImage);
    
    NSDate * nowdate = [NSDate date];
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[nowdate timeIntervalSince1970]];
    
    NSString* fileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.bmp", timeSp]];
    int otsu = OTSU(buffer, defaultImage.size.width, defaultImage.size.height);
    if (otsu == 0) {
        otsu = 127;
    }
    [UserInfo shareUserInfo].timeStr = timeSp;
    ImageUtil * imageU = [[ImageUtil alloc]init];
    [imageU saveToBMPAndConvert8BitData:buffer filename:[fileName UTF8String]  width:image.size.width height:image.size.height linesize:image.size.width otsu:otsu];
    
    NSLog(@"创建新图片");
    UIImage *bmpImage = [UIImage imageWithContentsOfFile:fileName];
    [hud hide:YES];
    //    UIImageWriteToSavedPhotosAlbum(bmpImage, nil, nil, nil);
    
    bmpImage = [imageUtil getDownImge:bmpImage];
    bmpImage = [imageUtil getMirrorImage:bmpImage];
    
    return bmpImage;
}

//如果图像无对齐, linesize与width相等
- (void)saveToBMPAndConvert8BitData:(const unsigned char*)data filename:(const char*)filename width:(int)w height:(int)h linesize:(int)dataLineSize otsu:(int)otsu
{
    NSLog(@"otsu = %d", otsu);
    
    unsigned char file[14] = {
        'B','M', // magic
        0,0,0,0, // size in bytes
        0,0, // app data
        0,0, // app data
        40+14,0,0,0 // start of data offset
    };
    unsigned char info[48] = {
        40,0,0,0, // info hd size
        0,0,0,0, // width
        0,0,0,0, // heigth
        1,0, // number color planes
        1,0, // bits per pixel
        0,0,0,0, // compression is none
        0,0,0,0, // image bits size
        0x13,0x0B,0,0, // horz resoluition in pixel / m
        0x13,0x0B,0,0, // vert resolutions (0x03C3 = 96 dpi, 0x0B13 = 72 dpi)
        2,0,0,0, // #colors in pallete
        0,0,0,0, // #important colors
        0,0,0,0, // 调色板0
        0xff,0xff,0xff,0xff, // 调色板1
    };
    
    //    int padSize = (32-w%32)%32; //in bits
    int lineSize = (int)ceilf(w / 32.0f) * 4;
    int sizeData = (lineSize * h);
    int sizeAll  = sizeData + sizeof(file) + sizeof(info);
    
    file[ 2] = (unsigned char)( sizeAll    );
    file[ 3] = (unsigned char)( sizeAll>> 8);
    file[ 4] = (unsigned char)( sizeAll>>16);
    file[ 5] = (unsigned char)( sizeAll>>24);
    
    info[ 4] = (unsigned char)( w   );
    info[ 5] = (unsigned char)( w>> 8);
    info[ 6] = (unsigned char)( w>>16);
    info[ 7] = (unsigned char)( w>>24);
    
    info[ 8] = (unsigned char)( h    );
    info[ 9] = (unsigned char)( h>> 8);
    info[10] = (unsigned char)( h>>16);
    info[11] = (unsigned char)( h>>24);
    
    info[20] = (unsigned char)( sizeData    );
    info[21] = (unsigned char)( sizeData>> 8);
    info[22] = (unsigned char)( sizeData>>16);
    info[23] = (unsigned char)( sizeData>>24);
    
    FILE* fp = fopen(filename, "wb");
    
    fwrite(file, sizeof(file), 1, fp);
    fwrite(info, sizeof(info), 1, fp);
    
    int floorLineSize = w / 8;
    unsigned char* lineData = (unsigned char*)malloc(lineSize);
    int remainBit = w % 8;
    
    for(int y = h - 1; y >= 0; --y)
    {
        int dataIndex = y * dataLineSize;
        memset(lineData, 0, lineSize);
        
#define MakeBitOP(offset) ((data[dataIndex++] < otsu ? 0 : 1) << offset)
        
        for(int i = 0; i != floorLineSize; ++i)
        {
            lineData[i] |= MakeBitOP(7);
            lineData[i] |= MakeBitOP(6);
            lineData[i] |= MakeBitOP(5);
            lineData[i] |= MakeBitOP(4);
            lineData[i] |= MakeBitOP(3);
            lineData[i] |= MakeBitOP(2);
            lineData[i] |= MakeBitOP(1);
            lineData[i] |= MakeBitOP(0);
        }
        
        for(int i = remainBit - 1; i >= 0; --i)
        {
            lineData[floorLineSize] |= MakeBitOP(i);
        }
        
        fwrite(lineData, lineSize, 1, fp);
    }
    
    free(lineData);
    
    fclose(fp);
}

- (NSString*)filePath:(NSString*)fileName {
    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* myDocPath = [myPaths objectAtIndex:0];
    NSString* filePath = [myDocPath stringByAppendingPathComponent:fileName];
    return filePath;
}

-(UIImage *)Erzhiimage:(UIImage *)srcimage
{
    UIImage *resimage;
    cv::Mat matImage = [self cvMatFromUIImage:srcimage];
    cv::Mat matGrey;
    cv::cvtColor(matImage, matGrey, CV_BGR2GRAY);// 转换灰色
    IplImage grey = matGrey;
    unsigned char*dataImage = (unsigned char*)grey.imageData;
    int threshold = OTSU(dataImage, grey.width, grey.height);
    // 利用阈值算得新的cvmat形式的图像
    cv::Mat matBinary;
    cv::threshold(matGrey, matBinary, threshold, 255, cv::THRESH_BINARY);
    UIImage * image = [[UIImage alloc]init];
    
    
//    IplImage bina = matImage;
//    unsigned char*imgPixel = (unsigned char*)bina.imageData;
//    
//    CGImageRef inImageRef = [srcimage CGImage];
//    GLuint w = CGImageGetWidth(inImageRef);
//    GLuint h = CGImageGetHeight(inImageRef);
//    
//    int pixelsArray[w*h];
//    int wOff = 0;
//    int pixOff = 0;
//    for(GLuint y = 1;y< h;y++)
//    {
//        pixOff = wOff;
//        for (GLuint x = 1; x<w; x++)
//        {
//            int red = (unsigned char)imgPixel[pixOff];
//            int green = (unsigned char)imgPixel[pixOff+1];
//            int blue = (unsigned char)imgPixel[pixOff+2];
//            
//            //           int  Y  =  0.299*red + 0.587*green + 0.114*blue;
//            int  Y  =  0.3*red + 0.6*green + 0.1*blue;
//            pixelsArray[x+y*w] = Y;
//            pixOff += 4;
//            
//        }
//        wOff += w * 4;
//    }
//    //    int x,y;
//    int error,displayed;
//    for (GLuint y=1; y<h; y++) {
//        for (GLuint x=1; x<w; x++) {
//            
//            int oldPixel = pixelsArray[x+y*w];
//            if (pixelsArray[x+y*w] > 128) displayed = 255;
//            else                         displayed = 0;
//            
//            error = oldPixel - displayed;
//            pixelsArray[x+y*w] = displayed;
//            
//            if (x + 1 < w)     pixelsArray[x+1 + w*y]   += 7 * error / 16 ;
//            if (y + 1 < h) {
//                if (x - 1 > 0)      pixelsArray[x-1 + w * (y+1)] += 3 * error / 16 ;
//                pixelsArray[x + w * (y+1)] += 5 * error / 16 ;
//                if (x + 1 < w) pixelsArray[x+1 + w * (y+1)] += 1 * error / 16 ;
//            }
//            
//        }
//    }
//    
//    pixOff = 0;
//    wOff = 0;
//    for(GLuint y = 1;y< h;y++)
//    {
//        pixOff = wOff;
//        for (GLuint x = 1; x<w; x++)
//        {
//            imgPixel[pixOff] = pixelsArray[x+y*w];
//            imgPixel[pixOff+1] = pixelsArray[x+y*w];
//            imgPixel[pixOff+2] = pixelsArray[x+y*w];
//            
//            pixOff += 4;
//        }
//        wOff += w * 4;
//    }
//    
//    bina.imageData = (char *)imgPixel;
//    cv::Mat matBinary;
//    matBinary = bina;
    image = [self UIImageFromCVMat:matBinary];
    resimage = image;
    return resimage;
}

- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 1
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_1U, 1);
    cvCvtColor(iplimage, ret, CV_BGR2GRAY);
    cvReleaseImage(&iplimage);
    
    return ret;
}


// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    // Allocating the buffer for CGImage
    NSData *data =
    [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
//    IPL_DEPTH_8U;
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
- (UIImage *)getbeganImageWith:(UIImage *)image height:(CGFloat)scalheight
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat scaleFactor = scalheight / height;
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake((int )scaledWidth - 1,(int )scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,(int )scaledWidth - 1,(int )scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //        NSLog(@"newImage.size.width = %f, newImage.size.height = %f", newImage.size.width, newImage.size.height);
    return newImage;
}

- (UIImage *)getbeganImage1With:(UIImage *)image height:(CGFloat)scalheight
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat scaleFactor = scalheight / height;
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake((int )scaledWidth + 0.1,(int )scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,(int )scaledWidth + 0.1,(int )scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //        NSLog(@"newImage.size.width = %f, newImage.size.height = %f", newImage.size.width, newImage.size.height);
    return newImage;
}

// 获取二值化阈值
int  OTSU(unsigned char* pGrayImg , int iWidth , int iHeight)
{
    if((pGrayImg==0)||(iWidth<=0)||(iHeight<=0))return -1;
    int ihist[256];
    int thresholdValue=0; // „–÷µ
    int n, n1, n2 ;
    double m1, m2, sum, csum, fmax, sb;
    int i,j,k;
    memset(ihist, 0, sizeof(ihist));
    n=iHeight*iWidth;
    sum = csum = 0.0;
    fmax = -1.0;
    n1 = 0;
    for(i=0; i < iHeight; i++)
    {
        for(j=0; j < iWidth; j++)
        {
            ihist[*pGrayImg]++;
            pGrayImg++;
        }
    }
    pGrayImg -= n;
    for (k=0; k <= 255; k++)
    {
        sum += (double) k * (double) ihist[k];
    }
    for (k=0; k <=255; k++)
    {
        n1 += ihist[k];
        if(n1==0)continue;
        n2 = n - n1;
        if(n2==0)break;
        csum += (double)k *ihist[k];
        m1 = csum/n1;
        m2 = (sum-csum)/n2;
        sb = (double) n1 *(double) n2 *(m1 - m2) * (m1 - m2);
        if (sb > fmax)
        {
            fmax = sb;
            thresholdValue = k;
        }
    }
    return(thresholdValue);
}

//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)image
{
    if (image.size.width > 384 ) {
        
        CGSize imageSize = image.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        if (width == 0 || height == 0){
            return image;
        }
        
        CGFloat scaleFactor = 384 / width;
        
        NSData * imagedata = UIImageJPEGRepresentation(image, scaleFactor);
        image = [UIImage imageWithData:imagedata];
        
        CGFloat scaledWidth = width * scaleFactor;
        CGFloat scaledHeight = height * scaleFactor;
        CGSize targetSize = CGSizeMake((int)scaledWidth,(int)scaledHeight);
        
        UIGraphicsBeginImageContext(targetSize);
        [image drawInRect:CGRectMake(0,0,(int)scaledWidth,(int)scaledHeight)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }else
    {
        return image;
    }
}

- (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height {
    
    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,    // data provider
                                    NULL,        // decode
                                    YES,            // should interpolate
                                    renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    
    if(pixels == NULL) {
        NSLog(@"Error: Memory not allocated for bitmap");
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 bitmapInfo);
    
    if(context == NULL) {
        NSLog(@"Error context not created");
        free(pixels);
    }
    
    UIImage *image = nil;
    if(context) {
        
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
        if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
            float scale = [[UIScreen mainScreen] scale];
            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        } else {
            image = [UIImage imageWithCGImage:imageRef];
        }
        
        CGImageRelease(imageRef);
        CGContextRelease(context);
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);
    
    if(pixels) {
        free(pixels);
    }
    return image;
}
+ (UIImage *)tailorborderImage:(UIImage *)image
{
    CGSize size = CGSizeMake(image.size.width - 3, image.size.height);
    UIGraphicsBeginImageContext(size);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width - 3, image.size.height));
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(con, 0.0, size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return newImage;
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
