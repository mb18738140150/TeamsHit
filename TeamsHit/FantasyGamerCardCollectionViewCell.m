//
//  FantasyGamerCardCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyGamerCardCollectionViewCell.h"
#import "CardView.h"

@interface FantasyGamerCardCollectionViewCell ()
@property (nonatomic, strong)CardView *cardView;
@end

@implementation FantasyGamerCardCollectionViewCell

- (void)creatSubViews
{
     [self.contentView removeAllSubviews];
    UIImageView * fanImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    fanImageView.image = [UIImage imageNamed:@"fan"];
    [self.contentView addSubview:fanImageView];
    
    self.cardView = [[CardView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:_cardView];
    _cardView.hidden = YES;
    
}

- (void)setGamerCardInfoModel:(FantasyGamerCardInfoModel *)gamerCardInfoModel
{
    self.cardView.hidden = NO;
    self.cardView.cardModel = gamerCardInfoModel;
}
- (void)showLosecard
{
    self.cardView.mengbanView.hidden = NO;
}
@end
