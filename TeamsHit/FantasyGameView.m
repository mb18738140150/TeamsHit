//
//  FantasyGameView.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyGameView.h"
#import "FantasygamerLayout.h"
#import "FantasyGamerCollectionViewCell.h"
#import "FantasyCollectionReusableView.h"
#import "FantasyPublishCollectionViewCell.h"
#import "FantasyGamerInfoModel.h"
#import "FantasyGamerCardInfoModel.h"
#import "BonusPoolModel.h"

#define FANTASYGAMERCOLLECTIONViewCellID @"FantasyGamerCollectionViewCellID"
#define FANTASYPUBLICCOLLECTIONViewCellID @"FantasyPublishCollectionViewCellID"
#define FANTASYREUSABLEVIEWID @"fantasyreusableviewId"
#define COINIMAGEVIEWTAG 12121212

typedef enum :NSInteger{
    Game_prepare = 0,
    Game_Start_noturnRefresh = 1,
    Game_start_refresh = 2,
}GameState;


@interface FantasyGamerIconFrameModel : NSObject

@property (nonatomic, copy)NSString * userId;
@property (nonatomic, assign)CGPoint startPoint;

@end

@implementation FantasyGamerIconFrameModel

@end

@interface FantasyGameView()<UICollectionViewDelegate, UICollectionViewDataSource, CAAnimationDelegate>

@property (nonatomic, strong)UICollectionView * gameCollectionView;
@property (nonatomic, assign)BOOL isturnUserSelf;
@property (nonatomic, assign)BOOL isGameFinish;

@property (nonatomic, strong)NSTimer * timeout;
@property (nonatomic, assign)int timeoutNumber;

@property (nonatomic, strong)NSMutableArray * resultDataSource;
// 游戏结束逐个刷新cell
@property (nonatomic, assign)GameState gameStart;
@property (nonatomic, strong)NSMutableArray * indexpathArr;
@property (nonatomic, assign)int  refreshNUmber;
@property (nonatomic, strong)NSTimer * turnRefreshTimer;
@property (nonatomic, strong)UIButton * quitBT;

@property (nonatomic, strong)NSDate * lastOperationDate;

// 抛金币动画玩家头像frame
@property (nonatomic, strong)NSMutableArray * gamerIconFrames;
@property (nonatomic, assign)CGPoint  endPoint_bonusPoolPoint;

@property (nonatomic, strong)NSNumber * winUserId;
// 奖池model
@property (nonatomic, strong)BonusPoolModel * bonusModel;

@end

@implementation FantasyGameView

- (NSMutableArray *)indexpathArr
{
    if (!_indexpathArr) {
        self.indexpathArr = [NSMutableArray array];
    }
    return _indexpathArr;
}

- (NSMutableArray *)gameUserInformationArr
{
    if (!_gameUserInformationArr) {
        self.gameUserInformationArr = [NSMutableArray array];
    }
    return _gameUserInformationArr;
}

- (NSMutableArray *)resultDataSource
{
    if (!_resultDataSource) {
        self.resultDataSource = [NSMutableArray array];
    }
    return _resultDataSource;
}

- (NSMutableArray *)gamerIconFrames
{
    if (!_gamerIconFrames) {
        _gamerIconFrames = [NSMutableArray array];
    }
    return _gamerIconFrames;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor clearColor];
    FantasygamerLayout * layout = [[FantasygamerLayout alloc]init];
    layout.itemWidth = (CGRectGetWidth(self.bounds) - 16) / 3;
//    layout.interitemSpacing = 1;
//    layout.sectionIndets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.gameCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 40) collectionViewLayout:layout];
    _gameCollectionView.delegate = self;
    _gameCollectionView.dataSource = self;
    _gameCollectionView.backgroundColor = [UIColor clearColor];
    _gameCollectionView.contentSize = CGSizeMake(_gameCollectionView.hd_width, 1000);
    [_gameCollectionView registerClass:[FantasyGamerCollectionViewCell class] forCellWithReuseIdentifier:FANTASYGAMERCOLLECTIONViewCellID];
    [_gameCollectionView registerClass:[FantasyPublishCollectionViewCell class] forCellWithReuseIdentifier:FANTASYPUBLICCOLLECTIONViewCellID];
