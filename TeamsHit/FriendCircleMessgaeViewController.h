//
//  FriendCircleMessgaeViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NoreadBlock)();
@interface FriendCircleMessgaeViewController : UIViewController

- (void)noreadAction:(NoreadBlock)block;

@end
