//
//  DIcePointAndCountCollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseDiceModel.h"

@interface DIcePointAndCountCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UILabel * diceCountLabel;
@property (nonatomic, strong)UIView * dicePointView;
@property (nonatomic, strong)UIImageView * dicePointImageView;
@property (nonatomic, strong)ChooseDiceModel * chooseDiceModel;

@end
