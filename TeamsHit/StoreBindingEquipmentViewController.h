//
//  StoreBindingEquipmentViewController.h
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddDeviceBlock)();

@interface StoreBindingEquipmentViewController : UIViewController
@property (nonatomic, assign)long account;
@property (nonatomic, assign)int type;
@property (nonatomic, copy)AddDeviceBlock myBlock;

- (void)addDeviceAction:(AddDeviceBlock)block;

@end
