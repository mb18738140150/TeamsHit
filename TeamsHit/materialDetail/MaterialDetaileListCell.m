//
//  MaterialDetaileListCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MaterialDetaileListCell.h"

#import "MaterialDetailCell.h"
#define MaterialDetailCellID @"MaterialDetailCellID"

@interface MaterialDetaileListCell ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, strong)NSMutableArray * materialDetailsArrar;// 素材数据源

@end

@implementation MaterialDetaileListCell

- (NSMutableArray *)materialDetailsArrar
{
    if (!_materialDetailsArrar) {
        _materialDetailsArrar = [NSMutableArray array];
    }
    return _materialDetailsArrar;
}

- (void)creatContentviews:(NSArray *)materialDetailArr
{
    [self.contentView removeAllSubviews];
    self.materialDetailsArrar = [materialDetailArr mutableCopy];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((screenWidth - 60) / 3, (screenWidth - 60) / 3 * 1.9);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.materialDetailCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 0, screenWidth - 30, self.hd_height) collectionViewLayout:layout];
    self.materialDetailCollectionView.delegate = self;
    self.materialDetailCollectionView.dataSource = self;
    [self.materialDetailCollectionView registerClass:[MaterialDetailCell class] forCellWithReuseIdentifier:MaterialDetailCellID];
    self.materialDetailCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh )];
    self.materialDetailCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.materialDetailCollectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.materialDetailCollectionView];
}

- (void)headRefresh
{
    NSLog(@"头部刷新");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headRefreshWith:andTarget:)]) {
        [self.delegate headRefreshWith:self.item andTarget:self.materialDetailCollectionView];
    }
    
}

- (void)footRefresh
{
    NSLog(@"底部刷新");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(footRefreshWith:andTarget:)]) {
        [self.delegate footRefreshWith:self.item andTarget:self.materialDetailCollectionView];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.materialDetailsArrar.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MaterialDetailCellID forIndexPath:indexPath];
    cell.isHavenotAddBt = self.isHavenotAddBT;
    [cell initialize];
    [cell.detailImageView sd_setImageWithURL:[NSURL URLWithString:self.materialDetailsArrar[indexPath.row]] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cilckWithclickItem:andListItem:)]) {
        [self.delegate cilckWithclickItem:indexPath.row andListItem:self.item];
    }
}


@end