//    [_gameCollectionView registerClass:[FantasyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FANTASYREUSABLEVIEWID];
    
    UIButton * quitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBT.frame = CGRectMake(15, CGRectGetMaxY(_gameCollectionView.frame), 40, 40);
    [quitBT setImage:[UIImage imageNamed:@"quieGameButton"] forState:UIControlStateNormal];
    [self addSubview:quitBT];
    [quitBT addTarget:self action:@selector(quitFantasyGame) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_gameCollectionView];
    
}

- (void)quitFantasyGame{
    if (self.delegate && [self.delegate respondsToSelector:@selector(quitFantasyGameView)]) {
        [self.delegate quitFantasyGameView];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.gameUserInformationArr.count > 0) {
        return self.gameUserInformationArr.count + 1;
    }else
    {
        return self.gameUserInformationArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.gameStart == Game_Start_noturnRefresh) {
        if (self.indexpathArr.count < self.gameUserInformationArr.count + 1) {
            [self.indexpathArr addObject:indexPath];
        }
    }
    
    if (indexPath.item == 3) {
        FantasyPublishCollectionViewCell * publicCell = [collectionView dequeueReusableCellWithReuseIdentifier:FANTASYPUBLICCOLLECTIONViewCellID forIndexPath:indexPath];
        [publicCell creatSubviews];
        publicCell.bonusModel = self.bonusModel;
        if (!self.isturnUserSelf) {
            [publicCell hideOperationBT];
        }else
        {
            if (self.isGameFinish) {
                [publicCell hideOperationBT];
            }else
            {
                // 轮到自己且游戏没有结束，显示操作按钮，否则隐藏
                publicCell.changePublicCardBT.hidden = NO;
                publicCell.changePrivateCardBT.hidden = NO;
                publicCell.noChangeCardBT.hidden = NO;
            }
        }
        if (self.gameStart == Game_Start_noturnRefresh) {
            UICollectionViewLayoutAttributes * attribute = [self.gameCollectionView layoutAttributesForItemAtIndexPath:indexPath];
            self.endPoint_bonusPoolPoint = CGPointMake(publicCell.bonusLabel.hd_centerX + attribute.frame.origin.x + 40, publicCell.bonusLabel.hd_centerY + attribute.frame.origin.y + 22);
        }
        [publicCell.changePublicCardBT addTarget:self action:@selector(changePublicCardAction) forControlEvents:UIControlEventTouchUpInside];
        [publicCell.changePrivateCardBT addTarget:self action:@selector(changePrivateCardAction) forControlEvents:UIControlEventTouchUpInside];
        [publicCell.noChangeCardBT addTarget:self action:@selector(nochangeCardAction) forControlEvents:UIControlEventTouchUpInside];
        return publicCell;
    }else
    {
        FantasyGamerCollectionViewCell * gamerCell = [collectionView dequeueReusableCellWithReuseIdentifier:FANTASYGAMERCOLLECTIONViewCellID forIndexPath:indexPath];
        [gamerCell creatSubviews];
        if (self.gameStart == Game_start_refresh) {
            gamerCell.cardCollectionView.hidden = NO;
        }else
        {
            gamerCell.cardCollectionView.hidden = YES;
        }
        if (indexPath.row <3) {
            gamerCell.gamerInfoModel = self.gameUserInformationArr[indexPath.row];
        }else
        {
            gamerCell.gamerInfoModel = self.gameUserInformationArr[indexPath.row - 1];
        }
        
        if (self.gameStart == Game_Start_noturnRefresh) {
            
            UICollectionViewLayoutAttributes * attribute = [self.gameCollectionView layoutAttributesForItemAtIndexPath:indexPath];
            
            FantasyGamerIconFrameModel * iconFrameModel = [[FantasyGamerIconFrameModel alloc]init];
            iconFrameModel.userId = gamerCell.gamerInfoModel.gameUserInfo.userId;
            iconFrameModel.startPoint = CGPointMake(gamerCell.iconImageView.hd_centerX + attribute.frame.origin.x, gamerCell.iconImageView.hd_centerY + attribute.frame.origin.y);
            [self.gamerIconFrames addObject:iconFrameModel];
        }
        
        return gamerCell;
    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView * reusableview = nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        FantasyCollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FANTASYREUSABLEVIEWID forIndexPath:indexPath];
//        reusableview = footerView;
//    }
//    NSLog(@"UICollectionReusableView");
//    return reusableview;
//}

- (void)changePublicCardAction
{
    if ([self operationFrequently]) {
        return;
    }
    [self closeTimeOut];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePublicCard)]) {
        [_delegate changePublicCard];
    }
}

