//
//  CardView.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CardView.h"

#define CENTERIMAGE_W 18
#define CENTERIMAGE_H 22
#define SIDE_W 12
#define SIDE_H 10

#define SIDE_IMAGE_W 6
#define SIDE_IMAGE_H 7

#define LEFT_SPACE 2
#define TOP_SPACE 3

@interface CardView ()

@property (nonatomic, strong)UIColor * floerColor;
@property (nonatomic, strong)UIImageView * centerImageView;
@property (nonatomic, strong)UILabel * leftTopLB;
@property (nonatomic, strong)UIImageView * leftTopImageView;
@property (nonatomic, strong)UILabel * rightbuttomLB;
@property (nonatomic, strong)UIImageView * rightbuttomImageView;

@end

@implementation CardView

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
    self.layer.borderWidth = .8;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.hd_width - CENTERIMAGE_W) / 2, (self.hd_height - CENTERIMAGE_H) / 2, CENTERIMAGE_W, CENTERIMAGE_H)];
    [self addSubview:self.centerImageView];
    
    self.leftTopLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, SIDE_W, SIDE_H)];
    self.leftTopLB.font = [UIFont boldSystemFontOfSize:10];
    [self addSubview:self.leftTopLB];
    
    self.leftTopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE + 1, CGRectGetMaxY(_leftTopLB.frame), SIDE_IMAGE_W, SIDE_IMAGE_H)];
    [self addSubview:_leftTopImageView];
    
    self.rightbuttomLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - SIDE_W - LEFT_SPACE, self.hd_height - SIDE_H - TOP_SPACE, SIDE_W, SIDE_H)];
    self.rightbuttomLB.font = [UIFont boldSystemFontOfSize:10];
    [self addSubview:self.rightbuttomLB];
    _rightbuttomLB.transform = CGAffineTransformRotate(_rightbuttomLB.transform, M_PI);
    
    self.rightbuttomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width - SIDE_W - LEFT_SPACE + 3, CGRectGetMinY(_rightbuttomLB.frame) - SIDE_IMAGE_H, SIDE_IMAGE_W, SIDE_IMAGE_H)];
    [self addSubview:_rightbuttomImageView];
    _rightbuttomImageView.transform = CGAffineTransformRotate(_rightbuttomImageView.transform, M_PI);
    
    
    self.mengbanView = [[UIView alloc]initWithFrame:self.bounds];
    self.mengbanView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.5];
    [self addSubview:self.mengbanView];
    self.mengbanView.hidden = YES;
    
}

- (void)setCardModel:(FantasyGamerCardInfoModel *)cardModel
{
    switch (cardModel.fantasyCardColor) {
        case FantasyCardColor_hearts:
        {
            self.floerColor = [UIColor redColor];
            self.centerImageView.image = [UIImage imageNamed:@"fantasy_heart"];
            self.leftTopImageView.image = [UIImage imageNamed:@"fantasy_small_heart"];
            self.rightbuttomImageView.image = [UIImage imageNamed:@"fantasy_small_heart"];
            self.leftTopLB.textColor = [UIColor redColor];
            self.leftTopLB.text = cardModel.cardNumber;
            self.rightbuttomLB.textColor = [UIColor redColor];
            self.rightbuttomLB.text = cardModel.cardNumber;
        }
            break;
        case FantasyCardColor_spade:
        {
            self.floerColor = [UIColor blackColor];
            self.centerImageView.image = [UIImage imageNamed:@"fantasy_spade"];
            self.leftTopImageView.image = [UIImage imageNamed:@"fantasy_small_spade"];
            self.rightbuttomImageView.image = [UIImage imageNamed:@"fantasy_small_spade"];
            self.leftTopLB.textColor = [UIColor blackColor];
            self.leftTopLB.text = cardModel.cardNumber;
            self.rightbuttomLB.textColor = [UIColor blackColor];
            self.rightbuttomLB.text = cardModel.cardNumber;
        }
            break;
        case FantasyCardColor_plumblossom:
        {
            self.floerColor = [UIColor blackColor];
            self.centerImageView.image = [UIImage imageNamed:@"fantasy_plumblossom"];
            self.leftTopImageView.image = [UIImage imageNamed:@"fantasy_small_plumblossom"];
            self.rightbuttomImageView.image = [UIImage imageNamed:@"fantasy_small_plumblossom"];
            self.leftTopLB.textColor = [UIColor blackColor];
            self.leftTopLB.text = cardModel.cardNumber;
            self.rightbuttomLB.textColor = [UIColor blackColor];
            self.rightbuttomLB.text = cardModel.cardNumber;
        }
            break;
        case FantasyCardColor_side:
        {
            self.floerColor = [UIColor redColor];
            self.centerImageView.image = [UIImage imageNamed:@"fantasy_side"];
            self.leftTopImageView.image = [UIImage imageNamed:@"fantasy_small_side"];
            self.rightbuttomImageView.image = [UIImage imageNamed:@"fantasy_small_side"];
            self.leftTopLB.textColor = [UIColor redColor];
            self.leftTopLB.text = cardModel.cardNumber;
            self.rightbuttomLB.textColor = [UIColor redColor];
            self.rightbuttomLB.text = cardModel.cardNumber;
        }
            break;
            
        default:
            break;
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
