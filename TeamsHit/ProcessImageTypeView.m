//
//  ProcessImageTypeView.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ProcessImageTypeView.h"
#import "ProcessImageTypeCollectionViewCell.h"
#import "ProcessImageTypeModel.h"
#define kPublishCellID @"PublishCellID"

@interface ProcessImageTypeView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSIndexPath *_lastIndexPath;
}

@property (nonatomic, strong)ProcessTypeBlock processBlock;

@property (nonatomic, strong)UICollectionView * typeCollection;

@property (nonatomic, strong)NSArray * imageArr;
@property (nonatomic, strong)NSMutableArray * modelArr;

@end

@implementation ProcessImageTypeView

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
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
    layout.itemSize = CGSizeMake(50, self.hd_height - 10);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10);
    
    // item之间最小间距
    layout.minimumInteritemSpacing = 8;
    
    // item最小行间距
    layout.minimumLineSpacing = 10;
    
    // 集合视图滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.typeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, (self.hd_width - 64) / 5 + 10) collectionViewLayout:layout];
    self.typeCollection.delegate = self;
    self.typeCollection.dataSource = self;
    
    self.typeCollection.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.typeCollection];
    
    // 注册item
    [self.typeCollection registerClass:[ProcessImageTypeCollectionViewCell class] forCellWithReuseIdentifier:kPublishCellID];
    self.imageArr = @[@"process_default", @"process_opposite", @"process_ink"];
    NSArray * titleArr = @[@"默认", @"反色", @"喷墨"];
    for (int i = 0; i<3; i++) {
        ProcessImageTypeModel * model = [[ProcessImageTypeModel alloc]init];
        model.imageName = self.imageArr[i];
        model.titleName = titleArr[i];
        model.isBallColor = NO;
        if (i == 0) {
            model.isBallColor = YES;
        }
        [self.modelArr addObject:model];
    }
    
}

#pragma mark - UIcollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接重用cell，不用创建，因为仓库里没有cell的话，collectionView会自己创建该wifeCell,不用我们管（更深层次的原因是，我们已经把wifeCell注册给collectionView了，所以collectionView会自己完成cell的创建工作）
    ProcessImageTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPublishCellID forIndexPath:indexPath];
    ProcessImageTypeModel * model = self.modelArr[indexPath.row];
    
    cell.photoImageView.image = [UIImage imageNamed:model.imageName];
    cell.titleLB.text = model.titleName;
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    
    if (model.isBallColor) {
        cell.layer.borderWidth = 1.5;
        cell.layer.borderColor = [UIColor cyanColor].CGColor;
    }else{
        cell.layer.borderWidth = 0;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_lastIndexPath) {
        ProcessImageTypeModel * model = self.modelArr[_lastIndexPath.item];
        model.isBallColor = NO;
        [self.typeCollection reloadItemsAtIndexPaths:@[_lastIndexPath]];
    }else {
        ProcessImageTypeModel * model = self.modelArr[0];
        model.isBallColor = NO;
        [self.typeCollection reloadData];
    }
    _lastIndexPath = indexPath;
    ProcessImageTypeModel * model = self.modelArr[_lastIndexPath.item];
    model.isBallColor = YES;
    [self.typeCollection reloadItemsAtIndexPaths:@[_lastIndexPath]];
    
    if (self.processBlock) {
        self.processBlock(_lastIndexPath.item);
    }
    
}

- (void)getProcessImageType:(ProcessTypeBlock)processBlock
{
    self.processBlock = [processBlock copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
