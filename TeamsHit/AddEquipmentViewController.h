//
//  AddEquipmentViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshDeviceList)();

@interface AddEquipmentViewController : UIViewController

- (void)refreshDeviceData:(RefreshDeviceList)refreshDeviceData;

@end
