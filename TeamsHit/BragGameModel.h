//
//  BragGameModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: NSInteger
{
    ChooseCallOrOpen_Nomal = 0,
    ChooseCallOrOpen_Call = 1,
    ChooseCallOrOpen_Open = 2,
}ChooseCallOrOpenType;// 叫点或开人选择状态

typedef enum:NSInteger {
    CalledDicePoint_Pass = 0,
    CalledDicePoint_Now = 1,
    CalledDicePoint_Wait = 2,
}CalledDicePointState; // 叫点状态

typedef enum :NSInteger
{
    IsWinTheGame_nomal = 0,
    IsWinTheGame_win = 1,
    IsWinTheGame_lose = 2,
}IsWinTheGame;

@interface BragGameModel : NSObject

@property (nonatomic, strong)RCUserInfo * gameUserInfo;
@property (nonatomic, assign)BOOL isFinish;
@property (nonatomic, assign)IsWinTheGame isWin;// 是否赢了
@property (nonatomic, assign)BOOL isUserself; // 是否是玩家自己的数据
@property (nonatomic, assign)CalledDicePointState calledDicePointState;
@property (nonatomic, copy)NSString * callContent;// 叫的骰子内容
@property (nonatomic, strong)NSNumber * diceCount;
@property (nonatomic, strong)NSNumber * dicePoint;
@property (nonatomic, strong)NSMutableArray * dicePointArr;// 用户摇到的骰子点数，存贮骰子点数
@property (nonatomic, strong)NSMutableArray * showDicePointArr;// 骰子展示数组,用来存放显示骰子时骰子的图片名
@property (nonatomic, assign)BOOL isShakeDiceCup;// 是否已经摇过骰盅
@property (nonatomic, assign)ChooseCallOrOpenType choosecallOrOpenType;

@property (nonatomic, assign)int userWinPointCount;

@end
