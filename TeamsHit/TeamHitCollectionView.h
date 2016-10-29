//
//  TeamHitCollectionView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddNewGroupMumberBlock)();

@protocol LookUserDetailDelegate <NSObject>

- (void)lookUserDetailWithUserid:(NSString *)userId;

@end

@interface TeamHitCollectionView : UIView

@property (nonatomic, strong)NSMutableArray * dateSourceArray;
@property (nonatomic, assign)id<LookUserDetailDelegate>delegate;
- (void)addNewGroupMumber:(AddNewGroupMumberBlock)block;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadDataAction;

@end
