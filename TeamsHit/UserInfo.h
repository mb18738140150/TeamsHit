//
//  UserInfo.h
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
+ (UserInfo *)shareUserInfo;

@property (nonatomic, copy)NSString * userToken;
@property (nonatomic, copy)NSString * rongToken;
@property (nonatomic, copy)NSString * timeStr;
- (void)setUserInfoWithDictionary:(NSDictionary *)dic;
@end
