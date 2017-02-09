//
//  FantasyGamerInfoModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyGamerInfoModel.h"

@implementation FantasyGamerInfoModel

- (NSMutableArray *)cardInfoArr
{
    if (!_cardInfoArr) {
        self.cardInfoArr = [NSMutableArray array];
    }
    return _cardInfoArr;
}

@end
