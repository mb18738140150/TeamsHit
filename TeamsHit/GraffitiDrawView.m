//
//  GraffitiDrawView.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GraffitiDrawView.h"
#import "GraffitiPath.h"


@interface GraffitiDrawView ()

// 绘制图形的路径
@property (nonatomic, strong)GraffitiPath * path;
// 装在所有路径的数组
@property (nonatomic, strong)NSMutableArray<GraffitiPath *> *pathArray;

@end

@implementation GraffitiDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = [UIColor blackColor];
    }
    return self;
}

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = touches.anyObject;
    CGPoint loc = [touch locationInView:self];
    
    self.path = [GraffitiPath bezierPath];
    [self.path moveToPoint:loc];
    
    [self.pathArray addObject:self.path];
    
    self.path.lineWidth = self.width;
    self.path.lineColor = self.lineColor;
    if (self.isEraser) {
        self.path.isEraser = YES;
    }else
    {
        self.path.isEraser = NO;
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = touches.anyObject;
    CGPoint loc = [touch locationInView:self];
    
    [self.path addLineToPoint:loc];
    [self setNeedsDisplay];
}


/**
 *  画线
 */
- (void)drawRect:(CGRect)rect{
    
    [self.pathArray enumerateObjectsUsingBlock:^(GraffitiPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.lineColor setStroke];
        if (obj.isEraser) {
            [obj strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
        }
        obj.lineCapStyle = kCGLineCapRound;
        obj.lineJoinStyle = kCGLineJoinRound;
        //渲染
        [obj stroke];
    }];
    
}
/**
 *  清屏
 */
- (void)clearScreen
{
    [self.pathArray removeAllObjects];
    
    [self setNeedsDisplay];
}

/**
 *  撤销
 */
- (void)undo
{
    //当前屏幕已经清空，就不能撤销了
    if (!self.pathArray.count) {
        return;
    }
    [self.pathArray removeLastObject];
    [self setNeedsDisplay];
}


#pragma mark - Getters

- (NSMutableArray<GraffitiPath *> *)pathArray
{
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
