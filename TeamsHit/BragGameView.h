//
//  BragGameView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BragGameViewProtocol <NSObject>

- (void)bragShakeDIceCup;
- (void)bragReshakeCup;
- (void)bragCompleteShakeDiceCup;
- (void)bragChooseCompleteWithnumber:(int)number point:(int )point;

@end

@interface BragGameView : UIView

@property (nonatomic, assign)id<BragGameViewProtocol>delegate;
@property (nonatomic, strong)UITableView * gametableView;
@property (nonatomic, strong)UITableView * scoreTableView;

- (void)begainState;

@end
