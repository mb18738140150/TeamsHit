//
//  TeamHitBarButtonItem.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TeamHitBarButtonItem.h"

@implementation TeamHitBarButtonItem

+ (instancetype)leftButtonWithImage:(UIImage *)image
{
    TeamHitBarButtonItem * barButtonItem = [super buttonWithType:UIButtonTypeSystem];
    barButtonItem.frame = CGRectMake(0, 0, 120, 27);
    [barButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    return barButtonItem;
}

+(instancetype)leftButtonWithImage:(UIImage *)image title:(NSString *)title
{
    TeamHitBarButtonItem * barButtonItem = [super buttonWithType:UIButtonTypeSystem];
    CGSize buttontitleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    barButtonItem.frame = CGRectMake(0, 0, buttontitleSize.width + 45, 33);
    [barButtonItem setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [barButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [barButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    [barButtonItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateNormal];
    [barButtonItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateHighlighted];
    [barButtonItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateSelected];
    //按钮字体颜色默认为白色
//    barButtonItem.tintColor = UIColorFromRGB(0x323232);
    barButtonItem.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    
    return barButtonItem;
}

+(instancetype)leftButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)color
{
    TeamHitBarButtonItem * barButtonItem = [super buttonWithType:UIButtonTypeSystem];
    CGSize buttontitleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    barButtonItem.frame = CGRectMake(0, 0, buttontitleSize.width + 45, 33);
    [barButtonItem setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [barButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [barButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    [barButtonItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateNormal];
    [barButtonItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateHighlighted];
    [barButtonItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateSelected];
    //按钮字体颜色默认为白色
    [barButtonItem setTitleColor:color forState:UIControlStateNormal];
    barButtonItem.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    return barButtonItem;
}

+ (instancetype)rightButtonWithImage:(UIImage *)image
{
    TeamHitBarButtonItem * barButtonItem = [super buttonWithType:UIButtonTypeSystem];
    barButtonItem.frame = CGRectMake(0, 0, 30, 30);
    barButtonItem.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [barButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    return barButtonItem;
}

+ (instancetype)rightButtonWithTitle:(NSString *)title
{
    TeamHitBarButtonItem * barButtonItem = [super buttonWithType:UIButtonTypeSystem];
    CGSize buttontitleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    barButtonItem.frame = CGRectMake(0, 0, buttontitleSize.width, 33);
    
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    //按钮字体颜色默认为白色
    barButtonItem.tintColor = UIColorFromRGB(0x323232);
    barButtonItem.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    
    return barButtonItem;
}

+ (instancetype)rightButtonWithTitle:(NSString *)title backgroundcolor:(UIColor *)color cornerRadio:(CGFloat)cornerRadius
{
    TeamHitBarButtonItem * barButtonItem = [super buttonWithType:UIButtonTypeCustom];
    CGSize buttontitleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    barButtonItem.frame = CGRectMake(0, 0, buttontitleSize.width + 10, 33);
    barButtonItem.layer.cornerRadius = cornerRadius;
    barButtonItem.layer.masksToBounds = YES;
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    //按钮字体颜色默认为白色
    [barButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    barButtonItem.backgroundColor = color;
    barButtonItem.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    
    return barButtonItem;
}

+(instancetype)rightButtonWithImage:(UIImage *)image title:(NSString *)title
{
    TeamHitBarButtonItem * barButtonItem = [super buttonWithType:UIButtonTypeSystem];
    CGSize buttontitleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    barButtonItem.frame = CGRectMake(0, 0, buttontitleSize.width + 15, 33);
    
    [barButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    [barButtonItem setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [barButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    //按钮字体颜色默认为白色
    [barButtonItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateNormal]  ;
    barButtonItem.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    
    return barButtonItem;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
