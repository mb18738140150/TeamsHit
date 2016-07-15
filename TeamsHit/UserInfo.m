//
//  UserInfo.m
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (UserInfo *)shareUserInfo
{
    static UserInfo * userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc] init];
    });
    return userInfo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setUserInfoWithDictionary:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
