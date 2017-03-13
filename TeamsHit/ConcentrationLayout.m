//
//  ConcentrationLayout.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/10.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "ConcentrationLayout.h"

@implementation ConcentrationLayout

- (instancetype)init
{
    if (self = [super init]) {
        ;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake((screenWidth - 60) / 4, 23);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumLineSpacing = 30;
    self.minimumInteritemSpacing = 0;
    
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    
    for (int i = 0; i < array.count; i++) {
        
        UICollectionViewLayoutAttributes * attr = array[i];
        attr.zIndex = -1;
        if (self.selectNum == i) {
            attr.zIndex = 0;
        }
        if (i == 4 || i == 0) {
            continue;
        }
        if (i<4) {
            attr.transform = CGAffineTransformMakeTranslation(-1 * i, 0);
        }else
        {
            attr.transform = CGAffineTransformMakeTranslation(-1 * (i - 4), 0);
        }
        
    }
    return array;
}
@end
