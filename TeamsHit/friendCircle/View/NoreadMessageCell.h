//
//  NoreadMessageCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const KNoreadFriendCircleMessgaeCellIdentifire;
@interface NoreadMessageCell : UITableViewCell

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * numberLabel;

- (void)creatCellWithFrame:(CGRect)rect;

@end
