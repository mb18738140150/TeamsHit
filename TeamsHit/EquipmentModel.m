//
//  EquipmentModel.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "EquipmentModel.h"

@implementation EquipmentModel

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
    
}

@end
