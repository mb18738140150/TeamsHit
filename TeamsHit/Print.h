//
//  Print.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/26.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Print : NSObject

@property (nonatomic, strong)NSNumber * userId;
@property (nonatomic, strong)NSNumber * taskType;

+ (Print *)sharePrint;

- (void)printMaterailImage:(UIImage *)image taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId;
- (void)printImage:(UIImage *)image taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId;
- (void)printText:(NSString *)text taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId  Alignment:(int )alignment;

- (void)printWithArr:(NSArray *)dataArr taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId;
- (void)printditherImage:(UIImage *)image taskType:(NSNumber *)taskType toUserId:(NSNumber *)toUserId;

@end
