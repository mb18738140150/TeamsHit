//
//  TradeDetailTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactiondetailsModel.h"


@interface TradeDetailTableViewCell : UITableViewCell

@property (nonatomic, strong)TransactiondetailsModel * model;

- (void)creatButtomLine;

@end