- (void)changePrivateCardAction
{
    if ([self operationFrequently]) {
        return;
    }
    [self closeTimeOut];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePrivateCard)]) {
        [_delegate changePrivateCard];
    }
}

- (void)nochangeCardAction
{
    [self closeTimeOut];
    if (self.delegate && [self.delegate respondsToSelector:@selector(nochangeCard)]) {
        [_delegate nochangeCard];
    }
}

#pragma startGame
- (void)cratGameUserInformation:(NSArray *)userInfoArr withDic:(NSDictionary *)dic
{
    NSArray * gameUserInfoArr = [dic objectForKey:@"UserList"];
    
    self.lastOperationDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    if (!self.bonusModel) {
        self.bonusModel = [[BonusPoolModel alloc]init];
    }
    self.bonusModel.bonus = [dic objectForKey:@"Bonus"];
    self.bonusModel.publiccardInfoModel = [self cardinfoModelWith:[[dic objectForKey:@"CommonCard"] intValue]];
    
    [self.gameUserInformationArr removeAllObjects];
    for (int i = 0; i < gameUserInfoArr.count; i++) {
        
        NSDictionary * userDic = [gameUserInfoArr objectAtIndex:i];
        NSDictionary * userinfoDic = [userDic objectForKey:@"User"];
        
        RCUserInfo * userInfo = [RCUserInfo new];
        userInfo.name = [userinfoDic objectForKey:@"DisplayName"];
        userInfo.userId = [NSString stringWithFormat:@"%@", [userinfoDic objectForKey:@"UserId"]];
        userInfo.portraitUri = [userinfoDic objectForKey:@"PortraitUri"];
        
        FantasyGamerInfoModel * model = [[FantasyGamerInfoModel alloc]init];
        model.gameUserInfo = [RCUserInfo new];
        model.gameUserInfo.name = [userinfoDic objectForKey:@"DisplayName"];
        model.gameUserInfo.portraitUri = [userinfoDic objectForKey:@"PortraitUri"];
        model.gameUserInfo.userId = [NSString stringWithFormat:@"%@", [userinfoDic objectForKey:@"UserId"]];
        model.exchangeCardType = ExchangeCardType_nomal;
        model.isWin = IsWinTheFantasyGame_nomal;
        model.isFinish = NO;
        
        // 输赢
        if ([[userDic objectForKey:@"WinUserId"] intValue] == userInfo.userId.intValue) {
            model.isWin = IsWinTheFantasyGame_win;
        }else
        {
            model.isWin = IsWinTheFantasyGame_nomal;
            if (model.isFinish) {
                model.isWin = IsWinTheFantasyGame_lose;
            }
        }
        // 是否换牌
        model.exchangeCardType = ExchangeCardType_nomal;
        
        if (model.gameUserInfo.userId.intValue == [[dic objectForKey:@"LastOperationUserId"] intValue]) {
            switch ([[dic objectForKey:@"Status"] intValue]) {
                case 0:
                    break;
                case 1:
                    model.exchangeCardType = ExchangeCardType_no;
                    break;
                case 2:
                    model.exchangeCardType = ExchangeCardType_public;
                    break;
                case 3:
                    model.exchangeCardType = ExchangeCardType_private;
                    break;
                default:
                    break;
            }
        }
        
        // 该谁操作
        if ([[dic objectForKey:@"OperationUserId"] intValue] == model.gameUserInfo.userId.intValue) {
            model.exchangeCardType = ExchangeCardType_Wait;
            
            // 是否轮到自己操作
            if ([[dic objectForKey:@"OperationUserId"] intValue] == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
                self.isturnUserSelf = YES;
            }else
            {
                self.isturnUserSelf = NO;
            }
        }
        
        // 显示牌
        if ([userInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            model.isUserself = YES;
            NSArray * cardNumberArr = [[userDic objectForKey:@"CardNumber"] componentsSeparatedByString:@","];
            for (NSString * number in cardNumberArr) {
                FantasyGamerCardInfoModel * cardmodel = [self cardinfoModelWith:number.intValue];
                [model.cardInfoArr addObject:cardmodel];
            }
        }else
        {
            model.isUserself = NO;
            
            // 如果不是自己，则看是否游戏结束，结束的话给数据源填充数据，否则不填充
            if (model.isFinish) {
                NSArray * cardNumberArr = [[userDic objectForKey:@"CardNumber"] componentsSeparatedByString:@","];
                for (NSString * number in cardNumberArr) {
                    FantasyGamerCardInfoModel * cardmodel = [self cardinfoModelWith:number.intValue];
                    [model.cardInfoArr addObject:cardmodel];
                }
            }
        }
        
        // 显示换牌情况
        NSString * operationUserId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"OperationUserId"]];
        if ([operationUserId isEqualToString:model.gameUserInfo.userId]) {
            model.exchangeCardType = ExchangeCardType_Wait;
        }
        
        // 判断下一个叫点者是不是本人,是的话刷新，并添超时加定时器
        if ([operationUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            NSLog(@"**** 下一个该你叫点了 ***** ");
            if (self.timeout) {
                [self.timeout invalidate];
                self.timeout = nil;
            }
            self.timeout = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutAction) userInfo:nil repeats:YES];
        }
        
        [self.gameUserInformationArr addObject:model];
        
    }
    self.gameStart = Game_Start_noturnRefresh;
    
    [self.gameCollectionView reloadData];
    
    if ([[dic objectForKey:@"IsViewer"] intValue] == 1) {
        __weak FantasyGameView * weakSelf= self;
        NSTimer *startTurnRefresh = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^(NSTimer * _Nonnull timer) {
            weakSelf.gameStart = Game_start_refresh;
            [weakSelf.gameCollectionView reloadData];
        }];
    }else
    {
        if ([[dic objectForKey:@"IsFirstJoinGame"] intValue] == 0) {
            __weak FantasyGameView * weakSelf= self;
            NSTimer *startTurnRefresh = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                weakSelf.gameStart = Game_start_refresh;
                [weakSelf.gameCollectionView reloadItemsAtIndexPaths:@[[self.indexpathArr objectAtIndex:self.refreshNUmber]]];
                PlayMusicModel * playmusic = [PlayMusicModel share];
                [playmusic playMusicWithName:@"fantasyLicensing" type:@"mp3"];
                weakSelf.refreshNUmber++;
                weakSelf.turnRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(turnRefresh) userInfo:nil repeats:YES];
            }];
        }else
        {
            __weak FantasyGameView * weakSelf= self;
            NSTimer *startTurnRefresh = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                weakSelf.gameStart = Game_start_refresh;
                [weakSelf.gameCollectionView reloadData];
            }];
        }
    }
    
}

