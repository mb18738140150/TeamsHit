//
//  SearcgGroupListCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchGroupListModel;

@interface SearcgGroupListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *groupNamelabel;
@property (strong, nonatomic) IBOutlet UILabel *groupDetailes;
@property (strong, nonatomic) IBOutlet UILabel *numberOfGroup;

@property (nonatomic, strong)RCDGroupInfo * model;

@end
