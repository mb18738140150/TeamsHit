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
@property (nonatomic, copy)NSString * nickName;
@property (nonatomic, copy)NSString * remark;
@property (nonatomic, copy)NSString * phone;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, strong)NSNumber * isFriend;
@property (nonatomic, strong)NSArray * galleryList;

- (instancetype)initWithDictionery:(NSDictionary *)dic;

@end
