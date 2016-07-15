//
//  MLSelectPhotoAssets.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MLSelectPhotoAssets.h"

@implementation MLSelectPhotoAssets

- (UIImage *)thumbImage
{
    return [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
}
- (UIImage *)originImage
{
    return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
}

- (BOOL)isVideoType
{
    NSString * type = [self.asset valueForProperty:ALAssetTypeVideo];
    return [type isEqualToString:ALAssetTypeVideo];
}

- (NSURL *)assetURL
{
    return [[self.asset defaultRepresentation] url];
}

@end
