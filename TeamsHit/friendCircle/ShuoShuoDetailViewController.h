//
//  ShuoShuoDetailViewController.h
//  TeamsHit
//
//  Created by 仙林 on 17/1/11.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^delateShuoShuo)(NSString * typy);

@interface ShuoShuoDetailViewController : UIViewController

@property (nonatomic, strong)NSNumber * takeId;
@property (nonatomic, strong)RCUserInfo * shuoshuoUserInfo;
- (void)deleteshuoshuoBlock:(delateShuoShuo)block;

@end
