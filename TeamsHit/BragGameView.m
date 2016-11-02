//
//  BragGameView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BragGameView.h"

#import "BraggameTableViewCell.h"
#import "BragGameScoreTableViewCell.h"
#import "ChooseDicenumberView.h"
#import "DiceCupView.h"

#define BRAGEGAMECELLIDENTIFIRE @"BRAGEGAMECELL"
#define BRAGEGAMESCORECELLIDENTIFIRE @"bragGameScoreCell"

@interface BragGameView()<UITableViewDelegate, UITableViewDataSource, TipDiceCupProtocol, ChooseDiceNumberProtocol, IFlySpeechSynthesizerDelegate>
{
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
}
@property (nonatomic, strong)DiceCupView * diceCupView;
@property (nonatomic, strong)ChooseDicenumberView * chooseDiceNumberView;

@property (nonatomic, strong)NSMutableArray * resultDataSource;

@property (nonatomic, assign)int callDiceCount;
@property (nonatomic, assign)int actualDiceCount;

@property (nonatomic, strong)NSTimer * timeout;
@property (nonatomic, assign)int timeoutNumber;

@property (nonatomic, strong) NSNumber * WinUserId ;
@property (nonatomic, strong) NSNumber * loseUserId;

// 已收到第一个叫点的push
@property (nonatomic, assign)BOOL haveRecivedFirstCallDicePointUserPush;

// 游戏结束逐个刷新cell
@property (nonatomic, assign)BOOL isStartGame;
@property (nonatomic, strong)NSMutableArray * indexpathArr;
@property (nonatomic, assign)int  refreshNUmber;
@property (nonatomic, strong)NSTimer * turnRefreshTimer;
@property (nonatomic, strong)UIButton * quitBT;

@end

@implementation BragGameView

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
    self.refreshNUmber = 0;
    
    self.gametableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 33, 360) style:UITableViewStylePlain];
    self.gametableView.delegate = self;
    self.gametableView.dataSource = self;
    self.gametableView.backgroundColor = [UIColor clearColor];
    self.gametableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.gametableView registerClass:[BraggameTableViewCell class] forCellReuseIdentifier:BRAGEGAMECELLIDENTIFIRE];
    self.gametableView.tableFooterView = [self getGameTableFootView];
    
    [self addSubview:self.gametableView];
    
    
    self.scoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.hd_width - 33, 0, 33, 360) style:UITableViewStylePlain];
    self.scoreTableView.delegate = self;
    self.scoreTableView.dataSource = self;
    self.scoreTableView.backgroundColor = [UIColor clearColor];
    [self.scoreTableView registerClass:[BragGameScoreTableViewCell class] forCellReuseIdentifier:BRAGEGAMESCORECELLIDENTIFIRE];
    self.scoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoreTableView.transform = CGAffineTransformMakeScale(1, -1);
    [self addSubview:self.scoreTableView];
    
    self.diceCupView = [[DiceCupView alloc]initWithFrame:self.bounds];
    self.diceCupView.delegete = self;
    [self addSubview:self.diceCupView];
    
    self.chooseDiceNumberView = [[ChooseDicenumberView alloc]initWithFrame:self.bounds withDiceNumber:1 andDicePoint:2];
    self.chooseDiceNumberView.delegate = self;
    [self addSubview:self.chooseDiceNumberView];
    self.chooseDiceNumberView.hidden = YES;
    
}

