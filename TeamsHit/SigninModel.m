//
//  SigninModel.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/2.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "SigninModel.h"

@implementation SigninModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
