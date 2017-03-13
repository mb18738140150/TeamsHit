//
//  ConcentrationlistView.h
//  TeamsHit
//
//  Created by 仙林 on 17/3/10.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModifyConcentration)(int concentrationNum);

@interface ConcentrationlistView : UIView

@property (nonatomic, assign)int concentrationNum;

- (instancetype)initWithFrame:(CGRect)frame with:(int)concentrationNum;
- (void)modifyConcentration:(ModifyConcentration)Block;
- (void)show;
- (void)dismiss;

@end
