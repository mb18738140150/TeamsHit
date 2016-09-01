//
//  PublishCircleOfFriendViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PublishBlock)(WFMessageBody * messageBody);

@interface PublishCircleOfFriendViewController : UIViewController

- (void)publishShuoShuoSuccess:(PublishBlock)publishBlock;

@end
