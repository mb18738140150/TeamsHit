//
//  CollectionViewCell.h
//  TeamsHit
//
//  Created by 仙林 on 17/2/6.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectbackImageBlock)();

@interface GameBackImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * backImage;
@property (nonatomic, strong)UIButton * selectButton;
@property (nonatomic, copy)SelectbackImageBlock myblock;

- (void)selectgamebackImage:(SelectbackImageBlock)block;

@end
