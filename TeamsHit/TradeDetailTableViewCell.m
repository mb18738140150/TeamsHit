//
//  TradeDetailTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TradeDetailTableViewCell.h"

@interface TradeDetailTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *tradeTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *tradeTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *tradeCountLabel;


@end

@implementation TradeDetailTableViewCell


- (void)setModel:(TransactiondetailsModel *)model
{
    self.tradeTimeLabel.attributedText = [self gettimeText:model.tradeTime];
    
    self.tradeTypeLabel.text = [NSString stringWithFormat:@"%@", model.tradeTitle];
    self.tradeCountLabel.attributedText = [self getCount:model.tradeCoinCount];
}


- (NSMutableAttributedString *)gettimeText:(NSNumber *)number
{
    double lastactivityInterval = [number doubleValue];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"YYYY-MM-dd";
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
    
    NSLog(@"time = %.0f", time);
    
    NSString * timeStr =@"";
   
        timeStr = [fomatter stringFromDate:date];
    
        
        NSMutableAttributedString * timeStrMutable = [[NSMutableAttributedString alloc]initWithString:timeStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
        return timeStrMutable;
    
    
}

- (NSAttributedString *)getCount:(NSNumber *)count
{
    NSString * str = @"";
    if (count.intValue > 0) {
        str = [NSString stringWithFormat:@"+%@个", count];
        NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xD9524E)}];
        return attStr;
    }else{
        str = [NSString stringWithFormat:@"%@个", count];
        NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x5CB95C)}];
        return attStr;
    }
    
}
- (void)creatButtomLine
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 1.0);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 15, 66);
    CGContextAddLineToPoint(context, screenWidth - 15, 66);
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
