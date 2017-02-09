//
//  FriendInformationViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInformationModel;
typedef void(^ChangeDisplayNamedetail)(NSString * displayName);

@interface FriendInformationViewController : UIViewController

@property (nonatomic, strong)FriendInformationModel * model;
@property (nonatomic, copy)NSString * targetId;
@property (nonatomic, assign)int IsPhoneNumber;

- (void)changeDisplayname:(ChangeDisplayNamedetail )block;
@end
