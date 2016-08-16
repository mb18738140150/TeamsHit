//
//  NewFriendModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFriendModel : NSObject

@property (nonatomic, copy)NSString * portraitUri;
@property (nonatomic, copy)NSString * nickname;
@property (nonatomic, copy)NSString * message;
@property (nonatomic, strong)NSNumber * status;
@property (nonatomic, copy)NSNumber * userId;
@property (nonatomic, strong)NSNumber * applyId;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
