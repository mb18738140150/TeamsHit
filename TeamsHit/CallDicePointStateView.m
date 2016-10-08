//
//  CallDicePointStateView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CallDicePointStateView.h"

@implementation CallDicePointStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor clearColor];
    self.backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backImageView.image = [UIImage imageNamed:@"callDicePointState"];
    [self addSubview:self.backImageView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.hd_width - 20, self.hd_height)];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [UIColor grayColor];
    self.contentLabel.textAlignment = 1;
    [self addSubview:self.contentLabel];
    
    self.dicePointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.contentLabel.frame), 0, 15, self.hd_height)];
    [self addSubview:self.dicePointImageView];
}

- (void)setContent:(NSString *)content
{
    if ([content isEqualToString:@"纠结中"]) {
        self.backImageView.image = [UIImage imageNamed:@"icon_wait_call_point"];
        return;
    }
    self.backImageView.image = [UIImage imageNamed:@"callDicePointState"];
    self.dicePointImageView.hidden = YES;
    self.contentLabel.frame = CGRectMake(5, 0, self.hd_width - 5, self.hd_height);
    self.contentLabel.text = content;
}

- (void)setDicePointImage:(UIImage *)dicePointImage
{
    self.dicePointImageView.hidden = NO;
    self.contentLabel.frame = CGRectMake(5, 0, self.hd_width - 32, self.hd_height);
    self.dicePointImageView.frame = CGRectMake(CGRectGetMaxX(self.contentLabel.frame), (self.hd_height - 22) / 2, 22, 22);
    self.dicePointImageView.image = dicePointImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
