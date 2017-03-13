//
//  SigninDateCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/1.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "SigninDateCollectionViewCell.h"

@implementation SigninDateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SigninModel *)model
{
    // 普通签到
    self.backImageView.image = [UIImage imageNamed:@"signin_oringecircle_e"];
    
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"dd";
    NSString * dateStr = [fomatter stringFromDate:date];
    
    // 今天签到显示全填充橙色圆
    if (dateStr.intValue == model.MonthToDay) {
        self.backImageView.image = [UIImage imageNamed:@"signin_oringecircle"];
    }
    // 连续七天签到
    if (model.conSignDay == 7) {
        self.backImageView.image = [UIImage imageNamed:@"sign_redcircle"];
    }
}

-(void)cleanContaintView
{
    self.dateLB.text = @"";
    self.backImageView.image = [UIImage new];
}

@end
