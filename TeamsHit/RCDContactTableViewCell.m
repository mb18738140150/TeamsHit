//
//  RCDContactTableViewCell.m
//  RCloudMessage
//
//  Created by Jue on 16/3/16.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDContactTableViewCell.h"

@interface RCDContactTableViewCell()
@property (nonatomic, copy)SelectBlock selectBlock;

@end

@implementation RCDContactTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    [self.contentView addSubview:_portraitView];
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 27, self.hd_width - 140, 16)];
    [_nicknameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [self.contentView addSubview:_nicknameLabel];
    
    _selectStateBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectStateBT.frame = CGRectMake(self.hd_width - 55, 23, 23, 23);
    _selectStateBT.backgroundColor = [UIColor whiteColor];
    [_selectStateBT setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_selectStateBT setImage:[UIImage imageNamed:@"f2"] forState:UIControlStateSelected];
    [self.contentView addSubview:_selectStateBT];
    _selectStateBT.layer.cornerRadius = 3;
    _selectStateBT.layer.masksToBounds = YES;
    _selectStateBT.layer.borderColor = UIColorFromRGB(0xA6A6A6).CGColor;
    _selectStateBT.layer.borderWidth = 1;
    _selectStateBT.hidden = YES;
    
    [_selectStateBT addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)awakeFromNib {
    // Initialization code
    
}

- (void)selectAction:(UIButton *)buton
{
    buton.selected = !buton.selected;
    if (self.selectBlock) {
        _selectBlock(buton.selected);
    }
}

- (void)getSelectState:(SelectBlock)selectBlock
{
    self.selectBlock = [selectBlock copy];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
