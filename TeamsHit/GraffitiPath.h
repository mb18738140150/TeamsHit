//
//  GraffitiPath.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraffitiPath : UIBezierPath

+ (instancetype)paintPathWithLineWidth:(CGFloat)width
                              startPoint:(CGPoint)startP;

@end
