//
//  FantasygamerLayout.h
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FantasygamerLayout : UICollectionViewLayout

// 每一个item的宽度
@property (nonatomic , assign) CGFloat itemWidth;
// 集合视图分区的内边框
@property (nonatomic , assign) UIEdgeInsets sectionIndets;
// 每两个item之间的间距
@property (nonatomic , assign) CGFloat interitemSpacing;

@end
