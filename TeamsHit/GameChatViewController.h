//
//  GameChatViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface GameChatViewController : RCConversationViewController
/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;

@property BOOL needPopToRootView;
@end
