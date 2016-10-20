//
//  UserFrienfCircleCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "UserFrienfCircleCell.h"
#import "UserFriendCircleImageView.h"

@interface UserFrienfCircleCell ()

@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UserFriendCircleImageView * imageCircleView;
@property (nonatomic, strong)UILabel * contentLabel;


@end

@implementation UserFrienfCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)creatcontantViewWith:(UserFriendCircleModel *)model
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, 60, 24)];
    self.timeLabel.textColor = UIColorFromRGB(0x323232);
    self.timeLabel.attributedText = [self gettimeText:model.creatTime];
    [self.contentView addSubview:self.timeLabel];
    
    if (model.takeImageArr.count > 0) {
        self.imageCircleView = [[UserFriendCircleImageView alloc]initWithFrame:CGRectMake(72, 30, 61, 61) imageurlArr:model.takeImageArr];
        [self.contentView addSubview:self.imageCircleView];
        
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 30, screenWidth - 166, 10)];
        self.contentLabel.textColor = UIColorFromRGB(0x323232);
        self.contentLabel.text = model.takeContent;
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        CGSize size = [model.takeContent boundingRectWithSize:CGSizeMake(screenWidth - 21 - 145, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        if (size.height > 61) {
            self.contentLabel.hd_height = 61;
        }else
        {
            self.contentLabel.hd_height = size.height;
        }
        
    }else
    {
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 30, screenWidth - 93, 10)];
        self.contentLabel.textColor = UIColorFromRGB(0x323232);
        self.contentLabel.text = model.takeContent;
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        CGSize size = [model.takeContent boundingRectWithSize:CGSizeMake(screenWidth - 21 - 72, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        if (size.height > 61) {
            self.contentLabel.hd_height = 61;
        }else
        {
            self.contentLabel.hd_height = size.height;
        }
    }
    
//    UIView * buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 0.7, screenWidth, 0.7)];
//    buttomView.backgroundColor = [UIColor colorWithWhite:.7 alpha:0.5];
//    [self.contentView addSubview:buttomView];
    
     [self setNeedsDisplay];
}

- (NSMutableAttributedString *)gettimeText:(NSNumber *)number
{
    double lastactivityInterval = [number doubleValue];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"MM-dd";
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
    
    NSLog(@"time = %.0f", time);
    
    NSString * timeStr =@"";
     if (time < 3600 * 24) {
        timeStr = @"今天";
         NSMutableAttributedString * timeStrMutable = [[NSMutableAttributedString alloc]initWithString:timeStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]}];
         return timeStrMutable;
         
    } else {
        timeStr = [fomatter stringFromDate:date];
        NSArray * timeArr = [timeStr componentsSeparatedByString:@"-"];
        
        NSString * timeString = [NSString stringWithFormat:@"%@%@月", timeArr[1], timeArr[0]];
        
        NSMutableAttributedString * timeStrMutable = [[NSMutableAttributedString alloc]initWithString:timeString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        
        [timeStrMutable setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]} range:NSMakeRange(0, 2)];
        return timeStrMutable;
    }
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rect);
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, .5);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, .7);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.hd_height - 0.7);
    CGContextAddLineToPoint(context, self.hd_width, self.hd_height - 0.7);
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
