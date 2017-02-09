//
//  ShuoShuoCommentTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/1/11.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFReplyBody.h"
#import "WFTextView.h"

@protocol shuoshuocellDelegate <NSObject>
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
- (void)clickUserName:(NSString *)userId;

@end

@interface ShuoShuoCommentTableViewCell : UITableViewCell<WFCoretextDelegate>

@property (nonatomic, strong)WFReplyBody * replyBody;
@property (nonatomic,assign) id<shuoshuocellDelegate> delegate;
- (void)creatSubViews;
+(CGFloat)getcommentcellHeight:(WFReplyBody *)replyBody;

@end
