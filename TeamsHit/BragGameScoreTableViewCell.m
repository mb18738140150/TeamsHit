//
//  BragGameScoreTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BragGameScoreTableViewCell.h"

@implementation BragGameScoreTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 1)];
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    self.numberLabel.textColor = UIColorFromRGB(0x38BBF8);
    self.numberLabel.backgroundColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = 1;
    [self.contentView addSubview:self.numberLabel];
    
    self.winImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, self.hd_height - 10, self.hd_width - 16, 9)];
    self.winImageView.image = [UIImage imageNamed:@""];
    self.winImageView.hidden = YES;
    [self.contentView addSubview:self.winImageView];
    
    [self setNeedsDisplay];
}

- (void)setIswin:(BOOL)iswin
{
    if (iswin) {
        self.winImageView.hidden = NO;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.iswin) {
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    }else
    {
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    }
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.hd_height - 1);
    CGContextAddLineToPoint(context, self.hd_width, self.hd_height - 1);
    CGContextStrokePath(context);
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
