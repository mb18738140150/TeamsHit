//
//  ScannerMaskView.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ScannerMaskView.h"

@implementation ScannerMaskView

+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect
{
    ScannerMaskView * maskView = [[self alloc] initWithFrame:frame];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.cropRect = cropRect;
    
    return maskView;
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0.0 alpha:0.4] setFill];
    CGContextFillRect(ctx, rect);
    CGContextClearRect(ctx, self.cropRect);
    [[UIColor colorWithWhite:0.95 alpha:1.0] setStroke];
    CGContextStrokeRectWithWidth(ctx, CGRectInset(_cropRect, 1, 1), 1);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