- (void)turnRefresh
{
    
    if (self.refreshNUmber>= self.indexpathArr.count) {
        [self.turnRefreshTimer invalidate];
        self.turnRefreshTimer = nil;
        
        for (FantasyGamerIconFrameModel * model in self.gamerIconFrames) {
            NSLog(@"model.startPoint.x = %f , model.startPoint.y = %f", model.startPoint.x, model.startPoint.y);
        }
        
        return;
    }
    [self.gameCollectionView reloadItemsAtIndexPaths:@[[self.indexpathArr objectAtIndex:self.refreshNUmber]]];
    PlayMusicModel * playmusic = [PlayMusicModel share];
    NSLog(@"游戏开始逐个刷新 = %d", self.refreshNUmber);
    [playmusic playMusicWithName:@"fantasyLicensing" type:@"mp3"];
    self.refreshNUmber++;
    if (self.refreshNUmber == 3) {
        self.refreshNUmber++;
    }
}

#pragma mark - 换底牌响应
- (void)changePrivateCard:(NSDictionary *)dic
{
    for (FantasyGamerInfoModel * model in self.gameUserInformationArr) {
        if ([model.gameUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            [model.cardInfoArr removeAllObjects];
            NSArray * cardNumberArr = [[dic objectForKey:@"CardNumber"] componentsSeparatedByString:@","];
            for (NSString * number in cardNumberArr) {
                FantasyGamerCardInfoModel * cardmodel = [self cardinfoModelWith:number.intValue];
                [model.cardInfoArr addObject:cardmodel];
            }
            
            self.bonusModel.bonus = [dic objectForKey:@"Bonus"];
            
        }
    }
    [self.gameCollectionView reloadData];
}

- (void)changePublicCardPush:(NSDictionary *)dic
{
    PlayMusicModel * playmusic = [PlayMusicModel share];
    [playmusic playMusicWithName:@"fantasyChangePublic" type:@"mp3"];
    
    self.bonusModel.bonus = [dic objectForKey:@"Bonus"];
    self.bonusModel.publiccardInfoModel = [self cardinfoModelWith:[[dic objectForKey:@"CommonCard"] intValue]];
    
    for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
        gamerModel.exchangeCardType = ExchangeCardType_nomal;
    }
    
    for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
        if (gamerModel.gameUserInfo.userId.intValue == [[dic objectForKey:@"NextUserId"] intValue]) {
            gamerModel.exchangeCardType = ExchangeCardType_Wait;
        }
        if (gamerModel.gameUserInfo.userId.intValue == [[dic objectForKey:@"UserId"] intValue]) {
            gamerModel.exchangeCardType = ExchangeCardType_public;
        }
    }
    if ([[NSString stringWithFormat:@"%@", [dic objectForKey:@"NextUserId"]] isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        self.isturnUserSelf = YES;
         [self userselftimeOutAction];
    }else
    {
        self.isturnUserSelf = NO;
    }
    [self.gameCollectionView reloadData];
    
    for (FantasyGamerIconFrameModel * iconModel in self.gamerIconFrames) {
        if (iconModel.userId.intValue == [[dic objectForKey:@"UserId"] intValue]) {
            [self startCoinAnimation:iconModel];
        }
    }
}

