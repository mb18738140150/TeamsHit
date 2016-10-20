//
//  UserFrienfCircleCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFriendCircleModel.h"
@interface UserFrienfCircleCell : UITableViewCell

@property (nonatomic, strong)UserFriendCircleModel * model;

- (void)creatcontantViewWith:(UserFriendCircleModel *)model;


@end
