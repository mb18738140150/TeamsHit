//
//  BGTopSilderBar.m
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "BGTopSilderBar.h"
#import "BGTopSilderBarCell.h"
#import "global.h"

@interface BGTOPMode:NSObject

@property (nonatomic, assign)CGFloat itemWidth;
@property (nonatomic, assign)CGFloat itemHeight;

@end

@implementation BGTOPMode

@end

@interface BGTopSilderBar()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSArray* items;
@property(nonatomic,weak)UICollectionView* collectView;
@property(nonatomic,weak)UIView* underline;

@property (nonatomic, strong)NSMutableArray * itemWidthArr;
@property(nonatomic,assign)NSInteger currentBarIndex;//当前选中item的位置

@end

static NSString* ALCELLID = @"BGTopSilderBarCell";

@implementation BGTopSilderBar

-(instancetype)initWithFrame:(CGRect)frame andItemTitleArr:(NSArray *)itemArr{
    self = [super initWithFrame:frame];
    if (self) {
        _currentBarIndex = 0;
        _items = itemArr;
        self.itemWidthArr = [NSMutableArray array];
        for (NSString * itemStr in _items) {
            CGSize titleSize = [global sizeWithText:itemStr font:BGFont(19.5) maxSize:CGSizeMake(MAXFLOAT, ItemHeight)];
            BGTOPMode * model = [[BGTOPMode alloc]init];
            model.itemWidth = titleSize.width + 5;
            model.itemHeight = titleSize.height;
            [_itemWidthArr addObject:model];
        }
        
        [self initCollectView];
        [self initUnderline];
    }
    return self;
}
/**
 初始化下划线
 */
-(void)initUnderline{
    CGSize titleSize = [global sizeWithText:[_items firstObject] font:BGFont(19.5) maxSize:CGSizeMake(MAXFLOAT, ItemHeight)];
    BGTOPMode * model = self.itemWidthArr[0];
    UIView* uline = [[UIView alloc] initWithFrame:CGRectMake((model.itemWidth - titleSize.width - 5)*0.5,48,titleSize.width,2)];
    uline.backgroundColor = UnderlineColor;
    _underline  = uline;
    [_collectView addSubview:uline];
}
/**
 初始化装载导航文字的collectView
 */
-(void)initCollectView{
    CGFloat Margin = 0;
    CGFloat W = screenW/itemNum;
    CGFloat H = 50;
    CGRect rect = CGRectMake(Margin,0,screenW,H);
    //初始化布局类(UICollectionViewLayout的子类)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(W, H);
    layout.minimumInteritemSpacing = 0;//设置行间隔
    layout.minimumLineSpacing = 0;//设置列间隔
    //初始化collectionView
    UICollectionView* collectView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor clearColor];
    _collectView = collectView;
    //设置代理
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.showsHorizontalScrollIndicator = NO;
    // 注册cell
    [collectView registerNib:[UINib nibWithNibName:ALCELLID bundle:nil] forCellWithReuseIdentifier:ALCELLID];
    //设置水平方向滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:collectView];
}
/**
 从某个item移动到另一个item
 */
-(void)setItemColorFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex{
    
    [_collectView performBatchUpdates:^{
        [self scrollToWithIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    } completion:^(BOOL finished) {
        BGTopSilderBarCell* fromCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
        BGTopSilderBarCell* toCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
        [fromCell setTitleColor:NormalColor];
        [fromCell setFontScale:NO];
        [toCell setTitleColor:color(18,183,245,1.0)];
        [toCell setFontScale:YES];
        _currentBarIndex = toIndex;
        
        double delayInSecond = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSecond * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectItem:)]) {
                [self.delegate selectItem:toIndex];
            }
        });
        
    }];
    
//    [self scrollToWithIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
//    BGTopSilderBarCell* fromCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
//    BGTopSilderBarCell* toCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
//    [fromCell setTitleColor:color(93.0,93.0,93.0,1.0)];
//    [fromCell setFontScale:NO];
//    [toCell setTitleColor:color(243.0,39.0,66.0,1.0)];
//    [toCell setFontScale:YES];
//    _currentBarIndex = toIndex;
}

/**
 设置外部内容的UICollectionView
 */
