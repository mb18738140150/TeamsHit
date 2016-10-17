//
//  TeamHitCollectionView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddNewGroupMumberBlock)();

@interface TeamHitCollectionView : UIView

@property (nonatomic, strong)NSMutableArray * dateSourceArray;

- (void)addNewGroupMumber:(AddNewGroupMumberBlock)block;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadDataAction;

@end
