//
//  EquipmentTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EquipmentModel;
typedef void(^EquipmentTypeBlock)(NSInteger type);

@interface EquipmentTableViewCell : UITableViewCell

@property (nonatomic, strong)EquipmentModel *emodel;
- (void)createSubView:(CGRect)frame;
- (void)getEquipmentOption:(EquipmentTypeBlock)equipmentBlock;

@end
