//
//  OrderPrintTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/10.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "OrderPrintTableViewCell.h"

@implementation OrderPrintTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PrintOrderModel *)model
{
    _model = model;
    self.recieverNameLB.text = [NSString stringWithFormat:@"收货人:%@", model.receiver];
    self.printTimeLB.text = @"00:00";
    self.orderNumber.text = model.orderNumber;
    
    switch (model.printOrderType) {
        case Print_Nomal:
        {
            self.selectImageView.hidden = YES;
        }
            break;
        case Print_NOSelect:
        {
            self.selectImageView.hidden = NO;
            self.selectImageView.image = [UIImage imageNamed:@"printOrderUnselect"];
        }
            break;
        case Print_Select:
        {
            self.selectImageView.hidden = NO;
            self.selectImageView.image = [UIImage imageNamed:@"printOrderSelect"];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
