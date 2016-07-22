//
//  GraffitiDrawView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraffitiDrawView : UIView

@property (nonatomic, assign)CGFloat width;
@property (nonatomic, strong)UIColor * lineColor;

/**
 *  撤销的线条数组
 */
@property (nonatomic, strong)NSMutableArray * canceledLines;
/**
 *  线条数组
 */
@property (nonatomic, strong)NSMutableArray * lines;

/**
 *  清屏
 */
- (void)clearScreen;

/**
 *  撤销
 */
- (void)undo;

/**
 *  恢复
 */
- (void)redo;

@end
