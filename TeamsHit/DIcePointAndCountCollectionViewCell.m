//
//  DIcePointAndCountCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "DIcePointAndCountCollectionViewCell.h"

@implementation DIcePointAndCountCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.diceCountLabel = [[UILabel alloc]initWithFrame:self.bounds];
    self.diceCountLabel.textColor = UIColorFromRGB(0x0598E1);
    self.diceCountLabel.textAlignment = 1;
    self.diceCountLabel.font = [UIFont systemFontOfSize:16];
    self.diceCountLabel.backgroundColor = [UIColor whiteColor];
    self.diceCountLabel.layer.cornerRadius = self.hd_width / 2;
    self.diceCountLabel.layer.borderColor = UIColorFromRGB(0x0598E1).CGColor;
    self.diceCountLabel.layer.borderWidth = 1;
    self.diceCountLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.diceCountLabel];
    
    self.dicePointView = [[UIView alloc]initWithFrame:self.bounds];
    self.dicePointView.backgroundColor = [UIColor whiteColor];
    self.dicePointView.layer.cornerRadius = self.hd_width / 2;
    self.dicePointView.layer.borderWidth = 1;
    self.dicePointView.layer.borderColor = UIColorFromRGB(0x0598E1).CGColor;
    self.dicePointView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.dicePointView];
    
    self.dicePointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.dicePointImageView.center = self.dicePointView.center;
    [self.contentView addSubview:self.dicePointImageView];
    
}

- (void)setChooseDiceModel:(ChooseDiceModel *)chooseDiceModel
{
    if (chooseDiceModel.isPointModel) {
        self.diceCountLabel.hidden = YES;
        self.dicePointView.hidden = NO;
        self.dicePointImageView.hidden = NO;
        
        self.dicePointImageView.image = [UIImage imageNamed:chooseDiceModel.contentStr];
        if (chooseDiceModel.isSelect) {
            self.dicePointView.backgroundColor = UIColorFromRGB(0x0598E1);
        }else
        {
            self.dicePointView.backgroundColor = [UIColor whiteColor];
        }
       
    }else
    {
        self.dicePointView.hidden = YES;
        self.dicePointImageView.hidden = YES;
        self.diceCountLabel.hidden = NO;
        
        self.diceCountLabel.text = chooseDiceModel.contentStr;
        
        if (chooseDiceModel.isSelect) {
            self.diceCountLabel.textColor = [UIColor whiteColor];
            self.diceCountLabel.backgroundColor = UIColorFromRGB(0x0598E1);
        }else
        {
            self.diceCountLabel.textColor = UIColorFromRGB(0x0598E1);
            self.diceCountLabel.backgroundColor = [UIColor whiteColor];
        }
    }
}


@end
