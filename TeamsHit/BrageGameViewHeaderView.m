//
//  BrageGameViewHeaderView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BrageGameViewHeaderView.h"

#define MAINCOLOR [UIColor whiteColor]

#define LEFTSPACE 45
#define TOP_SPACE  20

@implementation BrageGameViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI:type title:title];
    }
    return self;
}

- (void)creatUI:(NSString *)type title:(NSString *)title
{
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(13 - LEFTSPACE, 32 - TOP_SPACE, 40, 16)];
    self.timeLB.textColor = MAINCOLOR;
    self.timeLB.font = [UIFont systemFontOfSize:15];
    self.timeLB.textAlignment = 1;
    self.timeLB.text = @"时间";
    [self addSubview:self.timeLB];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(13 - LEFTSPACE, 50 - TOP_SPACE, 40, 20)];
    self.timeLabel.textColor = MAINCOLOR;
    self.timeLabel.font = [UIFont systemFontOfSize:19];
    self.timeLabel.textAlignment = 1;
    self.timeLabel.text = @"30";
    [self addSubview:self.timeLabel];
    
//    self.view1 = [[UILabel alloc]initWithFrame:CGRectMake(12 - LEFTSPACE, 56 - TOP_SPACE, 13, 1)];
//    self.view1.backgroundColor = MAINCOLOR;
//    [self addSubview:self.view1];
//    
//    self.view2 = [[UILabel alloc]initWithFrame:CGRectMake(29 - LEFTSPACE, 56 - TOP_SPACE, 13, 1)];
//    self.view2.backgroundColor = MAINCOLOR;
//    [self addSubview:self.view2];
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(13 - LEFTSPACE, 32 - TOP_SPACE, 100, 16)];
    self.typeLabel.textColor = MAINCOLOR;
    self.typeLabel.font = [UIFont systemFontOfSize:15];
    self.typeLabel.text = type;
    self.typeLabel.textAlignment = 1;
    [self addSubview:self.typeLabel];
    self.typeLabel.hd_centerX = self.hd_centerX - LEFTSPACE;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13 - LEFTSPACE, 51 - TOP_SPACE, 150, 18)];
    self.titleLabel.textColor = MAINCOLOR;
    self.titleLabel.textAlignment = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.text = title;
    [self addSubview:self.titleLabel];
    self.titleLabel.hd_centerX = self.hd_centerX- LEFTSPACE;
    
    self.setUpBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setUpBT.frame = CGRectMake(self.hd_width - 30 - LEFTSPACE, 32 - TOP_SPACE, 25, 25);
    [self.setUpBT setTitleColor:MAINCOLOR forState:UIControlStateNormal];
//    [self.setUpBT setTitle:@"设置" forState:UIControlStateNormal];
    self.setUpBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.setUpBT setImage:[UIImage imageNamed:@"groupSetup"] forState:UIControlStateNormal];
//    _setUpBT.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//    _setUpBT.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
    
    [self addSubview:self.setUpBT];
    [_setUpBT addTarget:self action:@selector(setupAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupAction
{
    NSLog(@"点击了设置按钮");
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(setUpGameChatGroup)]) {
        [self.delegete setUpGameChatGroup];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
