//
//  DragCellTableView.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "DragCellTableView.h"

typedef enum{
    SnapshotMeetsEdgeTop,
    SnapshotMeetsEdgeBottom,
}SnapshotMeetsEdge;

@interface DragCellTableView ()

/*对被选中的cell的截图*/
@property (nonatomic, weak)UIView * snapahot;
/*被选中的cell的原始位置*/
@property (nonatomic , strong)NSIndexPath *originalIndexPath;
/**被选中的cell的新位置*/
@property (nonatomic, strong) NSIndexPath *relocatedIndexPath;
/*cell被拖动到边缘后开启， tableview自动向上或向下滚动*/
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;
/**记录手指所在的位置*/
@property (nonatomic, assign) CGPoint fingerLocation;
/**自动滚动的方向*/
@property (nonatomic, assign) SnapshotMeetsEdge autoScrollDirection;

@end

@implementation DragCellTableView

- (instancetype)init
{
    if (self = [super init]) {
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}
#pragma mark - Gesture methods
- (void)longPressGestureRecognized:(id)sender
{
    UILongPressGestureRecognizer * longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    
    // 手指在tableview中的位置
    _fingerLocation = [longPress locationInView:self];
    // 手指按住位置对应的indexpath，可能为nil
    _relocatedIndexPath = [self indexPathForRowAtPoint:_fingerLocation];
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:
        {
            // 手势开始，对被选中的cell截图，隐藏原cell
            _originalIndexPath = [self indexPathForRowAtPoint:_fingerLocation];
            if (_originalIndexPath) {
                [self cellSelectedAtIndexPath:_originalIndexPath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            // 点击位置移动，判断手指按住位置是否进入其他indexpath范围，若进入则更新数据源并移动cell
            // 截图跟随手指移动
            CGPoint center = _snapahot.center;
            center.y = _fingerLocation.y;
            _snapahot.center = center;
            
            if ([self checkIfSnapshotMeetsEdge]) {
                [self startAutoScrollTimer];
            }else{
                [self stopAutoScrollTimer];
            }
            // 手指按住位置对应的indexpath， 可能为nil
            _relocatedIndexPath = [self indexPathForRowAtPoint:_fingerLocation];
            if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
                [self cellRelocatedToNewIndexPath:_relocatedIndexPath];
            }
            
        }
            break;
        default:{
            [self stopAutoScrollTimer];
            [self didEndDraging];
            if ([self.delegate respondsToSelector:@selector(cellDidEndMovingInTableView:)]) {
                [self.delegate cellDidEndMovingInTableView:self];
            }
            break;
        }
    }
}

/*创建定时器并运行*/
- (void)startAutoScrollTimer
{
    if (!_autoScrollTimer) {
        _autoScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAutoScroll)];
        [_autoScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/*
    停止定时器
 */
- (void)stopAutoScrollTimer
{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
}


/*
    cell 被手指长按选中， 对其进行截图，原cell隐藏
 */
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexpath
{
    UITableViewCell * cell = [self cellForRowAtIndexPath:indexpath];
    UIView * snapshot = [self customSnapshotFromView:cell];
    [self addSubview:snapshot];
    _snapahot = snapshot;
    cell.hidden = YES;
    CGPoint center = _snapahot.center;
    center.y = _fingerLocation.y;
    [UIView animateWithDuration:0.2 animations:^{
        _snapahot.transform = CGAffineTransformMakeScale(1.03, 1.03);
        _snapahot.alpha = 0.98;
        _snapahot.center = center;
    }];
    
}
/** 返回一个给定view的截图. */
- (UIView *)customSnapshotFromView:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView * snapshot = [[UIImageView alloc]initWithImage:image];
    snapshot.center = inputView.center;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

/*
    截图被移动到新的indexpath范围，这时先更新数据源，重排数组， 再将cell移至新位置
 */
- (void)cellRelocatedToNewIndexPath:(NSIndexPath *)indexPath
{
    // 更新数据源，并返回给外部
    [self updateDataSource];
    //交换移动cell位置
    [self moveRowAtIndexPath:_originalIndexPath toIndexPath:indexPath];
    //更新cell的原始indexPath为当前indexPath
    _originalIndexPath = indexPath;
}
/**修改数据源，通知外部更新数据源*/
- (void)updateDataSource
{
    NSMutableArray * tempArray = [NSMutableArray array];
    if ([self.dataSource respondsToSelector:@selector(originalArrayDataForTableView:)]) {
        [tempArray addObjectsFromArray:[self.dataSource originalArrayDataForTableView:self]];
    }
    // 判断原始数据是否为嵌套数组
    if ([self nestedArrayCheck:tempArray]) {
        if (_originalIndexPath.section == _relocatedIndexPath.section) {//在同一个section内
            [self moveObjectInMutableArray:tempArray[_originalIndexPath.section] fromIndex:_originalIndexPath.row toIndex:_relocatedIndexPath.row];
        }else{                                                          //不在同一个section内
            id originalObj = tempArray[_originalIndexPath.section][_originalIndexPath.item];
            [tempArray[_relocatedIndexPath.section] insertObject:originalObj atIndex:_relocatedIndexPath.item];
            [tempArray[_originalIndexPath.section] removeObjectAtIndex:_originalIndexPath.item];
        }
    }else
    {
        [self moveObjectInMutableArray:tempArray fromIndex:_originalIndexPath.row toIndex:_relocatedIndexPath.row];
    }
    
    //将新数组传出外部以更改数据源
    if ([self.delegate respondsToSelector:@selector(tableView:newArrayDataForDataSource:)]) {
        [self.delegate tableView:self newArrayDataForDataSource:tempArray];
    }
}
/**
 *  检查数组是否为嵌套数组
 *  @param array 需要被检测的数组
 *  @return 返回YES则表示是嵌套数组
 */
- (BOOL)nestedArrayCheck:(NSArray *)array
{
    for (id obj in array) {
        if ([obj isKindOfClass:[NSArray class]]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  将可变数组中的一个对象移动到该数组中的另外一个位置
 *  @param array     要变动的数组
 *  @param fromIndex 从这个index
 *  @param toIndex   移至这个index
 */
- (void)moveObjectInMutableArray:(NSMutableArray *)array fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    if (fromIndex < toIndex) {
        for (NSInteger i = fromIndex; i < toIndex; i ++) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
        }
    }else{
        for (NSInteger i = fromIndex; i > toIndex; i --) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
        }
    }
}
/**
 *  拖拽结束，显示cell，并移除截图
 */
- (void)didEndDraging{
    UITableViewCell *cell = [self cellForRowAtIndexPath:_originalIndexPath];
    cell.hidden = NO;
    cell.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _snapahot.center = cell.center;
        _snapahot.alpha = 0;
        _snapahot.transform = CGAffineTransformIdentity;
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [_snapahot removeFromSuperview];
        _snapahot = nil;
        _originalIndexPath = nil;
        _relocatedIndexPath = nil;
    }];
}

