//
//  PrepareGameView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PrepareGameView.h"
#import "PrepareGameCollectionViewCell.h"

#define COLLECTIONVIE_WIDTH [UIScreen mainScreen].bounds.size.width - 80
#define CELL_IDENTIFIRE @"preparecellIdentifire"

@interface PrepareGameView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation PrepareGameView

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((COLLECTIONVIE_WIDTH - 80) / 3, (COLLECTIONVIE_WIDTH - 80) / 3);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 40;
    layout.minimumLineSpacing = 30;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 注册item
    self.prepareCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(40, 25, self.hd_width - 80, (COLLECTIONVIE_WIDTH - 90) / 3 * 2 + 32) collectionViewLayout:layout];
    self.prepareCollectionView.delegate = self;
    self.prepareCollectionView.dataSource = self;
    
    self.prepareCollectionView.backgroundColor = [UIColor clearColor];
    [self.prepareCollectionView registerClass:[PrepareGameCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIRE];
    
    [self addSubview:self.prepareCollectionView];
    
    self.prepareBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.prepareBT.frame = CGRectMake(self.hd_width / 2 - 116, CGRectGetMaxY(self.prepareCollectionView.frame) + 100, 73, 73);
    [self.prepareBT setImage:[UIImage imageNamed:@"prepareBT"] forState:UIControlStateNormal];
    [self addSubview:self.prepareBT];
    [self.prepareBT addTarget:self action:@selector(preparegameAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.preparedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preparedButton.frame = CGRectMake(self.hd_width / 2 - 27, CGRectGetMaxY(self.prepareCollectionView.frame) + 109, 54, 54);
    [self.preparedButton setImage:[UIImage imageNamed:@"PreparedButton"] forState:UIControlStateNormal];
    [self addSubview:self.preparedButton];
    self.preparedButton.userInteractionEnabled = NO;
    self.preparedButton.hidden = YES;
    
    self.quitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.quitBT.frame = CGRectMake(self.hd_width / 2 + 50, CGRectGetMaxY(self.prepareCollectionView.frame) + 119, 33, 33);
    [self.quitBT setImage:[UIImage imageNamed:@"quieGameButton"] forState:UIControlStateNormal];
    [self addSubview:self.quitBT];
    [self.quitBT addTarget:self action:@selector(quitgame:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)preparegameAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(prepareAction)]) {
        [self.delegate prepareAction];
    }
}

- (void)quitgame:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(quitPrepareViewAction)]) {
        [self.delegate quitPrepareViewAction];
    }
}

#pragma mark - UIcollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接重用cell，不用创建，因为仓库里没有cell的话，collectionView会自己创建该wifeCell,不用我们管（更深层次的原因是，我们已经把wifeCell注册给collectionView了，所以collectionView会自己完成cell的创建工作）
    PrepareGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIRE forIndexPath:indexPath];
    if (indexPath.row >= self.dataSourceArray.count) {
        cell.iconImageView.image = [UIImage imageNamed:@"preparePlaceholdIcon"];
        cell.prepareImageView.hidden = YES;
    }else
    {
        RCUserInfo * userInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"preparePlaceholdIcon"]];
        cell.prepareImageView.hidden = NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
}

- (void)reloadDataAction
{
    [self.prepareCollectionView reloadData];
}

- (void)begainState
{
    [self.dataSourceArray removeAllObjects];
    [self reloadDataAction];
    self.prepareBT.hidden = NO;
    self.preparedButton.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
