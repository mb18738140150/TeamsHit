//
//  FantasygamerLayout.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasygamerLayout.h"

@interface FantasygamerLayout ()

// 集合视图item的个数
@property (nonatomic , assign) NSUInteger numberOfItems;
// 保存最终计算得到的每个item的attribute （其实也就是保存UICollectionViewLayoutAttributes 类的对象）
@property (nonatomic , retain) NSMutableArray *itemsAttributes;

@end

@implementation FantasygamerLayout

- (NSMutableArray *)itemsAttributes
{
    if (!_itemsAttributes) {
        self.itemsAttributes = [NSMutableArray array];
    }
    return _itemsAttributes;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self calculateItems];
}


- (void)calculateItems
{
    // 拿到所有的item
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    // 根据collectionView所管理的item数量，产生循环，每循环一次，计算出当前item的frame
    for (int i = 0; i < self.numberOfItems; i++) {
        // 为每个item对象创建对应的indexPath对象
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        CGFloat itemHeight = 0;
        
        if (i < 3) {
            // item开始布局，在准备另外两个东西   （orange_x , orange_y);
            CGFloat orange_x = self.sectionIndets.left + (self.itemWidth + self.interitemSpacing) * i;
            
            CGFloat orange_y = 0;
            
            // 根据indexPath 创建布局属性的对象
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // 设置布局对象的frame值
            attribute.frame = CGRectMake(orange_x, orange_y, self.itemWidth, 100);
            
            // 想保存item的布局属性数组中，添加最终计算出来的大小的布局属性对象
            [self.itemsAttributes addObject:attribute];
        }else if (i == 3)
        {
            CGFloat orange_x = self.sectionIndets.left ;
            
            CGFloat orange_y = 100;
            
            // 根据indexPath 创建布局属性的对象
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // 设置布局对象的frame值
            attribute.frame = CGRectMake(orange_x, orange_y, screenWidth, 132);
            
            // 想保存item的布局属性数组中，添加最终计算出来的大小的布局属性对象
            [self.itemsAttributes addObject:attribute];
        }else
        {
            // item开始布局，在准备另外两个东西   （orange_x , orange_y);
            CGFloat orange_x = self.sectionIndets.left + (self.itemWidth + self.interitemSpacing) * (i - 4);
            
            CGFloat orange_y = 232;
            
            // 根据indexPath 创建布局属性的对象
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // 设置布局对象的frame值
            attribute.frame = CGRectMake(orange_x, orange_y, self.itemWidth, 100);
            
            // 想保存item的布局属性数组中，添加最终计算出来的大小的布局属性对象
            [self.itemsAttributes addObject:attribute];
        }
        
    }
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.numberOfItems inSection:0];
//    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
//    [self.itemsAttributes addObject:attribute];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(screenWidth, 332 + 20);
}

// 用每一个item的布局属性对象
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.itemsAttributes;
}


//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
//    
//    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
//        attribute.frame = CGRectMake(0, 332, screenWidth, 40);
//    }
//    
//    return attribute;
//}

@end
