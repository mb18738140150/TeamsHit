//
//  materiaCollectionView.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "materiaCollectionView.h"
#import "MateriaCollectionModel.h"
#import "MateriaCollectionViewCell.h"
#define kExpressionImageCellID @"expressionCellID"
#define kTitleCellID @"titleCellID"

#define IMAGEITEMSIZE 80
@interface materiaCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy)MateriaBlock myBlock;
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray * imageArr;
@property (nonatomic, strong)NSMutableArray * allImageArr;
@end

@implementation materiaCollectionView

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
    NSArray * nameArr = @[@"阿狸", @"爱心猫", @"嗷大喵", @"暴走系列", @"仓鼠小目标", @"单身狗", @"冬天", @"举手", @"罗罗布", @"蚂蚁大黑", @"牛轰轰", @"疲惫", @"生日快乐", @"手绘表情", @"手绘兔子", @"摊手", @"咸鱼", @"小崽子", @"小祖宗", @"英语水果", @"有礼貌", @"点赞", @"颜文字"];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"MateriaExpression" ofType :@"bundle"];
    self.imageArr = [NSMutableArray array];
    for (int i = 0; i < 23; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"%@-1.png", [nameArr objectAtIndex:i]]];
        [_imageArr addObject:[UIImage imageWithContentsOfFile:imgPath]];
        
        MateriaCollectionModel * model = [[MateriaCollectionModel alloc]init];
        model.materiaTitle = [nameArr objectAtIndex:i];
        model.materiaImageHeight = IMAGEITEMSIZE;
        model.materiaImageWidth = [UIImage imageWithContentsOfFile:imgPath].size.width * model.materiaImageHeight / [UIImage imageWithContentsOfFile:imgPath].size.height;
        model.materiaImageStr = imgPath;
        
        [self.allImageArr addObject:model];
        
    }
    
//    for (int i = 0; i < 23; i++) {
//        MateriaCollectionModel * model = [[MateriaCollectionModel alloc]init];
//        model.materiaTitle = [nameArr objectAtIndex:i];
//        model.materiaImageHeight = IMAGEITEMSIZE;
//        model.materiaImage = [_imageArr objectAtIndex:i];
//        
//        [self.allImageArr addObject:model];
//    }
//    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    // item之间最小间距
    layout.minimumInteritemSpacing = 30;
    
    // item最小行间距
    layout.minimumLineSpacing = 10;
    
    // 集合视图滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, 100) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    
    // 注册item
    [self.collectionView registerClass:[MateriaCollectionViewCell class] forCellWithReuseIdentifier:kExpressionImageCellID];
}

#pragma mark - UIcollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.allImageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MateriaCollectionModel * model = [self.allImageArr objectAtIndex:indexPath.row];
    MateriaCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kExpressionImageCellID forIndexPath:indexPath];
    [cell creatContantViewWith:CGSizeMake(model.materiaImageWidth, model.materiaImageHeight)];
    cell.photoImageView.image = [UIImage imageWithContentsOfFile:model.materiaImageStr];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MateriaCollectionModel * model = [self.allImageArr objectAtIndex:indexPath.row];
    if (self.myBlock) {
        _myBlock(model.materiaTitle, [UIImage imageWithContentsOfFile:model.materiaImageStr]);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MateriaCollectionModel * model = [self.allImageArr objectAtIndex:indexPath.row];
    return CGSizeMake(model.materiaImageWidth, model.materiaImageHeight);
}

- (void)getMateriaImage:(MateriaBlock)materiaBlock
{
    self.myBlock = [materiaBlock copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