- (UIView *)getGameTableFootView
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.gametableView.hd_width, 70)];
    footView.backgroundColor = [UIColor clearColor];
    
    self.quitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.quitBT.frame = CGRectMake(15, 10, 40, 40);
    [self.quitBT setImage:[UIImage imageNamed:@"quieGameButton"] forState:UIControlStateNormal];
    [footView addSubview:self.quitBT];
    [self.quitBT addTarget:self action:@selector(quitBragGame) forControlEvents:UIControlEventTouchUpInside];
    
    return footView;
}
- (void)quitBragGame
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(quitBragGameView)]) {
        [self.delegate quitBragGameView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.gametableView]) {
        return self.gameUserInformationArr.count;
    }else
    {
        return self.resultDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isStartGame) {
        if (self.indexpathArr.count < self.gameUserInformationArr.count) {
            [self.indexpathArr addObject:indexPath];
            NSLog(@" *** indexPath *** ");
        }
    }
    
    if ([tableView isEqual:self.gametableView]) {
        BraggameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BRAGEGAMECELLIDENTIFIRE forIndexPath:indexPath];
        [cell creatCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.bragGameModel = [self.gameUserInformationArr objectAtIndex:indexPath.row];
        BragGameModel * model = [self.gameUserInformationArr objectAtIndex:indexPath.row];
        [cell getchooseDicepointCallOrOpen:^(NSString *string) {
            if ([string isEqualToString:@"开"]) {
                NSLog(@"开");
                if (self.timeout != nil) {
                    NSLog(@"关闭了定时器");
                    [self.timeout invalidate];
                    self.timeout = nil;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(openGameuser:)]) {
                    [self.delegate openGameuser:model.gameUserInfo.userId];
                }
                
            }else
            {
                self.chooseDiceNumberView.hidden = NO;
                self.chooseDiceNumberView.leaveTime = self.timeoutNumber;
                if (model.dicePoint.intValue == 1) {
                    NSLog(@"***** 上家叫了1点");
                    self.chooseDiceNumberView.isOnePoint = YES;
                    
                    
                    [self.chooseDiceNumberView refreshViewWithDiceNumber:model.diceCount.intValue + 1 andDicePoint:2];
                }else if (model.dicePoint.intValue == 6)
                {
                    NSLog(@"***** 上家叫了6点");
                    self.chooseDiceNumberView.isOnePoint = NO;
                    [self.chooseDiceNumberView refreshViewWithDiceNumber:model.diceCount.intValue andDicePoint:1];
                }
                else
                {
                    self.chooseDiceNumberView.isOnePoint = NO;
                    [self.chooseDiceNumberView refreshViewWithDiceNumber:model.diceCount.intValue andDicePoint:model.dicePoint.intValue + 1];
                }
                [self.chooseDiceNumberView show];
            }
        }];
        return cell;
    }else
    {
        BragGameScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BRAGEGAMESCORECELLIDENTIFIRE forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale(1, -1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell creatWithFrame:tableView.bounds];
        cell.numberLabel.text = self.resultDataSource[indexPath.row];
        if (indexPath.row < self.actualDiceCount) {
            cell.numberLabel.backgroundColor = UIColorFromRGB(0xF8B551);
        }
        if (indexPath.row == self.callDiceCount - 1 ) {
            cell.winImageView.hidden = NO;
            cell.iswin = YES;
        }else
        {
            cell.winImageView.hidden = YES;
            cell.iswin = NO;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.gametableView]) {
        return 60;
    }else
    {
        CGFloat height = 360.0 / self.resultDataSource.count;
        if (height > 16) {
            height = 16.0;
        }
        return (int )height;
    }
}

#pragma mark - TipDiceCupProtocol
- (void)tipDiceCup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragShakeDIceCup)]) {
        [self.delegate bragShakeDIceCup];
    }
}
- (void)reShakeCup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragReshakeCup)]) {
        [self.delegate bragReshakeCup];
    }
}

- (void)completeShakeDiceCup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragCompleteShakeDiceCup)]) {
        [self.delegate bragCompleteShakeDiceCup];
    }
    self.diceCupView.hidden = YES;
    
    for (BragGameModel * model in self.gameUserInformationArr) {
        if ([model.gameUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            [model.dicePointArr removeAllObjects];
            [model.showDicePointArr removeAllObjects];
            model.dicePointArr = [self.diceCupView.dicePointArr mutableCopy];
             model.showDicePointArr = [self.diceCupView.dataSourceArr mutableCopy];
            break;
        }
    }
    
    [self.gametableView reloadData];
}

