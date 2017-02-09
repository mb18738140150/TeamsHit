//
//  GroupDetailViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QuitGroupBlock)();

@interface GroupDetailViewController : UIViewController

@property (nonatomic, copy)NSString * groupID;
- (void)quitGameRoom:(QuitGroupBlock)block;
@end