-(void)setContentCollectionView:(UICollectionView *)contentCollectionView{
    _contentCollectionView = contentCollectionView;
    // 监听contentOffset
    [contentCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 重写removeFromSuperview
 */
-(void)removeFromSuperview{
    [super removeFromSuperview];
    //移除监听contentOffset
    [_contentCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    _contentCollectionView = nil;
}
/**
 设置下划线的x轴距离
 */
-(void)setUnderlineX:(CGFloat)underlineX{
    _underlineX = underlineX;
    CGRect frame = _underline.frame;
    frame.origin.x = underlineX;
    _underline.frame = frame;
}
/**
 设置下划线的宽度
 */
-(void)setUnderlineWidth:(CGFloat)underlineWidth{
    _underlineWidth = underlineWidth;
    CGRect frame = _underline.frame;
    frame.size.width = underlineWidth;
    _underline.frame = frame;
}
#pragma -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BGTopSilderBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALCELLID forIndexPath:indexPath];
    if (indexPath.row == _currentBarIndex) {
        [cell setTitleColor:SelectedColor];
        cell.BGTitleFont = BGFont(19.5);
    }else{
        [cell setTitleColor:NormalColor];
        cell.BGTitleFont = BGFont(15.0);
    }
    cell.item = _items[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BGTOPMode * model = [self.itemWidthArr objectAtIndex:indexPath.row];
    
    return CGSizeMake(model.itemWidth, 50);
}

/**
 设置移动位置
 */
-(void)scrollToWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger toRow = indexPath.row;
    if (indexPath.row > _currentBarIndex) {
        
        
        BOOL iscansee = NO;
        BOOL isbigger = NO;
        NSArray * visiblecellindex = [_collectView visibleCells];
        for (BGTopSilderBarCell * cell in visiblecellindex) {
            NSIndexPath *path1 = (NSIndexPath *)[_collectView indexPathForCell:cell];
            if (path1.row == indexPath.row) {
                iscansee = YES;
            }
            if (path1.row > indexPath.row) {
                isbigger = YES;
            }
        }
        
        if (!iscansee) {
            toRow = indexPath.row;
            if (!isbigger) {
                if ((indexPath.row+2) < _items.count) {
                    toRow = indexPath.row+2;
                }else if((indexPath.row+1) < _items.count){
                    toRow = indexPath.row+1;
                }else;
            }else
            {
                if ((indexPath.row-2) >= 0) {
                    toRow = indexPath.row-2;
                }else if ((indexPath.row-1) >= 0){
                    toRow = indexPath.row-1;
                }else;
            }
            [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else
        {
            if ((indexPath.row+2) < _items.count) {
                toRow = indexPath.row+2;
            }else if((indexPath.row+1) < _items.count){
                toRow = indexPath.row+1;
            }else;
            [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        
    }else if (indexPath.row < _currentBarIndex){
        
        BOOL iscansee = NO;
        BOOL isbigger = NO;
        NSArray * visiblecellindex = [_collectView visibleCells];
        for (BGTopSilderBarCell * cell in visiblecellindex) {
            NSIndexPath *path1 = (NSIndexPath *)[_collectView indexPathForCell:cell];
            if (path1.row == indexPath.row) {
                iscansee = YES;
            }
            if (path1.row > indexPath.row) {
                isbigger = YES;
            }
        }
        
        if (!iscansee) {
            toRow = indexPath.row;
            if (!isbigger) {
                if ((indexPath.row+2) < _items.count) {
                    toRow = indexPath.row+2;
                }else if((indexPath.row+1) < _items.count){
                    toRow = indexPath.row+1;
                }else;
            }else
            {
                if ((indexPath.row-2) >= 0) {
                    toRow = indexPath.row-2;
                }else if ((indexPath.row-1) >= 0){
                    toRow = indexPath.row-1;
                }else;
            }
            [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else
        {
            if ((indexPath.row-2) >= 0) {
                toRow = indexPath.row-2;
            }else if ((indexPath.row-1) >= 0){
                toRow = indexPath.row-1;
            }else;
            [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        
    }else{
        return;
    }
}

#pragma mark - UIScrollViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self scrollToWithIndexPath:indexPath];
    [_contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    
}

#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath])return;
    
    int whichItem=(int)(_contentCollectionView.contentOffset.x/_contentCollectionView.frame.size.width+0.5);
    CGSize titleSize = [global sizeWithText:_items[whichItem] font:BGFont(19.5) maxSize:CGSizeMake(MAXFLOAT, ItemHeight)];
    
    CGFloat begin_x = 0.0;
    for (int i = 0; i < whichItem; i++) {
        BGTOPMode * model = self.itemWidthArr[i];
        begin_x += model.itemWidth;
    }
    
    if (whichItem != _currentBarIndex) {
        [self setItemColorFromIndex:_currentBarIndex to:whichItem];
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat X = begin_x ;
            [self setUnderlineX:X];
            [self setUnderlineWidth:titleSize.width];
        }];
        NSLog(@"item = %d",whichItem);
    }
    
    if (_contentCollectionView.isDragging) {
        CGFloat X = begin_x;
        [self setUnderlineX:X];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
          CGFloat  X = begin_x;
        [self setUnderlineX:X];
        }];
    }
    _currentBarIndex = whichItem;
    //NSLog(@"x=%f , y=%f",_collectView.contentOffset.x,_collectView.contentOffset.y);
}

@end
