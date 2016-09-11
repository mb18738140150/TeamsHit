//
//  GameRulesTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameRulesTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * numberlabel;
@property (nonatomic, strong)UILabel * contentLabel;

- (void)creatCellWithFrame:(CGRect)frame;

@end
