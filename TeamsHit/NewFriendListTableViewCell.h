//
//  NewFriendListTableViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewFriendModel;

@interface NewFriendListTableViewCell : UITableViewCell

@property (nonatomic, strong)NewFriendModel * nFriendModel;
- (void)createSubView:(CGRect)frame;

@end
