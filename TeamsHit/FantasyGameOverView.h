//
//  FantasyGameOverView.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FantasyGameOverView : UIView

- (instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)resultGamerInfoArr;

- (void)show;
- (void)dismiss;

@end
