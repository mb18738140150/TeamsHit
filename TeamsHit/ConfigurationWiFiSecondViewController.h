//
//  ConfigurationWiFiSecondViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kNetChangedNotification;

@interface ConfigurationWiFiSecondViewController : UIViewController

@property (nonatomic, copy)NSString * myssid;
@property (nonatomic, copy)NSString * myPassword;

@end
