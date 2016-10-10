//
//  SearchGroupListModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGroupListModel : NSObject

@property (nonatomic, copy)NSString * groupIconUrl;
@property (nonatomic, strong)NSNumber * GroupId;
@property (nonatomic, strong)NSNumber * GroupPeople;
@property (nonatomic, copy)NSString * groupIntro;
@property (nonatomic, copy)NSString * GroupName;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
