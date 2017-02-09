//
//  BonusPoolModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/16.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FantasyGamerCardInfoModel.h"

@interface BonusPoolModel : NSObject

@property (nonatomic, strong)FantasyGamerCardInfoModel * publiccardInfoModel;
@property (nonatomic, strong)NSNumber * bonus;

@end
