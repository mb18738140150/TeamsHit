//
//  ExpressionView.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ExpressionView.h"

#import "ProcessImageTypeCollectionViewCell.h"
#define kPublishCellID @"PublishCellID"

@interface ExpressionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * imageCollectionView;
@property (nonatomic, strong)UICollectionView * titleCollectionView;

@property (nonatomic, strong)NSMutableArray * allImageArr;
@property (nonatomic, strong)NSArray * currentImageArr;
@property (nonatomic, strong)NSArray * titleArr;

@end

@implementation ExpressionView

- (NSMutableArray *)allImageArr
{
    if (!_allImageArr) {
        _allImageArr = [NSMutableArray array];
    }
    return _allImageArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    // 设置item大小
    layout.itemSize = CGSizeMake((self.hd_width - 64) / 5, self.hd_height - 10);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10);
    
    // item之间最小间距
    layout.minimumInteritemSpacing = 8;
    
    // item最小行间距
    layout.minimumLineSpacing = 10;
    
    // 集合视图滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, (self.hd_width - 64) / 5 + 10) collectionViewLayout:layout];
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    
    self.imageCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageCollectionView];
    
    // 注册item
    [self.imageCollectionView registerClass:[ProcessImageTypeCollectionViewCell class] forCellWithReuseIdentifier:kPublishCellID];
    self.titleArr = @[@"表情", @"美食", @"气泡", @"花边", @"邮戳", @"探索"];
    
    NSArray * arr1 = @[];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
