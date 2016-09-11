//
//  FriendCircleMessgaeModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FriendCircleMessgaeModel.h"


@implementation FriendCircleMessgaeModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"User"]) {
        self.userInfo = [RCUserInfo new];
        _userInfo.userId = [NSString stringWithFormat:@"%@", [value objectForKey:@"UserId"]];
        _userInfo.name = [value objectForKey:@"DisplayName"];
        _userInfo.portraitUri = [value objectForKey:@"PortraitUri"];
    }
}

- (void)calculatecommentHeight
{
    if (self.CommentContent && self.CommentContent.length != 0) {
        CGSize size = [self.CommentContent boundingRectWithSize:CGSizeMake(CommentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        self.commentHeight = size.height;
    }else
    {
        self.commentHeight = 15;
    }
}

@end
