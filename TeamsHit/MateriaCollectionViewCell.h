//
//  MateriaCollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MateriaCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView * photoImageView;

- (void)creatContantViewWith:(CGSize)imageSize;
@end
