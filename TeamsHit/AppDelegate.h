//
//  AppDelegate.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

