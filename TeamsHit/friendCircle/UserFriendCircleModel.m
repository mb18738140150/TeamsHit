//
//  UserFriendCircleModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "UserFriendCircleModel.h"

@implementation UserFriendCircleModel

- (NSMutableArray *)takeImageArr
{
    if (!_takeImageArr) {
        _takeImageArr = [NSMutableArray array];
    }
    return _takeImageArr;
}

- (void)setTakeContent:(NSString *)takeContent
{
    _takeContent = takeContent;
    
    if (self.takeImageArr.count > 0) {
        self.height = 123.0;
    }else
    {
        CGSize size = [takeContent boundingRectWithSize:CGSizeMake(screenWidth - 21 - 72, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        if (size.height > 61) {
            self.height = 61 + 63;
        }else
        {
            self.height = 63 + size.height;
        }
        
    }
    
}

@end
