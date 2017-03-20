//
//  TeamHitBarButtonItem.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamHitBarButtonItem : UIButton

+ (instancetype)leftButtonWithImage:(UIImage *)image;

+(instancetype)leftButtonWithImage:(UIImage *)image title:(NSString *)title;

+ (instancetype)rightButtonWithImage:(UIImage *)image;

+ (instancetype)rightButtonWithTitle:(NSString *)title;

+ (instancetype)rightButtonWithTitle:(NSString *)title backgroundcolor:(UIColor *)color cornerRadio:(CGFloat)cornerRadius;

+(instancetype)rightButtonWithImage:(UIImage *)image title:(NSString *)title;
+(instancetype)leftButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)color;
@end
