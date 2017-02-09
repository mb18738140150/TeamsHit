//
//  ActivityView.h
//  TeamsHit
//
//  Created by 仙林 on 16/11/16.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * activityView;

@property (nonatomic, copy)NSString * state;

@property (nonatomic, copy)void(^refreshRequest)(ActivityView *sender);

- (BOOL)refresh;
- (void)beginRefreshing;
- (void)endRefreshing;

@end
