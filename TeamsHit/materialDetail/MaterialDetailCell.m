//
//  MaterialDetailCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MaterialDetailCell.h"

@implementation MaterialDetailCell



- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * borderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 34)];
    borderView.backgroundColor = [UIColor whiteColor];
    borderView.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    borderView.layer.borderWidth = 1;
    [self.contentView addSubview:borderView];
    
    self.detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 3, self.hd_width - 14, self.hd_height - 34 - 5)];
    [self.contentView addSubview:self.detailImageView];
    
    self.zoomerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(borderView.hd_width - 15, borderView.hd_height - 15, 14, 14)];
    self.zoomerImageView.image = [UIImage imageNamed:@"zoomer"];
    [self.contentView addSubview:self.zoomerImageView];
    
    self.addBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBT.frame = CGRectMake(5, borderView.hd_height + 7, (borderView.hd_width - 20) / 2, 20);
    self.addBT.backgroundColor = UIColorFromRGB(0xD9524E);
    self.addBT.layer.cornerRadius = 3;
    self.addBT.layer.masksToBounds = YES;
    [self.addBT setTitle:@"添加" forState:UIControlStateNormal];
    self.addBT.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.addBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addBT];
    
    self.printBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.printBT.frame = CGRectMake(borderView.hd_width - 5 - (borderView.hd_width - 20) / 2, borderView.hd_height + 7, (borderView.hd_width - 20) / 2, 20);
    self.printBT.backgroundColor = UIColorFromRGB(0x5CB95C);
    self.printBT.layer.cornerRadius = 3;
    self.printBT.layer.masksToBounds = YES;
    [self.printBT setTitle:@"打印" forState:UIControlStateNormal];
    self.printBT.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.printBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.printBT];
    
    if (self.isHavenotAddBt) {
        self.addBT.hidden = YES;
        self.printBT.hd_centerX = self.hd_centerX;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
