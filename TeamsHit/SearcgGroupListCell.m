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


- (void)setModel:(SearchGroupListModel *)model
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.groupIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.groupNamelabel.text = [NSString stringWithFormat:@"%@", model.GroupName];
    self.numberOfGroup.text = [NSString stringWithFormat:@"%@", model.GroupPeople];
    self.groupDetailes.text = model.groupIntro;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
