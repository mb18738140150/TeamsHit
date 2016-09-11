//
//  DiceCupView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TipDiceCupProtocol <NSObject>

- (void)tipDiceCup;

@end

@interface DiceCupView : UIView

@property (nonatomic, strong)UIView * tipDiceCupView;

@property (nonatomic, strong)UIView * diceCuptipResultView;

@property (nonatomic, assign)id<TipDiceCupProtocol>delegete;

- (instancetype)initWithFrame:(CGRect)frame;

@end
