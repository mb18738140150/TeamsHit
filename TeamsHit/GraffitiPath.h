//
//  GraffitiPath.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraffitiPath : UIBezierPath

/**
 
 颜色属性
 专门用来存放当前路径自己的颜色
 */
@property (nonatomic, strong)UIColor * lineColor;

@property (nonatomic, assign)BOOL isEraser;

@end
