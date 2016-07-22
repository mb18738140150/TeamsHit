//
//  GraffitiPath.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GraffitiPath.h"

@implementation GraffitiPath

+ (instancetype)paintPathWithLineWidth:(CGFloat)width startPoint:(CGPoint)startP
{
    GraffitiPath * path = [[self alloc]init];
    path.lineWidth = width;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:startP];
    return path;
}

@end
