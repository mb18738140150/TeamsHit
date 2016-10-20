//
//  MaterialdetailBigView.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/17.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MaterialdetailBigView.h"
#import "PublishCollectionViewCell.h"
#import "AppDelegate.h"
static NSString* ALCELLID = @"PublishCollectionViewCell";
@interface MaterialdetailBigView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)NSMutableArray * datasourceArr;
@property (nonatomic, strong)UIButton * closeBT;

@property (nonatomic, strong)UICollectionView* collectView;
//@property (nonatomic, strong)UIScrollView * imageScrollView;
@property (nonatomic, strong)UIButton * beforeBT;
@property (nonatomic, strong)UIButton * nextBT;
@property (nonatomic, strong)UIButton * addBT;
@property (nonatomic, strong)UIButton * printBT;

@end

@implementation MaterialdetailBigView

- (NSMutableArray *)datasourceArr
{
    if (!_datasourceArr) {
        _datasourceArr = [NSMutableArray array];
    }
    return _datasourceArr;
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
    self.backgroundColor = [UIColor clearColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    [self addSubview:backView];
    
    UIView * imageBackView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth / 8, screenHeight / 6, screenWidth / 4 * 3, screenHeight / 3 * 2)];
    imageBackView.backgroundColor = UIColorFromRGB(0x12B7F5);
    [self addSubview:imageBackView];
    
    self.closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBT.frame = CGRectMake(0, 0, 38, 38);
    self.closeBT.hd_centerX = CGRectGetMaxX(imageBackView.frame);
    self.closeBT.hd_centerY = CGRectGetMinY(imageBackView.frame);
    [self.closeBT setImage:[[UIImage imageNamed:@"big_closeBT"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.closeBT addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBT];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(imageBackView.hd_width - 38, imageBackView.hd_height - 88);
    layout.minimumInteritemSpacing = 0;//设置行间隔
    layout.minimumLineSpacing = 0;//设置列间隔
    //初始化collectionView
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(19, 18, imageBackView.hd_width - 38, imageBackView.hd_height - 88) collectionViewLayout:layout];
    _collectView.tag = 0;
    _collectView.backgroundColor = [UIColor clearColor];
    //设置代理
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.showsHorizontalScrollIndicator = NO;
    // 注册cell
    [_collectView registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:ALCELLID];
    //设置水平方向滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置分页
    _collectView.pagingEnabled = YES;
    [imageBackView addSubview:_collectView];
    
//    self.imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(19, 18, imageBackView.hd_width - 38, imageBackView.hd_height - 88)];
//    self.imageScrollView.backgroundColor = [UIColor whiteColor];
//    self.imageScrollView.pagingEnabled = YES;
//    [imageBackView addSubview:self.imageScrollView];
    
    self.beforeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beforeBT.frame = CGRectMake(10, imageBackView.hd_height - 51, 29, 29);
    [self.beforeBT setImage:[[UIImage imageNamed:@"big_before_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.beforeBT addTarget:self action:@selector(beforeAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageBackView addSubview:self.beforeBT];
    
    self.nextBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBT.frame = CGRectMake(imageBackView.hd_width - 39, imageBackView.hd_height - 51, 29, 29);
    [self.nextBT setImage:[[UIImage imageNamed:@"big_next_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.nextBT addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageBackView addSubview:self.nextBT];
    
    self.addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBT.frame = CGRectMake(imageBackView.hd_width / 2 - 74, imageBackView.hd_height - 51, 60, 29);
    self.addBT.backgroundColor = [UIColor whiteColor];
    self.addBT.layer.cornerRadius = 3;
    self.addBT.layer.masksToBounds = YES;
    [self.addBT setTitle:@"添加" forState:UIControlStateNormal];
    [self.addBT setTitleColor:UIColorFromRGB(0xD9524E) forState:UIControlStateNormal];
    [self.addBT addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageBackView addSubview:self.addBT];
    
    self.printBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.printBT.frame = CGRectMake(imageBackView.hd_width / 2 + 8, imageBackView.hd_height - 51, 60, 29);
    self.printBT.layer.cornerRadius = 3;
    self.printBT.layer.masksToBounds = YES;
    self.printBT.backgroundColor = [UIColor whiteColor];
    [self.printBT setTitle:@"打印" forState:UIControlStateNormal];
    [self.printBT setTitleColor:UIColorFromRGB(0x5CB95C) forState:UIControlStateNormal];
    [self.printBT addTarget:self action:@selector(printAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageBackView addSubview:self.printBT];
    
}

- (void)refreshImageDateSourceWithImageArr:(NSArray *)imagearray
{
    self.datasourceArr = [imagearray mutableCopy];
    [self.collectView reloadData];
    
}

- (void)show:(int)item
{
    self.item = item;
    [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
}

- (void)moveToindex:(int)item
{
    self.item = item;
    [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALCELLID forIndexPath:indexPath];
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.datasourceArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    return cell;
}

- (void)closeView
{
    [self removeFromSuperview];
}

- (void)beforeAction:(UIButton *)button
{
    if (self.item == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经是第一张了" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    self.item--;
    [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(beforeClick)]) {
        [self.delegate beforeClick];
    }
}

- (void)nextAction:(UIButton *)button
{
    
    if (self.item == self.datasourceArr.count - 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nextClick)]) {
            [self.delegate nextClick];
        }
        return;
    }
    self.item++;
    [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)addAction:(UIButton *)button
{
    NSLog(@"添加");
//    UIImage * image;
//    NSArray * visiblecellindex = [_collectView visibleCells];
//    for (PublishCollectionViewCell * cell in visiblecellindex) {
//        NSIndexPath *path1 = (NSIndexPath *)[_collectView indexPathForCell:cell];
//        if (path1.row == self.item) {
//            image = cell.photoImageView.image;
//            break;
//        }
//        
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addClick:andItem:)]) {
        [self.delegate addClick:self.listItem andItem:self.item];
    }
    
}

- (void)printAction:(UIButton *)button
{
    NSLog(@"打印");
    if (self.delegate && [self.delegate respondsToSelector:@selector(printClick:andItem:)]) {
        [self.delegate printClick:self.listItem andItem:self.item];
    }
}

- (void)haoveNomore
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经是最后一张了" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
