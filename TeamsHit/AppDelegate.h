//
//  AppDelegate.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

