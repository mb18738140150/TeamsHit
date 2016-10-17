//
//  GameChatViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "BrageGameViewHeaderView.h"

@interface GameChatViewController : RCConversationViewController
{
    SRWebSocket *_webSocket;
}
@property (nonatomic, strong)UIImageView * backImageView;

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;
@property (nonatomic, strong)BrageGameViewHeaderView * headerView;
@property BOOL needPopToRootView;
@end
