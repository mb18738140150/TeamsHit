//
//  TakeoutAccountTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "TakeoutAccountTableViewCell.h"

@implementation TakeoutAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTakeouttypename:(NSString *)takeouttypename
{
    self.takeoutTyoeLabel.text = takeouttypename;
    if ([takeouttypename isEqualToString:@"美团"]) {
        self.takeoutTyoeLabel.textColor = UIColorFromRGB(0xEDBB1B);
    }else if ([takeouttypename isEqualToString:@"饿了么"])
    {
        self.takeoutTyoeLabel.textColor = UIColorFromRGB(0x3286C5);
    }else
    {
        self.takeoutTyoeLabel.textColor = UIColorFromRGB(0xE7304F);
    }
}

- (IBAction)quickLoginAction:(id)sender {
    if (self.myBlock) {
        self.myBlock();
    }
}

- (void)quickLogin:(QuickloginBlock)block
{
    self.myBlock = [block copy];
}

@end
