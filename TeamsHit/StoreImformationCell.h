//
//  StoreImformationCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/2/27.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreinformationModel.h"

typedef void(^AutoReceiveBlock)( int type);

@interface StoreImformationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *storeuserName;
@property (strong, nonatomic) IBOutlet UILabel *storeNameLB;
@property (strong, nonatomic) IBOutlet UILabel *storeidLB;
@property (strong, nonatomic) IBOutlet UIButton *autoReciveorderBT;

@property (strong, nonatomic) IBOutlet UIView *printHistoryView;


@property (nonatomic, strong)StoreinformationModel * model;

@property (nonatomic, copy)AutoReceiveBlock myBlock;

- (void)autoReceiveOrderAction:(AutoReceiveBlock)block;

@end
