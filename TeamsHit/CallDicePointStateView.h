//
//  CallDicePointStateView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallDicePointStateView : UIView

@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)UILabel * contentLabel;
@property (nonatomic, strong)UIImageView * dicePointImageView;

@property (nonatomic, copy)NSString * content;
@property (nonatomic, strong)UIImage * dicePointImage;

@end