#pragma mark - ChooseDiceNumberProtocol
- (void)chooseCompleteWithnumber:(int)number point:(int )point
{
    // 关闭超时不叫定时器
    if (self.timeout != nil) {
        NSLog(@"关闭了定时器");
        [self.timeout invalidate];
        self.timeout = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragChooseCompleteWithnumber:point:)]) {
        [self.delegate bragChooseCompleteWithnumber:number point:point];
    }
    
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
//    int a = arc4random() % 10;
//    NSLog(@"%d", a);
//    
//    if (a % 2 == 0) {
//        [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
//    }else
//    {
//        [_iFlySpeechSynthesizer setParameter:@"vixf" forKey: [IFlySpeechConstant VOICE_NAME]];
//    }
    
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking: [NSString stringWithFormat:@"%d个%d", number, point]];
    
}

- (void)begainState
{
    self.diceCupView.hidden = NO;
    self.diceCupView.tipDiceCupView.hidden = NO;
    self.diceCupView.diceCuptipResultView.hidden = YES;
    self.chooseDiceNumberView.hidden = YES;
    self.chooseDiceNumberView.maxPointCount = 0;
    if (self.timeout) {
        [self.timeout invalidate];
        self.timeout = nil;
    }
    
    self.finishDicePoint = @"";
    self.isHavoOnePoint = NO;
    self.callDiceCount = 0;
    self.actualDiceCount = 0;
    self.timeoutNumber = 0;
    self.WinUserId = @0;
    self.loseUserId = @0;
    self.isStartGame = NO;
    self.refreshNUmber = 0;
    self.haveRecivedFirstCallDicePointUserPush = NO;
    
    [self.resultDataSource removeAllObjects];
    [self.indexpathArr removeAllObjects];
    [self.gameUserInformationArr removeAllObjects];
    [self.gametableView reloadData];
    [self.scoreTableView reloadData];
    
    self.hidden = YES;
}

- (void)showResultView:(int )count
{
    [self.resultDataSource removeAllObjects];
    
    int bigger = count;
    if (self.callDiceCount >= count) {
        bigger = self.callDiceCount;
    }
    for (int i = 1;  i <= bigger; i ++) {
        NSString * str = [NSString stringWithFormat:@"%d", i];
        [self.resultDataSource addObject:str];
    }
    
    if (bigger <= 15) {
        self.scoreTableView.hd_height = 300;
    }else
    {
        self.scoreTableView.hd_height = 360;
    }
    
    [self.scoreTableView reloadData];
//    NSLog(@"callDiceCount = %d ** actualDiceCount = %d", self.callDiceCount, self.actualDiceCount);
}