- (void)startCoinAnimation:(FantasyGamerIconFrameModel *)iconModel
{
    UIImageView * coinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconModel.startPoint.x, iconModel.startPoint.y, 22, 18)];
    coinImageView.tag = COINIMAGEVIEWTAG;
    coinImageView.image = [UIImage imageNamed:@"fantasySprinkleCoin"];
//    coinImageView.layer.cornerRadius = 15;
//    coinImageView.layer.masksToBounds = YES;
    [self addSubview:coinImageView];
    
    CAKeyframeAnimation * parabolic = [[CAKeyframeAnimation alloc]init];
    
    CGRect begainrect = coinImageView.frame;
    
    CGFloat height_y = begainrect.origin.y > self.endPoint_bonusPoolPoint.y ? self.endPoint_bonusPoolPoint.y : begainrect.origin.y  - 20;
    CGPoint controlPoint = CGPointMake((begainrect.origin.x + self.endPoint_bonusPoolPoint.x) / 2, height_y);
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(begainrect.origin.x, begainrect.origin.y)];
    [path addQuadCurveToPoint:CGPointMake(self.endPoint_bonusPoolPoint.x, self.endPoint_bonusPoolPoint.y) controlPoint:controlPoint];
    parabolic.keyPath = @"position";
    parabolic.path = path.CGPath;
    parabolic.calculationMode = @"cubicPaced";
    parabolic.duration = 0.8;
    parabolic.repeatCount = 0;
    parabolic.fillMode = kCAFillModeForwards;
    parabolic.removedOnCompletion = NO;
    parabolic.delegate = self;
    [coinImageView.layer addAnimation:parabolic forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView * animationView = [self viewWithTag:COINIMAGEVIEWTAG];
    [animationView removeFromSuperview];
}

