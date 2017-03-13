//
//  PrintOrderModel.h
//  TeamsHit
//
//  Created by 仙林 on 17/3/10.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum:NSInteger {
    Print_Nomal = 0,
    Print_NOSelect = 1,
    Print_Select = 2,
}PrintOrderType;

@interface PrintOrderModel : NSObject

@property (nonatomic, assign)long taskNumber;
@property (nonatomic, assign)long time;
@property (nonatomic, copy)NSString * orderNumber;
@property (nonatomic, copy)NSString * receiver;

@property (nonatomic, assign)PrintOrderType printOrderType;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
