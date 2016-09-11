//
//  FriendCircleMessgaeModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendCircleMessgaeModel : NSObject

@property (nonatomic, strong)NSNumber * TakeId;
@property (nonatomic, copy)NSString * TakeContent;
@property (nonatomic, copy)NSString * TakePhoto;
@property (nonatomic, strong)NSNumber * CreateTime;
@property (nonatomic, strong)NSNumber * IsFavoriteAndComenmt;
@property (nonatomic, copy)NSString * CommentContent;
@property (nonatomic, strong)RCUserInfo * userInfo;
@property (nonatomic, assign)CGFloat commentHeight;

- (id)initWithDictionary:(NSDictionary *)dic;

- (void)calculatecommentHeight;

@end
