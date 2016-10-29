//
//  MaterialDetailViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ MaterialDetailBlock)(UIImage * image);
@interface MaterialDetailViewController : UIViewController

@property (nonatomic, strong)NSNumber * userId;
@property (nonatomic, assign)BOOL isOtnerVc;
- (void)getMaterialDetailImage:(MaterialDetailBlock)materialDetailImage;

@end
