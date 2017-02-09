//
//  FantasyGamerInfoModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum:NSInteger {
    ExchangeCardType_nomal = 0,
    ExchangeCardType_no = 1,// 不换
    ExchangeCardType_private = 2,// 换底牌
    ExchangeCardType_public = 3,// 换公牌
    ExchangeCardType_Wait = 4,// 等待中iswin
}ExchangeCardType;

typedef enum :NSInteger
{
    IsWinTheFantasyGame_nomal = 0,
    IsWinTheFantasyGame_win = 1,
    IsWinTheFantasyGame_lose = 2,
}IsWinTheFantasyGame;

@interface FantasyGamerInfoModel : NSObject

@property (nonatomic, strong)RCUserInfo * gameUserInfo;
@property (nonatomic, assign)BOOL isFinish;
@property (nonatomic, assign)ExchangeCardType exchangeCardType;
@property (nonatomic, assign)IsWinTheFantasyGame isWin;
@property (nonatomic, assign)BOOL isUserself;
@property (nonatomic, assign)int winCoins;
@property (nonatomic, strong)NSMutableArray * cardInfoArr;// 存储卡牌信息

@end
