//
//  PayhistoryModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayhistoryModel : NSObject

@property (nonatomic, strong)NSNumber * orderTime;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, assign)int  coinCount;
@property (nonatomic, assign)double money;
@property (nonatomic, copy)NSString * payType;
@property (nonatomic, copy)NSString * orderState;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
