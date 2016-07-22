//
//  GraffitiView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraffitiView : UIView

@property (nonatomic, strong)UIImage * image;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (UIImage *)getGraffitiImage;

@end
