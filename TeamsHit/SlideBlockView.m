//
//  SlideBlockView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SlideBlockView.h"

#define minHeight ([UIScreen mainScreen].bounds.size.height / 3) * 2 - 64

@implementation SlideBlockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backImageView.image = [UIImage imageNamed:@"展开1"];
    [self addSubview:self.backImageView];
    self.backImageView.userInteractionEnabled = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.beginPoint = [[touches anyObject] locationInView:self];
    NSLog(@"begain");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    // 获取触摸当前view上的位置
    CGPoint endPoint = [[touches anyObject] locationInView:self];
    // 手指移动的坐标
    CGPoint offSetPoint = CGPointMake(endPoint.x - _beginPoint.x, endPoint.y - _beginPoint.y);
    if (self.hd_y >= minHeight && self.hd_y <= screenHeight - 64 - 100) {
        
        if (self.hd_y == minHeight) {
            if (offSetPoint.y < 0) {
                return;
            }
        }
        
        if (self.hd_y == screenHeight - 64 - 100) {
            if (offSetPoint.y > 0) {
                return;
            }
        }
        
        self.center = CGPointMake(self.center.x, self.center.y + offSetPoint.y);
        
        if (self.myBlock) {
            _myBlock(offSetPoint);
        }
        
    }else
    {
        return;
    }
    NSLog(@"move  %f", offSetPoint.y);
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.hd_y < minHeight) {
        self.center = CGPointMake(self.center.x, minHeight + self.hd_height / 2);
        self.hd_y = minHeight;
    }else if(self.hd_y > screenHeight - 64 - 100)
    {
        self.center = CGPointMake(self.center.x, screenHeight - 64 - 100 + self.hd_height / 2);
        self.hd_y = screenHeight - 64 - 100;
    }
    if (self.myBlock) {
        _myBlock(CGPointMake(0, 0));
    }
}

- (void)moveSlideBlock:(MoveConversationViewBlock)block
{
    self.myBlock = [block copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