#pragma mark - 操作用户游戏信息
- (void)cratGameUserInformation:(NSArray *)userInfoArr  withDic:(NSDictionary *)dic
{
    NSArray * gameUserInfoArr = [dic objectForKey:@"UserList"];
    
    if ([[dic objectForKey:@"IsViewer"] intValue] == 1) {
        self.diceCupView.hidden = YES;
    }
    [self.gameUserInformationArr removeAllObjects];
    for (int i = 0; i < userInfoArr.count; i++) {
        
        NSDictionary * userDic = [gameUserInfoArr objectAtIndex:i];
        NSDictionary * userinfoDic = [userDic objectForKey:@"User"];
        
        RCUserInfo * userInfo = [RCUserInfo new];
        userInfo.name = [userinfoDic objectForKey:@"DisplayName"];
        userInfo.userId = [NSString stringWithFormat:@"%@", [userinfoDic objectForKey:@"UserId"]];
        userInfo.portraitUri = [userinfoDic objectForKey:@"PortraitUri"];
        
        
        BragGameModel * model = [[BragGameModel alloc]init];
        model.gameUserInfo = [RCUserInfo new];
        model.gameUserInfo.name = userInfo.name;
        model.gameUserInfo.portraitUri = userInfo.portraitUri;
        model.gameUserInfo.userId = userInfo.userId;
        model.userWinPointCount = 0;
        model.choosecallOrOpenType = ChooseCallOrOpen_Nomal;
        model.calledDicePointState = CalledDicePoint_Pass;
        model.isFinish = NO;
        
        // 输赢
        if ([[userDic objectForKey:@"WinUserId"] intValue] == userInfo.userId.intValue) {
            model.isWin = IsWinTheGame_win;
        }else if ([[userDic objectForKey:@"LoseUserId"] intValue] == userInfo.userId.intValue)
        {
            model.isWin = IsWinTheGame_lose;
        }else
        {
            model.isWin = IsWinTheGame_nomal;
        }
        // 是否摇点
        if ([[userDic objectForKey:@"Status"] intValue] == 0) {
            model.isShakeDiceCup = NO;
        }else if ([[userDic objectForKey:@"Status"] intValue] == 1)
        {
             model.isShakeDiceCup = YES;
        }else
        {
            // 开点标示游戏结束,开始显示结果了
            model.isFinish = YES;
        }
        
        // 是自己的话根据是否摇点显示摇到的骰子情况
        if ([userInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            model.isUserself = YES;
            if (model.isShakeDiceCup) {
                self.diceCupView.hidden = YES;
                NSArray * dicePointArr = [[userDic objectForKey:@"PointStr"] componentsSeparatedByString:@","];
                [model.dicePointArr removeAllObjects];
                [model.showDicePointArr removeAllObjects];
                model.dicePointArr = [dicePointArr mutableCopy];
                for (NSString * point in model.dicePointArr) {
                    NSString * imageStr = [NSString stringWithFormat:@"骰子%@", point];
                    [model.showDicePointArr addObject:imageStr];
                }
            }
            
        }else
        {
            model.isUserself = NO;
            
            // 如果不是自己，则看是否游戏结束，结束的话给数据源填充数据，否则不填充
            if (model.isFinish) {
                NSArray * dicePointArr = [[userDic objectForKey:@"PointStr"] componentsSeparatedByString:@","];
                [model.dicePointArr removeAllObjects];
                [model.showDicePointArr removeAllObjects];
                model.dicePointArr = [dicePointArr mutableCopy];
                for (NSString * point in model.dicePointArr) {
                    NSString * imageStr = [NSString stringWithFormat:@"骰子%@", point];
                    [model.showDicePointArr addObject:imageStr];
                }
            }
        }
        
        // 显示叫点情况
        NSString * userId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"UserId"]];
        NSString * nextUserId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"NextUserId"]];
        
        BragGameModel* userModel = [[BragGameModel alloc]init];
        BragGameModel * nextModel = [[BragGameModel alloc]init];
        if ([userId isEqualToString:model.gameUserInfo.userId]) {
            model.calledDicePointState = CalledDicePoint_Now;
            model.diceCount = [userDic objectForKey:@"DiceCount"];
            model.dicePoint = [userDic objectForKey:@"DicePoint"];
            userModel = model;
        }
        if ([nextUserId isEqualToString:model.gameUserInfo.userId]) {
            model.calledDicePointState = CalledDicePoint_Wait;
            model.diceCount = [userDic objectForKey:@"DiceCount"];
            model.dicePoint = [userDic objectForKey:@"DicePoint"];
            nextModel = model;
            
        }
        // 判断下一个叫点者是不是本人,是的话刷新，并添超时加定时器
        if ([nextUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            NSLog(@"**** 下一个该你叫点了 ***** ");
            nextModel.choosecallOrOpenType = ChooseCallOrOpen_Call;
            userModel.choosecallOrOpenType = ChooseCallOrOpen_Open;
            if (self.timeout) {
                [self.timeout invalidate];
                self.timeout = nil;
            }
            self.timeoutNumber = 30;
            self.timeout = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutAction) userInfo:nil repeats:YES];
        }
        
        model.callContent = @"";
//        model.isShakeDiceCup = NO;
//        model.choosecallOrOpenType = ChooseCallOrOpen_Nomal;
        [self.gameUserInformationArr addObject:model];
        
    }
    
