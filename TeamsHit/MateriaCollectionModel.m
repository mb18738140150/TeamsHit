//
//  MateriaCollectionModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MateriaCollectionModel.h"

@implementation MateriaCollectionModel

- (void)setMateriaImage:(UIImage *)materiaImage
{
    [self calculateImageWidth:materiaImage];
    
}

- (void)calculateImageWidth:(UIImage *)image
{
    CGSize imageSize = image.size;
    
    self.materiaImageWidth = self.materiaImageHeight * imageSize.width / imageSize.height;
    
}

@end
