//
//  FantasyPublishCollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusPoolModel.h"

@interface FantasyPublishCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIButton * changePublicCardBT;
@property (nonatomic, strong)UIButton * changePrivateCardBT;
@property (nonatomic, strong)UIButton * noChangeCardBT;
@property (nonatomic, strong)UILabel * bonusLabel;
@property (nonatomic, strong)BonusPoolModel * bonusModel;

- (void)creatSubviews;
- (void)hideOperationBT;

@end
