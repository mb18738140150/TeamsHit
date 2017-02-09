//
//  ChooseDicenumberView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseDiceNumberProtocol <NSObject>

- (void)chooseCompleteWithnumber:(int)number point:(int )point;

@end

@interface ChooseDicenumberView : UIView

@property (nonatomic, assign)id<ChooseDiceNumberProtocol>delegate;
@property (nonatomic, assign)int maxPointCount;
@property (nonatomic, assign)BOOL isOnePoint;
@property (nonatomic, assign)int leaveTime;
// 倒计时
@property (nonatomic, strong)NSTimer * timer;
- (instancetype)initWithFrame:(CGRect)frame withDiceNumber:(int)diceNumber andDicePoint:(int)dicePoint;

- (void)refreshViewWithDiceNumber:(int)diceNumber andDicePoint:(int)dicePoint;

- (void)show;
- (void)dismiss;

@end
