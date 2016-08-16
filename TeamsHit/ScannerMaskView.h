//
//  ScannerMaskView.h
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScannerMaskView : UIView

/// 使用裁切区域实例化遮罩视图
///
/// @param frame    视图区域
/// @param cropRect 裁切区域
///
/// @return 遮罩视图
+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect;

/// 裁切区域
@property (nonatomic) CGRect cropRect;

@end
