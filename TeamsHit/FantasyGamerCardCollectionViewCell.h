//
//  FantasyGamerCardCollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FantasyGamerCardInfoModel.h"

@interface FantasyGamerCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)FantasyGamerCardInfoModel * gamerCardInfoModel;

- (void)creatSubViews;
- (void)showLosecard;

@end
