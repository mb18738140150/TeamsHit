//
//  BuyCoinsViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BuyCoinBlock)(BOOL haveBuy);

@interface BuyCoinsViewController : UIViewController

- (void)haveBuyCoins:(BuyCoinBlock)block;

@end