- (void)changePrivateCardPush:(NSDictionary *)dic
{
    PlayMusicModel * playmusic = [PlayMusicModel share];
    [playmusic playMusicWithName:@"fantasyChangePrivate" type:@"mp3"];
    
    self.bonusModel.bonus = [dic objectForKey:@"Bonus"];
    
    for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
        gamerModel.exchangeCardType = ExchangeCardType_nomal;
    }
    
    for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
        if (gamerModel.gameUserInfo.userId.intValue == [[dic objectForKey:@"NextUserId"] intValue]) {
            gamerModel.exchangeCardType = ExchangeCardType_Wait;
        }
        if (gamerModel.gameUserInfo.userId.intValue == [[dic objectForKey:@"UserId"] intValue]) {
            gamerModel.exchangeCardType = ExchangeCardType_private;
        }
    }
    if ([[NSString stringWithFormat:@"%@", [dic objectForKey:@"NextUserId"]] isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        self.isturnUserSelf = YES;
         [self userselftimeOutAction];
    }else
    {
        self.isturnUserSelf = NO;
    }
    [self.gameCollectionView reloadData];
    for (FantasyGamerIconFrameModel * iconModel in self.gamerIconFrames) {
        if (iconModel.userId.intValue == [[dic objectForKey:@"UserId"] intValue]) {
            [self startCoinAnimation:iconModel];
        }
    }
}
- (void) nochangeCardPush:(NSDictionary *)dic
{
    PlayMusicModel * playmusic = [PlayMusicModel share];
    [playmusic playMusicWithName:@"fantasyNoChange" type:@"mp3"];
    
    for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
        if (gamerModel.gameUserInfo.userId.intValue != [[dic objectForKey:@"LastOperationUserId"] intValue]) {
            gamerModel.exchangeCardType = ExchangeCardType_nomal;
        }else
        {
            if ([[dic objectForKey:@"UserId"] intValue] == [[dic objectForKey:@"LastOperationUserId"] intValue]) {
                gamerModel.exchangeCardType = ExchangeCardType_nomal;
            }
        }
    }
    for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
        if (gamerModel.gameUserInfo.userId.intValue == [[dic objectForKey:@"NextUserId"] intValue]) {
            if ([[dic objectForKey:@"IsFinish"] intValue] == 1) {
                // 游戏结束，不需要更新下个操作人状态
                gamerModel.exchangeCardType = ExchangeCardType_nomal;
                self.isGameFinish = YES;
            }else
            {
                gamerModel.exchangeCardType = ExchangeCardType_Wait;
                self.isGameFinish = NO;
            }
        }
        if (gamerModel.gameUserInfo.userId.intValue == [[dic objectForKey:@"UserId"] intValue]) {
            
            switch ([[dic objectForKey:@"Status"] intValue]) {
                case 1:
                    gamerModel.exchangeCardType = ExchangeCardType_no;
                    break;
                case 2:
                    gamerModel.exchangeCardType = ExchangeCardType_private;
                    break;
                case 3:
                    gamerModel.exchangeCardType = ExchangeCardType_public;
                    break;
                    
                default:
                    break;
            }
            
        }
        
        if (![gamerModel.gameUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            [gamerModel.cardInfoArr removeAllObjects];
        }
        
    }
    if ([[NSString stringWithFormat:@"%@", [dic objectForKey:@"NextUserId"]] isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        self.isturnUserSelf = YES;
        [self userselftimeOutAction];
    }else
    {
        self.isturnUserSelf = NO;
    }
    
    if ([[dic objectForKey:@"IsFinish"] intValue] == 1) {
        NSLog(@"结束了");
    }
    
    for (FantasyGamerInfoModel *gamerModel  in self.gameUserInformationArr) {
        if (![gamerModel.gameUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            [gamerModel.cardInfoArr removeAllObjects];
        }
    }
    
    [self.gameCollectionView reloadData];
}

- (void)hideChangeOperation:(FantasyGamerInfoModel *)gamerModel
{
    __weak FantasyGameView * weakSelf = self;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
        gamerModel.exchangeCardType = ExchangeCardType_nomal;
        NSLog(@"gamerModel.gameUserInfo.name = %@", gamerModel.gameUserInfo.name);
        [weakSelf.gameCollectionView reloadData];
    }];
}

// 超时不叫
- (void)userselftimeOutAction
{
    if (self.timeout) {
        [self.timeout invalidate];
        self.timeout = nil;
    }
    self.timeoutNumber = 30;
    self.timeout = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutAction) userInfo:nil repeats:YES];
}

- (void)timeoutAction
{
    self.timeoutNumber--;
    NSLog(@"self.timeout %d", self.timeoutNumber);
    if (self.timeoutNumber <= 0) {
        if (self.timeoutNumber == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeoutAction)]) {
                [self.delegate timeoutAction];
            }
        }
        [self.timeout invalidate];
        self.timeout = nil;
    }
    
}

// 显示开牌结果
- (void)showGameresultCard:(NSDictionary *)dic
{
    NSLog(@"******** 开始显示开牌");
    [self closeTimeOut];
    
    for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
        gamerModel.exchangeCardType = ExchangeCardType_nomal;
        
        NSArray * userlist = [dic objectForKey:@"UserList"];
        for (NSDictionary * userDic in userlist) {
            if ([[userDic objectForKey:@"UserId"] intValue] == gamerModel.gameUserInfo.userId.intValue) {
                NSArray * cardNumberArr = [[userDic objectForKey:@"CardNumber"] componentsSeparatedByString:@","];
                [gamerModel.cardInfoArr removeAllObjects];
                for (NSString * number in cardNumberArr) {
                    FantasyGamerCardInfoModel * cardmodel = [self cardinfoModelWith:number.intValue];
                    [gamerModel.cardInfoArr addObject:cardmodel];
                }
            }
        }
        
        self.winUserId = [dic objectForKey:@"WinUserId"];
        
    }
    self.isturnUserSelf = NO;
    
    self.refreshNUmber = 0;
    self.turnRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(turnResultRefresh) userInfo:nil repeats:YES];
}

