//
//  MaterialDetaileListCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CilckDetailMaterialDelegate <NSObject>

- (void)cilckWithclickItem:(int )clickitem andListItem:(int )listItem;

- (void)headRefreshWith:(int )item andTarget:(id )collectionView;

- (void)footRefreshWith:(int )item andTarget:(id )collectionview;

@end

@interface MaterialDetaileListCell : UICollectionViewCell

@property (nonatomic, assign)BOOL isHavenotAddBT;
@property (nonatomic, strong)UICollectionView * materialDetailCollectionView;
@property (nonatomic, assign)int  item;
@property (nonatomic, assign)id<CilckDetailMaterialDelegate>delegate;

- (void)creatContentviews:(NSArray *)materialDetailArr;;

@end
