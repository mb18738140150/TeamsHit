//
//  TeamHitCollectionView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamHitCollectionView : UIView

@property (nonatomic, strong)NSMutableArray * dateSourceArray;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadDataAction;

@end
