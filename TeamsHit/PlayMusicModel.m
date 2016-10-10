//
//  PlayMusicModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PlayMusicModel.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayMusicModel()
{
    AVAudioPlayer *player;
}
@end

@implementation PlayMusicModel

+(PlayMusicModel *)share
{
    static PlayMusicModel * model = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[PlayMusicModel alloc]init];
    });
    return model;
    
}

- (void)playMusicWithName:(NSString *)name
{
    
    NSString * filePath = [[NSBundle mainBundle]pathForResource:name ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player play];
}
@end
