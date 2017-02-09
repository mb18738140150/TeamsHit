//
//  FantasyResulttableviewcell.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FantasyGamerInfoModel.h"


@interface FantasyResulttableviewcell : UITableViewCell

@property (nonatomic, strong)FantasyGamerInfoModel * gamerInfoModel;

- (void)creatSubviews;

@end
