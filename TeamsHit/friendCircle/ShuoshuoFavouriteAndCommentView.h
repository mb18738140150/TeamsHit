//
//  ShuoshuoFavouriteAndCommentView.h
//  TeamsHit
//
//  Created by 仙林 on 17/1/11.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTextData.h"
#import "WFReplyBody.h"

@protocol shuoshuoviewDelegate <NSObject>
- (void)clickRichText:(WFReplyBody *)replyBody index:(NSInteger)index;
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
- (void)viewclickUserName:(NSString *)userId;

@end

@interface ShuoshuoFavouriteAndCommentView : UIView

@property (nonatomic,assign) id<shuoshuoviewDelegate> delegate;

@property (nonatomic, assign)CGFloat viewHeight;

- (instancetype)initWithFrame:(CGRect)frame withData:(YMTextData *)ymdata;

- (void)refreshUIWith:(YMTextData *)ymdata;

@end
