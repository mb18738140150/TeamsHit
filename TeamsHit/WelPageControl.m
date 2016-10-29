//
//  WelPageControl.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "WelPageControl.h"

@interface WelPageControl ()
- (void)updateDotes;
@end

@implementation WelPageControl
- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    return self;
}
- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    [self updateDotes];
}

- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    [self updateDotes];
}

- (void)updateDotes
{
    if (_imagePageStateNormal || _imagePageStateHighlighted) {
        NSArray * subview = self.subviews;
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            
            if (i == self.currentPage) {
                [self setValue:_imagePageStateHighlighted forKey:@"_currentPageImage"];
            }else
            {
                [self setValue:_imagePageStateNormal forKey:@"_pageImage"];
                
            }
            
        }
    }
}
- (void)dealloc { // 释放内存
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
