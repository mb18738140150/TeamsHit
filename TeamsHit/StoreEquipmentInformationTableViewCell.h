//
//  StoreEquipmentInformationTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreEquipmentInfoModel.h"

typedef void(^OperationBlock)(NSString *opetation);


@interface StoreEquipmentInformationTableViewCell : UITableViewCell

@property (nonatomic, strong)StoreEquipmentInfoModel * model;

@property (strong, nonatomic) IBOutlet UIButton *deleteBt;
@property (strong, nonatomic) IBOutlet UILabel *numberLB;
@property (strong, nonatomic) IBOutlet UILabel *equipmentNumberLB;
@property (strong, nonatomic) IBOutlet UIButton *editBT;
@property (strong, nonatomic) IBOutlet UILabel *stateLB;

@property (strong, nonatomic) IBOutlet UILabel *printNumberLB;

@property (nonatomic, copy)OperationBlock Myblock;

- (void)operationAction:(OperationBlock )block;

@end