//    for (RCUserInfo * userInfo in userInfoArr) {
//        BragGameModel * model = [[BragGameModel alloc]init];
//        model.gameUserInfo = [RCUserInfo new];
//        model.gameUserInfo.name = userInfo.name;
//        model.gameUserInfo.portraitUri = userInfo.portraitUri;
//        model.gameUserInfo.userId = userInfo.userId;
//        model.userWinPointCount = 0;
//        model.isFinish = NO;
//        model.isWin = IsWinTheGame_nomal;
//        if ([userInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//            model.isUserself = YES;
//        }else
//        {
//            model.isUserself = NO;
//        }
//        
//        model.calledDicePointState = CalledDicePoint_Pass;
//        model.callContent = @"";
//        model.isShakeDiceCup = NO;
//        model.choosecallOrOpenType = ChooseCallOrOpen_Nomal;
//        [self.gameUserInformationArr addObject:model];
//    }
    self.isStartGame = YES;
    [self.gametableView reloadData];
    
    self.chooseDiceNumberView.maxPointCount = self.gameUserInformationArr.count * 5;
    
}

// 第一个人叫点
- (void)FirstCallDicePointUser:(NSString *)firstuserId
{
    if (!self.haveRecivedFirstCallDicePointUserPush) {
        for (BragGameModel * model in self.gameUserInformationArr) {
            if ([model.gameUserInfo.userId isEqualToString:firstuserId]) {
                model.calledDicePointState = CalledDicePoint_Wait;
                model.diceCount = @0;
                model.dicePoint = @1;
                // 是自己就显示叫点按钮，并添加超时定时器
                if ([model.gameUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                    model.choosecallOrOpenType = ChooseCallOrOpen_Call;
                    if (self.timeout) {
                        [self.timeout invalidate];
                        self.timeout = nil;
                    }
                    if (self.timeout == nil) {
                        self.timeout = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutAction) userInfo:nil repeats:YES];
                        self.timeoutNumber = 30;
                    }
                }
                break;
            }
        }
        [self.gametableView reloadData];
        self.haveRecivedFirstCallDicePointUserPush = YES;
    }
    
}

// 有人摇点
- (void)shakeDiceWithDic:(NSDictionary *)dic
{
    NSString * userId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"UserId"]];
    for (BragGameModel * model in self.gameUserInformationArr) {
        if ([model.gameUserInfo.userId isEqualToString:userId]) {
            model.isShakeDiceCup = YES;
            
            NSLog(@"玩家%@摇点了", model.gameUserInfo.name);
            
            break;
        }
    }
    [self.gametableView reloadData];
}

// 有人叫点
- (void)callDicePoint:(NSDictionary *)dic
{
    NSString * userId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"UserId"]];
    NSString * nextUserId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"NextUserId"]];
    
    // 初始化叫点状态，并更新
    for (BragGameModel * model in self.gameUserInformationArr) {
        if (model.calledDicePointState != CalledDicePoint_Pass) {
            model.calledDicePointState = CalledDicePoint_Pass;
        }
        if (model.choosecallOrOpenType != ChooseCallOrOpen_Nomal) {
            model.choosecallOrOpenType = ChooseCallOrOpen_Nomal;
        }
    }
    
    BragGameModel* userModel = [[BragGameModel alloc]init];
    BragGameModel * nextModel = [[BragGameModel alloc]init];
    for (BragGameModel * model in self.gameUserInformationArr) {
        
        if ([userId isEqualToString:model.gameUserInfo.userId]) {
            model.calledDicePointState = CalledDicePoint_Now;
            model.diceCount = [dic objectForKey:@"DiceCount"];
            model.dicePoint = [dic objectForKey:@"DicePoint"];
            userModel = model;
        }
        if ([nextUserId isEqualToString:model.gameUserInfo.userId]) {
            model.calledDicePointState = CalledDicePoint_Wait;
            model.diceCount = [dic objectForKey:@"DiceCount"];
            model.dicePoint = [dic objectForKey:@"DicePoint"];
            nextModel = model;
            
        }
    }
    
    // 判断下一个叫点者是不是本人,是的话刷新，并添超时加定时器
    if ([nextUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        NSLog(@"**** 下一个该你叫点了 ***** ");
        nextModel.choosecallOrOpenType = ChooseCallOrOpen_Call;
        userModel.choosecallOrOpenType = ChooseCallOrOpen_Open;
        if (self.timeout) {
            [self.timeout invalidate];
            self.timeout = nil;
        }
        self.timeoutNumber = 30;
        self.timeout = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutAction) userInfo:nil repeats:YES];
    }
    
    [self.gametableView reloadData];
    
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
    //    int a = arc4random() % 10;
    //    NSLog(@"%d", a);
    //
    //    if (a % 2 == 0) {
    //        [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
    //    }else
    //    {
    //        [_iFlySpeechSynthesizer setParameter:@"vixf" forKey: [IFlySpeechConstant VOICE_NAME]];
    //    }
    
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking: [NSString stringWithFormat:@"%@个%@", [dic objectForKey:@"DiceCount"], [dic objectForKey:@"DicePoint"]]];
    
}

