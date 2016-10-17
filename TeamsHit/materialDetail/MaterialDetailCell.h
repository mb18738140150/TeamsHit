//
//  MaterialDetailCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialDetailCell : UICollectionViewCell

@property (nonatomic, assign)BOOL isHavenotAddBt;
@property (nonatomic, strong)UIImageView * detailImageView;
@property (nonatomic, strong)UIImageView * zoomerImageView;
@property (nonatomic, strong)UIButton * addBT;
@property (nonatomic, strong)UIButton * printBT;
- (void)initialize;
@end
