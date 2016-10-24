//
//  PayHistoryTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PayHistoryTableViewCell.h"

@interface PayHistoryTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderidLabel;
@property (strong, nonatomic) IBOutlet UILabel *payAmount;

@property (strong, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acturePayAmount;
@property (strong, nonatomic) IBOutlet UILabel *orderStateLabel;


@end

@implementation PayHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(PayhistoryModel *)model
{
    self.payTimeLabel.attributedText = [self gettimeText:model.orderTime];
    self.orderidLabel.text = [NSString stringWithFormat:@"订单号：%@", model.orderId];
    self.payAmount.text = [NSString stringWithFormat:@"充值数量：%.d", model.coinCount];
    self.acturePayAmount.text = [NSString stringWithFormat:@"实付金额：%.2f", model.money];
    self.payTypeLabel.text = [NSString stringWithFormat:@"支付方式：%@", model.payType];
    self.orderStateLabel.text = [NSString stringWithFormat:@"订单状态：%@", model.orderState];
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
    
    NSMutableAttributedString * timeStrMutable = [[NSMutableAttributedString alloc]initWithString:timeStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    return timeStrMutable;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