- (void)turnResultRefresh
{
    if (self.refreshNUmber>= self.indexpathArr.count) {
        
        NSLog(@"self.refreshNUmber = %d  ,  self.indexpathArr.count = %d", self.refreshNUmber, self.indexpathArr.count);
        
        [self.turnRefreshTimer invalidate];
        self.turnRefreshTimer = nil;
        
        for (FantasyGamerInfoModel * gamerModel in self.gameUserInformationArr) {
            if (gamerModel.gameUserInfo.userId.intValue == [self.winUserId intValue]) {
                gamerModel.isWin = IsWinTheFantasyGame_win;
            }else
            {
                gamerModel.isWin = IsWinTheFantasyGame_lose;
            }
            
        }
        [self.gameCollectionView reloadData];
        
        __weak FantasyGameView * weakSelf = self;
        NSTimer * getResultTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getGameResultSourceRequest)]) {
                [weakSelf.delegate getGameResultSourceRequest];
            }
        }];
        
        return;
    }
    [self.gameCollectionView reloadItemsAtIndexPaths:@[[self.indexpathArr objectAtIndex:self.refreshNUmber]] ];
    NSLog(@"游戏结束逐个刷新 **** %d", self.refreshNUmber);
    PlayMusicModel * playmusic = [PlayMusicModel share];
    [playmusic playMusicWithName:@"fantasyLicensing" type:@"mp3"];
    self.refreshNUmber++;
    if (self.refreshNUmber == 3) {
        self.refreshNUmber++;
    }
}

- (void)closeTimeOut
{
    // 关闭超时不叫定时器
    if (self.timeout != nil) {
        NSLog(@"关闭了超时不叫定时器");
        [self.timeout invalidate];
        self.timeout = nil;
    }
}

- (BOOL)operationFrequently
{
    NSDate * nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval dateInterval = [nowDate timeIntervalSinceDate:self.lastOperationDate];
    if (dateInterval > 1.5) {
        NSLog(@"操作超过1.5s了");
        self.lastOperationDate = nowDate;
        return NO;
    }else
    {
        return YES;
    }
}

- (FantasyGamerCardInfoModel *)cardinfoModelWith:(int)number
{
    FantasyGamerCardInfoModel * model = [[FantasyGamerCardInfoModel alloc]init];
    int color = number % 10;
    int cardNumber = number / 10;
    switch (color) {
        case 1:
            model.fantasyCardColor = FantasyCardColor_side;
            break;
        case 2:
            model.fantasyCardColor = FantasyCardColor_plumblossom;
            break;
        case 3:
            model.fantasyCardColor = FantasyCardColor_hearts;
            break;
        case 4:
            model.fantasyCardColor = FantasyCardColor_spade;
            break;
        default:
            break;
    }
    switch (cardNumber) {
        case 14:
            model.cardNumber = @"A";
            break;
        case 11:
            model.cardNumber = @"J";
            break;
        case 12:
            model.cardNumber = @"Q";
            break;
        case 13:
            model.cardNumber = @"K";
            break;
            
        default:
            model.cardNumber = [NSString stringWithFormat:@"%d", cardNumber];
            break;
    }
    return model;
}

- (void)removeALLproperty
{
    if (self.timeout) {
        [self.timeout invalidate];
        self.timeout = nil;
    }
    
    if (self.turnRefreshTimer) {
        [self.turnRefreshTimer invalidate];
        self.turnRefreshTimer = nil;
    }
}
- (void)begainGame
{
    if (self.timeout) {
        [self.timeout invalidate];
        self.timeout = nil;
    }
    
    if (self.turnRefreshTimer) {
        [self.turnRefreshTimer invalidate];
        self.turnRefreshTimer = nil;
    }
    self.isturnUserSelf = NO;
    self.isGameFinish = NO;
    self.timeoutNumber = 0;
    [self.gameUserInformationArr removeAllObjects];
    [self.resultDataSource removeAllObjects];
    [self.gamerIconFrames removeAllObjects];
    [self.indexpathArr removeAllObjects];
    self.gameStart = Game_prepare;
    self.refreshNUmber = 0;
    [self removeAllSubviews];
    [self prepareUI];
}

/*
 
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
