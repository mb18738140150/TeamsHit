//
//  FantasyGamerCollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FantasyGamerInfoModel.h"

@interface FantasyGamerCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)FantasyGamerInfoModel * gamerInfoModel;
@property (nonatomic, strong)UICollectionView *cardCollectionView;
- (void)creatSubviews;

@end
