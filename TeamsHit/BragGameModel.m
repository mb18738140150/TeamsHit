//
//  BragGameModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BragGameModel.h"

@implementation BragGameModel

- (NSMutableArray *)dicePointArr
{
    if (!_dicePointArr) {
        self.dicePointArr = [NSMutableArray array];
    }
    return _dicePointArr;
}

- (NSMutableArray *)showDicePointArr
{
    if (!_showDicePointArr) {
        self.showDicePointArr = [NSMutableArray array];
    }
    return _showDicePointArr;
}

@end
