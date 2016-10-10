//
//  TeamHitCollectionView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TeamHitCollectionView.h"
#import "GroupInfoCollectionViewCell.h"

#define kGroupInfoCellID @"GroupInfoCellID"

@interface TeamHitCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * collectionView;

@end

@implementation TeamHitCollectionView

- (NSMutableArray *)dateSourceArray
{
    if (!_dateSourceArray) {
        _dateSourceArray = [NSMutableArray array];
    }
    return _dateSourceArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((screenWidth - 64) / 5, (screenWidth - 64) / 5 + 16);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    // item之间最小间距
    layout.minimumInteritemSpacing = 8;
    // item最小行间距
    layout.minimumLineSpacing = 10;
    // 集合视图滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 注册item
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[GroupInfoCollectionViewCell class] forCellWithReuseIdentifier:kGroupInfoCellID];
    
    [self addSubview:self.collectionView];
}

#pragma mark - UIcollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.dateSourceArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接重用cell，不用创建，因为仓库里没有cell的话，collectionView会自己创建该wifeCell,不用我们管（更深层次的原因是，我们已经把wifeCell注册给collectionView了，所以collectionView会自己完成cell的创建工作）
    GroupInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGroupInfoCellID forIndexPath:indexPath];
    if (indexPath.row == self.dateSourceArray.count) {
        cell.iconImageView.image = [UIImage imageNamed:@"upload.png"];
    }else
    {
        RCUserInfo * userInfo = [self.dateSourceArray objectAtIndex:indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
        cell.titleLabel.text = userInfo.name;
        if (indexPath.row == 0) {
            cell.tipView.hidden = NO;
        }
        
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)reloadDataAction
{
    [self.collectionView reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
