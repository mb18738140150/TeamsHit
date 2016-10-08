//
//  BragGameScoreTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BragGameScoreTableViewCell.h"

@interface BragGameScoreTableViewCell ()

{
    BOOL win;
}

@end

@implementation BragGameScoreTableViewCell

- (void)creatWithFrame:(CGRect)frame
{
    win = NO;
    [self prepareUI];
}
- (void)prepareUI
{
    [self.contentView removeAllSubviews];
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 1)];
    self.numberLabel.font = [UIFont systemFontOfSize:(int)self.hd_height - 2];
    self.numberLabel.textColor = UIColorFromRGB(0x38BBF8);
    self.numberLabel.backgroundColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = 1;
    [self.contentView addSubview:self.numberLabel];
    
    self.winImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, self.hd_height - 10, self.hd_width - 16, 9)];
    self.winImageView.image = [UIImage imageNamed:@"船"];
    self.winImageView.hidden = YES;
    [self.contentView addSubview:self.winImageView];
    
    [self setNeedsDisplay];
}

- (void)setIswin:(BOOL)iswin
{
    if (iswin) {
        self.winImageView.hidden = NO;
        win = YES;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (win) {
//        NSLog(@"赢了");
        [self drawRedLin];
    }else
    {
        [self drawWhiteLine];
    }
}

- (void)drawWhiteLine
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, .5);
    CGContextAddLineToPoint(context, 33, .5);
    CGContextStrokePath(context);

}

- (void)drawRedLin
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, .5);
    CGContextAddLineToPoint(context, 33, .5);
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
