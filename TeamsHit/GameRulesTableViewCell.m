//
//  GameRulesTableViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GameRulesTableViewCell.h"

@implementation GameRulesTableViewCell

- (void)creatCellWithFrame:(CGRect)frame
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.numberlabel) {
        self.numberlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        self.numberlabel.backgroundColor = UIColorFromRGB(0x12B7F5);
        self.numberlabel.textColor = [UIColor whiteColor];
        self.numberlabel.textAlignment = 1;
        self.numberlabel.layer.cornerRadius = 8;
        self.numberlabel.layer.masksToBounds = YES;
        self.numberlabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.numberlabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.hd_width - 20, self.hd_height - 8)];
        self.contentLabel.textColor = UIColorFromRGB(0x12B7F5);
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.contentLabel];
        
    }
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
