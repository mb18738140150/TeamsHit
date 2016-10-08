//
//  SlideBlockView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoveConversationViewBlockResignFirstResponse)();
typedef void(^MoveConversationViewBlock)(CGPoint point);

@interface SlideBlockView : UIView


@property (nonatomic , assign) CGPoint beginPoint;
@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, copy)MoveConversationViewBlock myBlock;
@property (nonatomic, copy)MoveConversationViewBlockResignFirstResponse myresignBlock;

- (void)moveSlideBlock:(MoveConversationViewBlock)block;
- (void)resignBlock:(MoveConversationViewBlockResignFirstResponse)block;

@end
