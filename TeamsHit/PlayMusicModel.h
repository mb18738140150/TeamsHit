//
//  PlayMusicModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayMusicModel : NSObject
+(PlayMusicModel *)share;
- (void)playMusicWithName:(NSString *)name;
- (void)playMusicWithName:(NSString *)name type:(NSString *)type;
@end
