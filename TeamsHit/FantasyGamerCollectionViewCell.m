//
//  FantasyGamerCollectionViewCell.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyGamerCollectionViewCell.h"
#import "FantasyGamerCardInfoModel.h"
#import "FantasyCardFlowlayout.h"
#import "FantasyGamerCardCollectionViewCell.h"

#define FANTASYGAMERCARDCOLLECTIONViewCell @"FantasyGamerCardCollectionViewCellID"

@interface FantasyGamerCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSMutableArray * cardInfoArr;


@property (nonatomic, strong)UILabel * gamernameLabel;
@property (nonatomic, strong)UIImageView * operationView;
@property (nonatomic, strong)UILabel * operationLabel;

@property (nonatomic, strong)NSTimer * timer_nochangecard;

@end

@implementation FantasyGamerCollectionViewCell

- (NSMutableArray *)cardInfoArr
{
    if (!_cardInfoArr) {
        _cardInfoArr = [NSMutableArray array];
    }
    return _cardInfoArr;
}

- (void)creatSubviews
{
    [self.contentView removeAllSubviews];
    FantasyCardFlowlayout * layout = [[FantasyCardFlowlayout alloc]init];
    self.cardCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake((self.hd_width - 80) / 2, 0, 80, 70) collectionViewLayout:layout];
    _cardCollectionView.backgroundColor = [UIColor clearColor];
    _cardCollectionView.scrollEnabled = NO;
    _cardCollectionView.delegate = self;
    _cardCollectionView.dataSource = self;
    [_cardCollectionView registerClass:[FantasyGamerCardCollectionViewCell class] forCellWithReuseIdentifier:FANTASYGAMERCARDCOLLECTIONViewCell];
    [self.contentView addSubview:_cardCollectionView];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_cardCollectionView.frame) +2, CGRectGetMaxY(_cardCollectionView.frame) + 8, 23, 24)];
    self.iconImageView.layer.cornerRadius = 12;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.image = [UIImage imageNamed:@"logo(1)"];
    [self.contentView addSubview:_iconImageView];
    
    self.gamernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, CGRectGetMaxY(_cardCollectionView.frame) + 14, self.hd_width - (CGRectGetMaxX(_iconImageView.frame) + 10), 14)];
    _gamernameLabel.textColor = [UIColor whiteColor];
    _gamernameLabel.font = [UIFont systemFontOfSize:12];
    _gamernameLabel.text = @"生活很快乐啊啊啊";
    [self.contentView addSubview:_gamernameLabel];
    
    self.operationView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_cardCollectionView.frame) +17, CGRectGetMinY(_cardCollectionView.frame) + 27, 46, 15)];
    self.operationView.image = [UIImage imageNamed:@"fantasy_changeCard"];
    [self.contentView addSubview:_operationView];
    
    self.operationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 48, 11)];
    self.operationLabel.textColor = UIColorFromRGB(0xF8B551);
    self.operationLabel.font = [UIFont systemFontOfSize:10];
    self.operationLabel.textAlignment = 1;
    [self.operationView addSubview:_operationLabel];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.cardInfoArr.count >0) {
        return self.cardInfoArr.count;
    }else
    {
        return 2;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FantasyGamerCardCollectionViewCell * cardCell = [collectionView dequeueReusableCellWithReuseIdentifier:FANTASYGAMERCARDCOLLECTIONViewCell forIndexPath:indexPath];
    [cardCell creatSubViews];
    if (self.cardInfoArr.count > 1) {
        FantasyGamerCardInfoModel * cardInfoModel = self.cardInfoArr[indexPath.row];
        cardCell.gamerCardInfoModel = cardInfoModel;
        if (self.gamerInfoModel.isWin == IsWinTheFantasyGame_lose) {
            [cardCell showLosecard];
        }
    }
    
    return cardCell;
}

- (void)setGamerInfoModel:(FantasyGamerInfoModel *)gamerInfoModel
{
    _gamerInfoModel = gamerInfoModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", gamerInfoModel.gameUserInfo.portraitUri]] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    self.gamernameLabel.text = [NSString stringWithFormat:@"%@", gamerInfoModel.gameUserInfo.name];
    self.cardInfoArr = gamerInfoModel.cardInfoArr;
    self.operationLabel.textColor = UIColorFromRGB(0xF8B551);
    self.operationView.hidden = NO;
    switch (gamerInfoModel.exchangeCardType) {
        case ExchangeCardType_nomal:
            self.operationView.hidden = YES;
            break;
        case ExchangeCardType_no:{
            self.operationView.hidden = NO;
            self.operationLabel.text = @"不换";
            __weak FantasyGamerCollectionViewCell * weakSelf = self;
                self.timer_nochangecard = [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                    weakSelf.operationView.hidden = YES;
                    [weakSelf.timer_nochangecard invalidate];
                    weakSelf.timer_nochangecard = nil;
                }];
        }
            break;
        case ExchangeCardType_public:{
            
            self.operationView.hidden = NO;
            self.operationLabel.text = @"换公牌";
        }
            break;
        case ExchangeCardType_private:{
            
            self.operationView.hidden = NO;
            self.operationLabel.text = @"换底牌";
        }
            break;
        case ExchangeCardType_Wait:
        {
            
            self.operationView.hidden = NO;
            self.operationLabel.text = @"纠结中";
            NSLog(@"*****  %@ %@ 纠结中",gamerInfoModel.gameUserInfo.name, gamerInfoModel.gameUserInfo.userId);
            self.operationLabel.textColor = UIColorFromRGB(0x12b7f5);
        }
            break;
        default:
            break;
    }
    if (gamerInfoModel.isUserself) {
        self.gamernameLabel.textColor = UIColorFromRGB(0xDB2B2B);
        self.operationView.hidden = YES;
    }
    
    [self.cardCollectionView reloadData];
    
}

@end
