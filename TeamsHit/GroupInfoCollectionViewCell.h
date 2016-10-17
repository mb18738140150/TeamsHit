//
//  GroupInfoCollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupInfoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * tipLabel;
@property (nonatomic, strong)UIView * tipView;
- (void)creatUI;

@end
