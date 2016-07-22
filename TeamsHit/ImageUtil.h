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

+(UIImage*) grayscale:(UIImage*)anImage type:(char)type;
+ (UIImage *)imageBlackToTransparent:(UIImage*) image;
@end
