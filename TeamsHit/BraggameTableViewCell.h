//
//  BraggameTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BraggameTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UIImageView * resultImageView;

@property (nonatomic, strong)UIImageView * dicecupImageView;
@property (nonatomic, strong)UICollectionView * diceCollection;

- (void)creatCell;

@end
