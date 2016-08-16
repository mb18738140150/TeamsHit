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

@interface ImageUtil : NSObject

+ (UIImage *)grayImage:(UIImage *)sourceImage;

+ (UIImage *)imageBlackToTransparent:(UIImage*) image;

+ (UIImage *)splashInk:(UIImage *)image;

+ (UIImage*)memory:(UIImage*)inImage;

@end
