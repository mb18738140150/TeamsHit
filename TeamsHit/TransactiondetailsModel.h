//
//  TradeDetailModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactiondetailsModel : NSObject

@property (nonatomic, copy) NSString * tradeTitle;
@property (nonatomic, strong)NSNumber * tradeTime;
@property (nonatomic, strong)NSNumber * tradeCoinCount;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
