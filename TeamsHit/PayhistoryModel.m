//
//  PayhistoryModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PayhistoryModel.h"

@implementation PayhistoryModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
