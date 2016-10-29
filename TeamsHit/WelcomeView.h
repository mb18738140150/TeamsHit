//
//  WelcomeView.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelPageControl.h"
@interface WelcomeView : UIView<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView *myScrollView;

@property (nonatomic , strong) WelPageControl *myPageControl;
@property (nonatomic, strong)UIButton * experiencebutton;
@end
