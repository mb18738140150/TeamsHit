//
//  SearcgGroupListCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SearcgGroupListCell.h"
#import "SearchGroupListModel.h"

@implementation SearcgGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(RCDGroupInfo *)model
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    self.groupNamelabel.text = [NSString stringWithFormat:@"%@", model.groupName];
    self.numberOfGroup.text = [NSString stringWithFormat:@"%@", model.number];
    self.groupDetailes.text = model.introduce;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
