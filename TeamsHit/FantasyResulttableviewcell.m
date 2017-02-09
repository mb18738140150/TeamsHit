//
//  FantasyResulttableviewcell.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyResulttableviewcell.h"

#define LEFTSPACE 6
#define TOPSPACE 10
#define IMAGEWIDTH 30
#define LABELHEIGHT 15


@interface FantasyResulttableviewcell ()

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * bonusLabel;

@end

@implementation FantasyResulttableviewcell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self creatSubviews];
//    }
//    return self;
//}

- (void)creatSubviews
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFTSPACE, TOPSPACE, IMAGEWIDTH, IMAGEWIDTH)];
    self.iconImageView.layer.cornerRadius = IMAGEWIDTH / 2;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 9, CGRectGetMidY(_iconImageView.frame) - LABELHEIGHT / 2, 80, LABELHEIGHT)];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nameLabel];
    
    self.bonusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 50, CGRectGetMinY(_nameLabel.frame), 50, LABELHEIGHT)];
    self.bonusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.bonusLabel];
    
}

- (void)setGamerInfoModel:(FantasyGamerInfoModel *)gamerInfoModel
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:gamerInfoModel.gameUserInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    self.nameLabel.text = gamerInfoModel.gameUserInfo.name;
    NSLog(@"gamerInfoModel.winCoins = %d", gamerInfoModel.winCoins);
    
    
    if (gamerInfoModel.isWin == IsWinTheFantasyGame_win) {
        self.bonusLabel.textColor = UIColorFromRGB(0xFF0700);
        if (gamerInfoModel.winCoins > 0) {
            self.bonusLabel.text = [NSString stringWithFormat:@"+%d", gamerInfoModel.winCoins];
        }else
        {
            self.bonusLabel.text = [NSString stringWithFormat:@"%d", gamerInfoModel.winCoins];
        }
    }else
    {
        self.bonusLabel.textColor = UIColorFromRGB(0x19EC19);
        if (gamerInfoModel.winCoins > 0) {
            self.bonusLabel.text = [NSString stringWithFormat:@"-%d", gamerInfoModel.winCoins];
        }else
        {
            self.bonusLabel.text = [NSString stringWithFormat:@"%d", gamerInfoModel.winCoins];
        }
    }
    if (gamerInfoModel.isUserself) {
        self.nameLabel.textColor = UIColorFromRGB(0x12B7F5);
        self.bonusLabel.textColor = UIColorFromRGB(0xFFFFFF);
    }else
    {
        self.nameLabel.textColor = UIColorFromRGB(0xFFFFFF);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
