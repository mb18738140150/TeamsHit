//
//  NewFriendModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFriendModel : NSObject

@property (nonatomic, copy)NSString * iconImageUrl;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * detaile;
@property (nonatomic, strong)NSNumber * state;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
