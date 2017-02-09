//
//  FantasyPublishCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyPublishCollectionViewCell.h"
#import "CardView.h"

#define BONUSPOOLBACKIMAGEVIEW_TAG 20000


@interface FantasyPublishCollectionViewCell ()


@property (nonatomic, strong)CardView * publicCard;


@end

@implementation FantasyPublishCollectionViewCell

- (void)creatSubviews
{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView removeAllSubviews];
    UIImageView * bonusPoolBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 22, 120, 46)];
    bonusPoolBackImageView.image = [UIImage imageNamed:@"bonuspoolBackgroundImage"];
    bonusPoolBackImageView.tag = BONUSPOOLBACKIMAGEVIEW_TAG;
    [self.contentView addSubview:bonusPoolBackImageView];
    
    UIImageView * bonusSignImageView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 14, 22, 18)];
    bonusSignImageView.image = [UIImage imageNamed:@"fantasy_bonuspool"];
    bonusSignImageView.backgroundColor = [UIColor clearColor];
    [bonusPoolBackImageView addSubview:bonusSignImageView];
    
//    self.clipsToBounds = YES;
    
    self.bonusLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 16, 80, 16)];
    self.bonusLabel.textColor = [UIColor whiteColor];
    self.bonusLabel.font = [UIFont systemFontOfSize:15];
    self.bonusLabel.text = @"奖池 267890";
    [bonusPoolBackImageView addSubview:_bonusLabel];
    
    if (screenWidth > 320) {
        self.publicCard = [[CardView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bonusPoolBackImageView.frame) + 58, 15, 49, 70)];
        _publicCard.frame = CGRectMake(CGRectGetMaxX(bonusPoolBackImageView.frame) + 58, 15, 49, 70);
    }else
    {
        self.publicCard = [[CardView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bonusPoolBackImageView.frame) + 28, 15, 49, 70)];
        _publicCard.frame = CGRectMake(CGRectGetMaxX(bonusPoolBackImageView.frame) + 28, 15, 49, 70);
    }
    [self.contentView addSubview:_publicCard];
    
//    FantasyGamerCardInfoModel * fantasyModel = [[FantasyGamerCardInfoModel alloc]init];
//    fantasyModel.fantasyCardColor = FantasyCardColor_hearts;
//    fantasyModel.cardNumber = @"10";
//    _publicCard.cardModel = fantasyModel;
    
    
    UIImageView * publicCardSign = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_publicCard.frame) - 10, CGRectGetMinY(_publicCard.frame) - 10, 19, 19)];
    publicCardSign.image = [UIImage imageNamed:@"fantasy_publishCardsign"];
    [self.contentView addSubview:publicCardSign];
    
    self.changePrivateCardBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _changePrivateCardBT.frame = CGRectMake((self.hd_width - 57) / 2, 92, 57, 20);
    [_changePrivateCardBT setImage:[UIImage imageNamed:@"fantasy_enchange_Private"] forState:UIControlStateNormal];
    [self.contentView addSubview:_changePrivateCardBT];
    
    self.changePublicCardBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _changePublicCardBT.frame = CGRectMake(0, 92, 57, 20);
    [_changePublicCardBT setImage:[UIImage imageNamed:@"fantasy_exchange_public"] forState:UIControlStateNormal];
    [self.contentView addSubview:_changePublicCardBT];
    
    self.noChangeCardBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _noChangeCardBT.frame = CGRectMake(0, 92, 57, 20);
    [_noChangeCardBT setImage:[UIImage imageNamed:@"fantasy_noexchange"] forState:UIControlStateNormal];
    [self.contentView addSubview:_noChangeCardBT];
    
    if (screenWidth > 320) {
        _changePublicCardBT.frame = CGRectMake(CGRectGetMinX(_changePrivateCardBT.frame)  - 120, 92, 57, 20);
        _noChangeCardBT.frame = CGRectMake(CGRectGetMaxX(_changePrivateCardBT.frame)  + 64, 92, 57, 20);
    }else
    {
        _changePublicCardBT.frame = CGRectMake(CGRectGetMinX(_changePrivateCardBT.frame)  - 110, 92, 57, 20);
        _noChangeCardBT.frame = CGRectMake(CGRectGetMaxX(_changePrivateCardBT.frame)  + 54, 92, 57, 20);
    }
    
}

- (void)hideOperationBT
{
    self.changePublicCardBT.hidden = YES;
    self.changePrivateCardBT.hidden = YES;
    self.noChangeCardBT.hidden = YES;
}

- (void)setBonusModel:(BonusPoolModel *)bonusModel
{
    self.bonusLabel.text = [NSString stringWithFormat:@"奖池 %@", bonusModel.bonus];
    CGSize bonuspoollabelsize = [self.bonusLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bonusLabel.hd_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    if (bonuspoollabelsize.width > 80) {
        UIView * bonuspoolbackimageView = [self.contentView viewWithTag:BONUSPOOLBACKIMAGEVIEW_TAG];
        bonuspoolbackimageView.hd_width += bonuspoollabelsize.width - 80;
        self.bonusLabel.hd_width = bonuspoollabelsize.width;
    }
    
    self.publicCard.cardModel = bonusModel.publiccardInfoModel;
}

@end
