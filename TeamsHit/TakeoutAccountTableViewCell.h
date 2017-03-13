//
//  TakeoutAccountTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QuickloginBlock)();

@interface TakeoutAccountTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *takeoutAccountLabel;
@property (strong, nonatomic) IBOutlet UILabel *takeoutTyoeLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginBT;

@property (nonatomic, copy) NSString * takeouttypename;
@property (nonatomic, copy)QuickloginBlock myBlock;

- (void)quickLogin:(QuickloginBlock)block;

@end
