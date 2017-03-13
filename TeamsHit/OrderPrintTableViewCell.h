//
//  OrderPrintTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/3/10.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PrintOrderModel.h"

@interface OrderPrintTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;
@property (strong, nonatomic) IBOutlet UILabel *recieverNameLB;
@property (strong, nonatomic) IBOutlet UILabel *printTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *orderNumber;

@property (nonatomic, strong)PrintOrderModel * model;

@end
