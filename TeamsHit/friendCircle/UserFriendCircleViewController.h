//
//  UserFriendCircleViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExchangeWallImageBlock)(UIImage * image);

@interface UserFriendCircleViewController : UIViewController

@property (nonatomic, strong)NSNumber *userId;

- (void)exchangeWallImage:(ExchangeWallImageBlock)block;
@end
