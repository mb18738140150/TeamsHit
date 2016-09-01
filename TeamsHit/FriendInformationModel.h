//
//  FriendInformationModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInformationModel : NSObject

@property (nonatomic, copy)NSString * iconUrl;
@property (nonatomic, strong)NSNumber * userId;
@property (nonatomic, copy)NSString * nickName;// 好友昵称
@property (nonatomic, copy)NSString * displayName;// 备注名
@property (nonatomic, copy)NSString * phone;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, strong)NSNumber * isFriend;
@property (nonatomic, strong)NSMutableArray * galleriesList;// 朋友圈图片地址链接数组

- (instancetype)initWithDictionery:(NSDictionary *)dic;

@end
