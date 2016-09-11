//
//  GameRuleModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GameRuleModel.h"

@implementation GameRuleModel

- (void)getcontentHeightWithWidth:(CGFloat)width
{
    self.height = [self.content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
}

@end
