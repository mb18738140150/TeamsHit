//
//  WFMessageBody.h
//  WFCoretext
//
//  Created by 阿虎 on 15/4/28.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFReplyBody : NSObject

/**
 *  评论者
 */
@property (nonatomic,copy) NSString *replyUser;

@property (nonatomic, strong)RCUserInfo *replyUserInfo;

/**
 *  回复该评论者的人
 */
@property (nonatomic,copy) NSString *repliedUser;

@property (nonatomic, strong)RCUserInfo *repliedUserInfo;

/**
 *  回复内容
 */
@property (nonatomic,copy) NSString *replyInfo;

@property (nonatomic, copy)NSNumber * commentId;

@end
