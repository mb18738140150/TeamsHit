//
//  CoindetailViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BuyCoinsBlock)(NSString * coinCount);

@interface CoindetailViewController : UIViewController

@property (nonatomic, copy)NSString * cointCount;
- (void)BuyCoins:(BuyCoinsBlock)block;
@end
