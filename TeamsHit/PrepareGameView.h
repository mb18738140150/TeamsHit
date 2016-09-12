//
//  PrepareGameView.h
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrepareGameProtocol <NSObject>

- (void)prepareAction;
- (void)quitPrepareViewAction;

@end

@interface PrepareGameView : UIView

@property (nonatomic, strong)NSMutableArray * dataSourceArray;
@property (nonatomic, assign)id<PrepareGameProtocol> delegate;
@property (nonatomic, strong)UICollectionView * prepareCollectionView;
@property (nonatomic, strong)UIButton * prepareBT;
@property (nonatomic, strong)UIButton * preparedButton;
@property (nonatomic, strong)UIButton * quitBT;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadDataAction;

- (void)begainState;

@end
