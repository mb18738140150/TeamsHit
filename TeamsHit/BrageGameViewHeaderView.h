//
//  BrageGameViewHeaderView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrageGameViewHeaderViewProtocol <NSObject>

- (void)setUpGameChatGroup;

@end

@interface BrageGameViewHeaderView : UIView

@property (nonatomic, strong)UILabel * timeLB;
@property (nonatomic, strong)UILabel * timeLabel;

@property (nonatomic, strong)UIView * view1;
@property (nonatomic, strong)UIView * view2;

@property (nonatomic, strong)UILabel * typeLabel;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIButton * setUpBT;

@property (nonatomic, assign) id<BrageGameViewHeaderViewProtocol> delegete;

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type title:(NSString *)title;



@end
