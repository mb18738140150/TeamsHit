//
//  RCDContactTableViewCell.h
//  RCloudMessage
//
//  Created by Jue on 16/3/16.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(BOOL isSelect);

@interface RCDContactTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portraitView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UIButton * selectStateBT;

- (void)getSelectState:(SelectBlock)selectBlock;

@end
