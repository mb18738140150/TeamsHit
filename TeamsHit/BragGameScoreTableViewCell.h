//
//  BragGameScoreTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BragGameScoreTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * numberLabel;
@property (nonatomic, assign)BOOL iswin;
@property (nonatomic, strong)UIImageView * winImageView;

@end
