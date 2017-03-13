//
//  SigninModel.h
//  TeamsHit
//
//  Created by 仙林 on 17/3/2.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigninModel : NSObject

@property (nonatomic, assign)int MonthToDay;
@property (nonatomic, assign)int conSignDay;

- (id)initWithDic:(NSDictionary *)dic;

@end
