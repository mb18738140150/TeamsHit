//
//  FriendDetailDataSettingViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInformationModel;

typedef void(^ChangeDisplayName)(NSString * displayName);

@interface FriendDetailDataSettingViewController : UIViewController

@property (nonatomic, strong)FriendInformationModel * model;
- (void)changeDisplayname:(ChangeDisplayName )block;

@end
