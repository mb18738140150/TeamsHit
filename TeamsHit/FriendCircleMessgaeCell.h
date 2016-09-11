//
//  FriendCircleMessgaeCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendCircleMessgaeModel;


UIKIT_EXTERN NSString * const KFriendCircleMessgaeCellIdentifire;
@interface FriendCircleMessgaeCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *commentUserIcon;
@property (strong, nonatomic)  UILabel *commentUserNameLabel;
@property (strong, nonatomic)  UILabel *commentContentLabel;
@property (strong, nonatomic)  UILabel *commentTimeLabel;

@property (strong, nonatomic)  UILabel *takeContentLabel;
@property (strong, nonatomic)  UIImageView *takeImageIcon;

@property (nonatomic, strong)FriendCircleMessgaeModel * model;
@property (strong, nonatomic)  UIImageView *likeImageView;

- (void)creatcellUIwith:(CGRect)rect;

@end
