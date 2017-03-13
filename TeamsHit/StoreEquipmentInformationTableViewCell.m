//
//  StoreEquipmentInformationTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "StoreEquipmentInformationTableViewCell.h"


@implementation StoreEquipmentInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(StoreEquipmentInfoModel *)model
{
    self.numberLB.text = [NSString stringWithFormat:@"%ld", model.number];
    self.equipmentNumberLB.text = [NSString stringWithFormat:@"%@", model.equipmentNumber];
    self.printNumberLB.text = [NSString stringWithFormat:@"%d", model.ptintNumber];
    
    switch (model.equipmentState) {
        case 0:
            self.stateLB.text = @"在线";
            break;
        case 1:
            self.stateLB.text = @"缺纸";
            break;
        case 2:
            self.stateLB.text = @"温度保护报警";
            break;
        case 3:
            self.stateLB.text = @"忙碌";
            break;
        case 4:
            self.stateLB.text = @"离线";
            break;
            
        default:
            break;
    }
    
}

- (IBAction)deleteAction:(id)sender {
    if (self.Myblock) {
        _Myblock(@"delete");
    }
}
- (IBAction)editAction:(id)sender {
    if (self.Myblock) {
        _Myblock(@"edit");
    }
}

- (void)operationAction:(OperationBlock )block
{
    self.Myblock = [block copy];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
