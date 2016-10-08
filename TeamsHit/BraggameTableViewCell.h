//
//  BraggameTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BragGameModel.h"
#import "CallDicePointStateView.h"
typedef void(^ChooseDicepointCallOrOpenBlock)(NSString * string);

@interface BraggameTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UIImageView * resultImageView;// 游戏结果展示图片

@property (nonatomic, strong)CallDicePointStateView * calldicePointStateView;// 骰子叫点state button
@property (nonatomic, strong)UIButton * chooseDicecallTypeBT;// 叫点或者开Type button

@property (nonatomic, strong)UIImageView * dicecupImageView;
@property (nonatomic, strong)UICollectionView * diceCollection;

@property (nonatomic, strong)BragGameModel * bragGameModel;

- (void)creatCell;

- (void)getchooseDicepointCallOrOpen:(ChooseDicepointCallOrOpenBlock)block;

@end
