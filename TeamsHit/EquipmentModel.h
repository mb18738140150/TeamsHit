//
//  EquipmentModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentModel : NSObject

@property (nonatomic, copy)NSString * uuid;
@property (nonatomic, copy)NSString * deviceName;
@property (nonatomic, strong)NSNumber *buzzer;
@property (nonatomic, strong)NSNumber *indicator;
@property (nonatomic, strong)NSNumber * state;
@property (nonatomic, copy)NSString * deviceMac;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
