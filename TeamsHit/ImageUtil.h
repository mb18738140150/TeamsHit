//
//  ImageUtil.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#import "KSPixel.h"
@interface ImageUtil : NSObject

@property GLuint width;
@property GLuint height;
@property (nonatomic, strong) NSMutableArray *pixelsArray;
+ (UIImage *)grayImage:(UIImage *)sourceImage;

+ (UIImage *)imageBlackToTransparent:(UIImage*) image;

+ (UIImage *)splashInk:(UIImage *)image;

+ (UIImage*)memory:(UIImage*)inImage;

+ (UIImage *)ditherImage:(UIImage *)image;
- (UIImage *)ditherBlackWhite:(UIImage *)image;
+(UIImage *)getDefault:(UIImage *)image;
+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)image;
@end
