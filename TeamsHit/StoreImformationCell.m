//
//  StoreImformationCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/27.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "StoreImformationCell.h"

@implementation StoreImformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.autoReciveorderBT setImage:[[UIImage imageNamed:@"forbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.autoReciveorderBT setImage:[[UIImage imageNamed:@"noForbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(printHistory:)];
    
    [self.printHistoryView addGestureRecognizer:tap];
    
}

- (void)setModel:(StoreinformationModel *)model
{
    self.storeuserName.text = model.storeUserName;
    self.storeNameLB.text = model.storeName;
    self.storeidLB.text = model.storeId;
    if (model.autoreciveOrder) {
        self.autoReciveorderBT.selected = YES;
    }else
    {
        self.autoReciveorderBT.selected = NO;
    }
}

- (void)autoReceiveOrderAction:(AutoReceiveBlock)block
{
    self.myBlock = [block copy];
}
- (IBAction)autoReceivePrder:(id)sender {
    
    if (self.myBlock) {
        if (self.autoReciveorderBT.selected) {
            _myBlock(0);
        }else
        {
            _myBlock(1);
        }
    }
    
}

- (void)printHistory:(id)sender {
    
    if (self.myBlock) {
        _myBlock(100);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
