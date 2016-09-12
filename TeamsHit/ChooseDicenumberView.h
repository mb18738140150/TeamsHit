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

- (instancetype)initWithFrame:(CGRect)frame withDiceNumber:(int)diceNumber andDicePoint:(int)dicePoint;
- (void)show;

@end
