//
//  ExchangeBackwallImageViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackWallImageBlock)(UIImage * image);

@interface ExchangeBackwallImageViewController : UIViewController

- (void)getBackWallImage:(BackWallImageBlock)block;

@end
