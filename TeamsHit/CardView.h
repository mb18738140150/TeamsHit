//
//  CardView.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FantasyGamerCardInfoModel.h"
@interface CardView : UIView

//@property (nonatomic, )
@property (nonatomic, strong)FantasyGamerCardInfoModel * cardModel;
@property (nonatomic, strong)UIView * mengbanView;

@end
