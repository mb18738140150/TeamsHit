//
//  CreatGroupChatRoomViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddGroupMumberBlock)();

@interface CreatGroupChatRoomViewController : UIViewController

@property (nonatomic, copy)AddGroupMumberBlock myBlock;
@property (nonatomic, copy)NSString * targetId;
@property (nonatomic, copy)NSString * groupID;
- (void)addgroupMumberAction:(AddGroupMumberBlock)block;
@end
