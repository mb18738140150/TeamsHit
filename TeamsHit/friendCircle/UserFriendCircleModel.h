//
//  UserFriendCircleModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserFriendCircleModel : NSObject

@property (nonatomic, strong)NSNumber * takeId;// 说说id
@property (nonatomic, copy)NSString * takeContent;// 说说内容
@property (nonatomic, strong)NSMutableArray * takeImageArr;
@property (nonatomic, strong)NSNumber * creatTime;

@property (nonatomic, assign)CGFloat height;

@end