/**
 *  检查截图是否到达边缘，并作出响应
 */
- (BOOL)checkIfSnapshotMeetsEdge
{
    CGFloat minY = CGRectGetMinY(_snapahot.frame);
    CGFloat maxY = CGRectGetMaxY(_snapahot.frame);
    if (minY < self.contentOffset.y) {
        _autoScrollDirection = SnapshotMeetsEdgeTop;
        return YES;
    }
    if (maxY > self.bounds.size.height + self.contentOffset.y) {
        _autoScrollDirection = SnapshotMeetsEdgeBottom;
        return YES;
    }
    return NO;
}

/**
 *  开始自动滚动
 */
- (void)startAutoScroll{
    CGFloat pixelSpeed = 4;
    if (_autoScrollDirection == SnapshotMeetsEdgeTop) {
        // 向下滚动
        if (self.contentOffset.y > 0) {
            // 向下滚动最大范围限制
            [self setContentOffset:CGPointMake(0, self.contentOffset.y - pixelSpeed)];
            _snapahot.center = CGPointMake(_snapahot.center.x, _snapahot.center.y - pixelSpeed);
        }
    }else
    {
        // 向上滚动
        if (self.contentOffset.y + self.bounds.size.height < self.contentSize.height) {//向下滚动最大范围限制
            [self setContentOffset:CGPointMake(0, self.contentOffset.y + pixelSpeed)];
            _snapahot.center = CGPointMake(_snapahot.center.x, _snapahot.center.y + pixelSpeed);
        }
    }
    
    /*  当把截图拖动到边缘，开始自动滚动，如果这时手指完全不动，则不会触发‘UIGestureRecognizerStateChanged’，对应的代码就不会执行，导致虽然截图在tableView中的位置变了，但并没有移动那个隐藏的cell，用下面代码可解决此问题，cell会随着截图的移动而移动
     */
    _relocatedIndexPath = [self indexPathForRowAtPoint:_snapahot.center];
    if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
        [self cellRelocatedToNewIndexPath:_relocatedIndexPath];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
