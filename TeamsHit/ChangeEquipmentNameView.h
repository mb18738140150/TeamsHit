//
//  ChangeEquipmentNameView.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EquipmentNameBlock)(NSString * name);

@interface ChangeEquipmentNameView : UIView
@property (strong, nonatomic) IBOutlet UITextField *equipmentNameTF;
@property (strong, nonatomic) IBOutlet UIButton *changeBT;
@property (strong, nonatomic) IBOutlet UIButton *cancleBT;
- (void)getEquipmentOption:(EquipmentNameBlock)equipmentBlock;
@end
