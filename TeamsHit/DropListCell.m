//
//  DropListCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "DropListCell.h"

@implementation DropListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    
    self.backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 28, 28)];
    [self.contentView addSubview:self.backimageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 30)];
    self.titleLabel.textAlignment = 1;
    [self.contentView addSubview:self.titleLabel];
    
    self.imageView.hidden = YES;
    self.titleLabel.hidden = YES;
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
