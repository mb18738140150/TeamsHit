//
//  WelPageControl.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelPageControl : UIPageControl
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;

@end
