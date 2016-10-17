//
//  ExpressionView.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ExpressionView.h"
#import "ProcessImageTypeModel.h"
#import "ProcessImageTypeCollectionViewCell.h"
#import "ExpressionImageCollectionViewCell.h"
#define kExpressionImageCellID @"expressionCellID"
#define kTitleCellID @"titleCellID"

#define IMAGEITEMSIZE 80

@interface ExpressionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSIndexPath *_lastIndexPath;
}
@property (nonatomic, copy)ExpressionBlock expressionBlock;

@property (nonatomic, strong)UICollectionView * imageCollectionView;
@property (nonatomic, strong)UICollectionView * titleCollectionView;

@property (nonatomic, strong)NSMutableArray * allImageArr;
@property (nonatomic, strong)NSArray * currentImageArr;
@property (nonatomic, strong)NSArray * titleArr;
@property (nonatomic, strong)NSMutableArray * modelArr;
@end

@implementation ExpressionView
- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}
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
    layout.itemSize = CGSizeMake(IMAGEITEMSIZE, IMAGEITEMSIZE);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // item之间最小间距
    layout.minimumInteritemSpacing = 8;
    
    // item最小行间距
    layout.minimumLineSpacing = 10;
    
    // 集合视图滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, 80) collectionViewLayout:layout];
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    
    self.imageCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageCollectionView];
    
    // 注册item
    [self.imageCollectionView registerClass:[ExpressionImageCollectionViewCell class] forCellWithReuseIdentifier:kExpressionImageCellID];
    self.titleArr = @[@"表情", @"美食", @"气泡", @"花边", @"邮戳", @"探索", @"印章"];
    for (int i = 0; i<7; i++) {
        ProcessImageTypeModel * model = [[ProcessImageTypeModel alloc]init];
        model.titleName = _titleArr[i];
        model.isBallColor = NO;
        if (i == 0) {
            model.isBallColor = YES;
        }
        [self.modelArr addObject:model];
    }
    
    [self getImageSource];
    
    UICollectionViewFlowLayout * titlelayout = [[UICollectionViewFlowLayout alloc]init];
    titlelayout.itemSize = CGSizeMake(self.hd_width / 6, 40);
    titlelayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    titlelayout.minimumInteritemSpacing = 0;
    titlelayout.minimumLineSpacing = 10;
    titlelayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 80, self.hd_width, 40) collectionViewLayout:titlelayout];
    self.titleCollectionView.delegate = self;
    self.titleCollectionView.dataSource = self;
    
    self.titleCollectionView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:self.titleCollectionView];
    [self.titleCollectionView registerClass:[ProcessImageTypeCollectionViewCell class] forCellWithReuseIdentifier:kTitleCellID];
    
}

- (void)getImageSource
{
    NSMutableArray * imageSourceArr = [NSMutableArray array];
    NSMutableArray * foodSourceArr = [NSMutableArray array];
    NSMutableArray * bubbleSourceArr = [NSMutableArray array];
    NSMutableArray * lineSourceArr = [NSMutableArray array];
    NSMutableArray * postmarkSourceArr = [NSMutableArray array];
    NSMutableArray * questSourceArr = [NSMutableArray array];
    NSMutableArray * sealSourceArr = [NSMutableArray array];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"MateriaExpression" ofType :@"bundle"];
    
    for (int i = 1; i < 22; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"im%d.bmp", i]];
        [imageSourceArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    for (int i = 1; i < 7; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"food_%d.bmp", i]];
        [foodSourceArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    for (int i = 1; i < 15; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"bubble_graph_%d.bmp", i]];
        [bubbleSourceArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    for (int i = 1; i < 21; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"line_%d.bmp", i]];
        [lineSourceArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    for (int i = 1; i < 13; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"postmark_%d.bmp", i]];
        [postmarkSourceArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    for (int i = 1; i < 9; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"quest_%d.bmp", i]];
        [questSourceArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    for (int i = 1; i < 26; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"seal_%d.bmp", i]];
        [sealSourceArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    
    self.allImageArr = [NSMutableArray arrayWithObjects:imageSourceArr, foodSourceArr, bubbleSourceArr, lineSourceArr, postmarkSourceArr, questSourceArr, sealSourceArr, nil];
    self.currentImageArr = [NSArray arrayWithArray:self.allImageArr.firstObject];
}

#pragma mark - UIcollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:_titleCollectionView]) {
        return self.modelArr.count;
    }else
    {
        return self.currentImageArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_titleCollectionView]) {
        ProcessImageTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTitleCellID forIndexPath:indexPath];
        ProcessImageTypeModel * model = self.modelArr[indexPath.row];
        cell.titleLB.text = model.titleName;
        cell.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        if (model.isBallColor) {
            cell.titleLB.textColor = UIColorFromRGB(0x12B7F5);
        }else{
            cell.titleLB.textColor = [UIColor grayColor];
        }
        return cell;
    }else
    {
        ExpressionImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kExpressionImageCellID forIndexPath:indexPath];
        cell.expressionImage = self.currentImageArr[indexPath.item];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_titleCollectionView]) {
        if (_lastIndexPath) {
            ProcessImageTypeModel * model = self.modelArr[_lastIndexPath.item];
            model.isBallColor = NO;
//            [self.titleCollectionView reloadData];
        }else {
            ProcessImageTypeModel * model = self.modelArr[0];
            model.isBallColor = NO;
//            [self.titleCollectionView reloadData];
        }
        _lastIndexPath = indexPath;
        ProcessImageTypeModel * model = self.modelArr[_lastIndexPath.item];
        model.isBallColor = YES;
        [self.titleCollectionView reloadData];
        
        self.currentImageArr = self.allImageArr[indexPath.item];
        [self.imageCollectionView reloadData];
    }else
    {
        NSLog(@"%d", indexPath.item);
        UIImage * image = self.currentImageArr[indexPath.item];
        if (self.expressionBlock) {
            _expressionBlock(image);
        }
    }
}

- (void)getExpressionImage:(ExpressionBlock)expressionBlock
{
    self.expressionBlock = [expressionBlock copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
