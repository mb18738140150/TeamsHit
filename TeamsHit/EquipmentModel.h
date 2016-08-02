//
//  EquipmentModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentModel : NSObject

@property (nonatomic, copy)NSString * equipmentTitle;
@property (nonatomic, strong)NSNumber *buzzer;
@property (nonatomic, strong)NSNumber *indicatorLight;
@property (nonatomic, strong)NSNumber * state;

@end
