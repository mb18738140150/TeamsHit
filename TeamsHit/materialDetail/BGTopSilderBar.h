//
//  BGTopSilderBar.h
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"
//平常状态的颜色
#define NormalColor color(50,50,50,1.0)
//被选中状态的颜色
#define SelectedColor color(18,183,245,1.0)
//下划线的颜色
#define UnderlineColor color(18,183,245,1.0)
//设置一页标题item有几个,默认6个
#define itemNum 4
#define ItemHeight 50

@protocol TopsliderBarSelectDelegate <NSObject>

- (void)selectItem:(int)item;

@end

@interface BGTopSilderBar : UIView

@property(nonatomic,weak)UICollectionView* contentCollectionView;
@property(nonatomic,assign)CGFloat underlineX;//下划线的x轴距离
@property(nonatomic,assign)CGFloat underlineWidth;//下划线的宽度
@property (nonatomic, assign)id <TopsliderBarSelectDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame andItemTitleArr:(NSArray *)itemArr;
/**
 从某个item移动到另一个item
 */
-(void)setItemColorFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex;
@end
