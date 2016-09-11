//
//  GameRuleModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameRuleModel : NSObject

@property (nonatomic, assign)int number;
@property (nonatomic, copy)NSString * content;
@property (nonatomic, assign)CGFloat height;

- (void)getcontentHeightWithWidth:(CGFloat)width;

@end
