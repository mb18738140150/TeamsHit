//
//  GraffitiDrawView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraffitiDrawView : UIView

@property (nonatomic, assign)CGFloat width;//接收线宽
@property (nonatomic, strong)UIColor * lineColor;// 接收颜色


/**
 *  清屏
 */
- (void)clearScreen;

/**
 *  撤销
 */
- (void)undo;


@property (nonatomic, assign)BOOL isEraser;

@end
