//
//  ChatSettingViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInformationModel;
@interface ChatSettingViewController : UIViewController

@property (nonatomic, strong)FriendInformationModel * model;
@property (nonatomic, strong) NSString *userId;

@end