// 超时不叫
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
        [self.chooseDiceNumberView dismiss];
        NSLog(@"已经超时了，此处该销毁 self.timeout %d", self.timeoutNumber);
    }
}

// 自己摇骰子
- (void)selfShakeDice:(NSDictionary *)dic
{
    NSArray * dicePointArr = [[dic objectForKey:@"DiceNumber"] componentsSeparatedByString:@","];
    self.diceCupView.dicePointArr = [dicePointArr mutableCopy];
    [self.diceCupView.dataSourceArr removeAllObjects];
    for (NSString * point in dicePointArr) {
        NSString * imageStr = [NSString stringWithFormat:@"骰子%@", point];
        [self.diceCupView.dataSourceArr addObject:imageStr];
    }
//    [self.diceCupView showResult];
    
//    for (BragGameModel * model in self.gameUserInformationArr) {
//        if ([model.gameUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//            NSArray * dicePointArr = [[dic objectForKey:@"DiceNumber"] componentsSeparatedByString:@","];
//            [model.dicePointArr removeAllObjects];
//            [model.showDicePointArr removeAllObjects];
//            model.dicePointArr = [dicePointArr mutableCopy];
//            for (NSString * point in model.dicePointArr) {
//                NSString * imageStr = [NSString stringWithFormat:@"骰子%@", point];
//                [model.showDicePointArr addObject:imageStr];
//            }
//            self.diceCupView.dataSourceArr = model.showDicePointArr;
//            [self.diceCupView showResult];
//            break;
//        }
//    }
}

// 开点
- (void)openDIcePoint:(NSDictionary *)dic
{
    PlayMusicModel * playmusic = [PlayMusicModel share];
    [playmusic playMusicWithName:@"我开你" type:@"mp3"];
    
    
//    NSNumber * OpenUserId = [dic objectForKey:@"OpenUserId"];
//    NSNumber * BeOpenUserId = [dic objectForKey:@"BeOpenUserId"];
    NSNumber * WinPoint = [dic objectForKey:@"WinPoint"];
    NSNumber * WinPointCount = [dic objectForKey:@"WinPointCount"];
    self.actualDiceCount = WinPointCount.intValue;
    self.callDiceCount = [[dic objectForKey:@"CallPointCount"] intValue];
    NSNumber * WinUserId = [dic objectForKey:@"WinUserId"];
    NSNumber * loseUserId = [dic objectForKey:@"LoseUserId"];
//    if (WinPoint.intValue == OpenUserId.intValue) {
//        loseUserId = BeOpenUserId;
//    }else
//    {
//        loseUserId = OpenUserId;
//    }
    BOOL IsSelectOne = [[dic objectForKey:@"IsSelectOne"] intValue];
    NSArray * gameUserDicePointArr = [dic objectForKey:@"UserDicePoint"];
    
    for (int i = 0; i < self.gameUserInformationArr.count; i++) {
        BragGameModel * model = [self.gameUserInformationArr objectAtIndex:i];
        model.isFinish = YES;
        if (model.gameUserInfo.userId.intValue == WinUserId.intValue) {
            self.WinUserId = WinUserId;
        }else if (model.gameUserInfo.userId.intValue == loseUserId.intValue)
        {
            self.loseUserId = loseUserId;
        }
        [model.dicePointArr removeAllObjects];
        [model.showDicePointArr removeAllObjects];
        if (IsSelectOne) {
            // 叫过一点
            for (int j = 0; j < gameUserDicePointArr.count; j++) {
                NSDictionary * dic = [gameUserDicePointArr objectAtIndex:j];
                if ([[dic objectForKey:@"UserId"] intValue] == model.gameUserInfo.userId.intValue) {
                    model.dicePointArr = [[[dic objectForKey:@"PointStr"] componentsSeparatedByString:@","] mutableCopy];
                    for (NSString * point in model.dicePointArr) {
                        NSString * imageStr = @"";
                        if (point.intValue == WinPoint.intValue) {
                            imageStr = [NSString stringWithFormat:@"骰子%@", point];
                            model.userWinPointCount++;
                        }else
                        {
                            imageStr = [NSString stringWithFormat:@"骰子%@-1", point];
                        }
                        [model.showDicePointArr addObject:imageStr];
                    }
                }
            }
            
        }else
        {
            // 没有叫过一点
            for (int j = 0; j < gameUserDicePointArr.count; j++) {
                NSDictionary * dic = [gameUserDicePointArr objectAtIndex:j];
                if ([[dic objectForKey:@"UserId"] intValue] == model.gameUserInfo.userId.intValue) {
                    model.dicePointArr = [[[dic objectForKey:@"PointStr"] componentsSeparatedByString:@","] mutableCopy];
                    for (NSString * point in model.dicePointArr) {
                        NSString * imageStr = @"";
                        if (point.intValue == WinPoint.intValue || point.intValue == 1) {
                            imageStr = [NSString stringWithFormat:@"骰子%@", point];
                            model.userWinPointCount++;
                        }else
                        {
                            imageStr = [NSString stringWithFormat:@"骰子%@-1", point];
                        }
                        [model.showDicePointArr addObject:imageStr];
                    }
                }
            }
            
        }
        
    }
    
    // 开点以后，逐个刷新cell
    self.turnRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}
