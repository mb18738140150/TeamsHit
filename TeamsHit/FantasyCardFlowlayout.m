//
//  FantasyCardFlowlayout.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyCardFlowlayout.h"

@implementation FantasyCardFlowlayout

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemSize = CGSizeMake(48, 70);
    self.minimumInteritemSpacing = 5;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    
    for (int i = 1; i < array.count; i++) {
        UICollectionViewLayoutAttributes * lastAttr = array[i-1];
        CGFloat  begainX = lastAttr.frame.origin.x + lastAttr.size.width / 3;
        UICollectionViewLayoutAttributes * attr = array[i];
        attr.transform = CGAffineTransformMakeTranslation(-(attr.frame.origin.x - begainX), 0);
    }
//    NSLog(@"self.minimumInteritemSpacing = %f", self.minimumInteritemSpacing);
    return array;
}

@end
