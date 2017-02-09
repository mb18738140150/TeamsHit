//
//  FantasyCollectionReusableView.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyCollectionReusableView.h"

@implementation FantasyCollectionReusableView

-(void) creatSubviews
{
    self.backgroundColor = [UIColor cyanColor];
    UIButton * quitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBT.frame = CGRectMake(15, 10, 40, 40);
    [quitBT setImage:[UIImage imageNamed:@"quieGameButton"] forState:UIControlStateNormal];
    [self addSubview:quitBT];
    [quitBT addTarget:self action:@selector(quitBragGame) forControlEvents:UIControlEventTouchUpInside];
}

- (void)quitBragGame
{
    NSLog(@"退出游戏");
}

@end