- (void)refresh
{
    if (self.refreshNUmber>= self.indexpathArr.count) {
        [self.turnRefreshTimer invalidate];
        self.turnRefreshTimer = nil;
        [self showWinOrLose];
        return;
    }
    [self.gametableView reloadRowsAtIndexPaths:@[[self.indexpathArr objectAtIndex:self.refreshNUmber]] withRowAnimation:UITableViewRowAnimationNone];
    self.actualDiceCount = 0;
    for (int i = 0; i < self.gameUserInformationArr.count; i++) {
        if (i <= self.refreshNUmber) {
            BragGameModel * model = [self.gameUserInformationArr objectAtIndex:i];
            self.actualDiceCount += model.userWinPointCount;
//            NSLog(@"model.userWinPointCount = %d *** number = %d", model.userWinPointCount, self.actualDiceCount);
        }
        if (i == self.refreshNUmber) {
            break;
        }
    }
    [self showResultView:self.actualDiceCount];
    PlayMusicModel * playmusic = [PlayMusicModel share];
    [playmusic playMusicWithName:@"统计点数"];
    self.refreshNUmber++;
}

- (void)showWinOrLose
{
    
    for (int i = 0; i < self.gameUserInformationArr.count; i++) {
        BragGameModel * model = [self.gameUserInformationArr objectAtIndex:i];
        model.isFinish = YES;
        if (model.gameUserInfo.userId.intValue == _WinUserId.intValue) {
            model.isWin = IsWinTheGame_win;
        }else if (model.gameUserInfo.userId.intValue == _loseUserId.intValue)
        {
            model.isWin = IsWinTheGame_lose;
        }
    }
    [self.gametableView reloadData];
    PlayMusicModel * playmusic = [PlayMusicModel share];
    [playmusic playMusicWithName:@"统计完点数的声音"];
    [self performSelector:@selector(getGameResultSource) withObject:nil afterDelay:2];
    
}

- (void)getGameResultSource
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getGameResultSourceRequest)]) {
        [self.delegate getGameResultSourceRequest];
    }
}

#pragma mark - IFlySpeechSynthesizerDelegate
//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{
    NSLog(@"合成结束");
}
//合成开始
- (void) onSpeakBegin{}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{}
//合成播放进度
- (void) onSpeakProgress:(int) progress{}


- (void)dealloc
{
    if (self.timeout) {
        [self.timeout invalidate];
        self.timeout = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
