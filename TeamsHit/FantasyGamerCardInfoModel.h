//
//  FantasyGamerCardInfoModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum:NSInteger {
    FantasyCardColor_side = 1,
    FantasyCardColor_plumblossom = 2,
    FantasyCardColor_hearts = 3,
    FantasyCardColor_spade = 4,
}FantasyCardColor;

@interface FantasyGamerCardInfoModel : NSObject

@property (nonatomic, copy)NSString * cardNumber;
@property (nonatomic, assign)FantasyCardColor fantasyCardColor;

@end
