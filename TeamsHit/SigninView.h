//
//  SigninView.h
//  TeamsHit
//
//  Created by 仙林 on 17/3/1.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninView : UIView

@property (nonatomic, strong)NSMutableArray * dataArr;
@property (nonatomic, strong)UICollectionView * dateCollectionView;
- (void)prepareUI;

@end
