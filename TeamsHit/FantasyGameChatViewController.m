//
//  FantasyGameChatViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

/*
 游戏命令：
 （一）客户端请求命令
 1.发送游戏链接 ------- 2001 ，
 响应参数     ------ 20011
 2.准备游戏    ------- 2002，
 响应参数    ------- 20021
 3.换公牌 --- 2004
 相应参数 --- 20041
 4.换底牌 --- 2005
 相应参数 --- 20051
 5.不换牌及超时不叫 --- 2006
 相应参数 --- 20061
 6.退出 --- 2008
 相应参数 --- 20081
 7.游戏结束 --- 2009
 相应参数 --- 20091
 
 （二）服务器push命令
 1.准备情况  ----- 20002
 2.开始     ----- 20003
 3.玩家换公牌 ----- 20004
 4.玩家换底牌 ----- 20005
 5．玩家不换牌以及超时不叫 --- 20006
 6.显示开牌结果 ----- 20007
 7.游戏结束 ----- 20009
 */



#import "FantasyGameChatViewController.h"
#import "FantasyGameView.h"
#import "PrepareGameView.h"
#import "FriendListViewController.h"
#import "GroupDetailSetTipView.h"
#import "ChatListViewController.h"
#import "FantasyGameOverView.h"
#import "FantasyGamerInfoModel.h"
#import "GroupDetailViewController.h"

#define CHANGE_PUBLICCARD 2004
#define CHANGE_PRIVATECARD 2005
#define CHANGE_NO 2006
#define QUITFANTASYGAME 2008
#define FANTASYGAMEOVERREQUEST 2009
//#define FANTASY_WEBSOCKET @"ws://120.26.131.140:8185/" // 测试
#define FANTASY_WEBSOCKET @"ws://120.26.131.140:8186/" // 正式

@interface FantasyGameChatViewController ()<SRWebSocketDelegate, PrepareGameProtocol, FantasyGameViewProtocol, UIAlertViewDelegate>
{
    SRWebSocket *_webSocket;
    GroupDetailSetTipView * quitTipView;
    MBProgressHUD * hud;
}

@property (nonatomic, strong)PrepareGameView * prepareGameView;
@property (nonatomic, strong)FantasyGameView * fantasygameView;
@property (nonatomic, strong)NSMutableArray * GameUserInfoArr;// 存储游戏用户信息

@property (nonatomic, strong)NSNumber * gameId;

@property (nonatomic, assign)BOOL isStartGame;
@property (nonatomic, assign)BOOL isFinishGame;
@property (nonatomic, assign)BOOL IsViewer;
// 剩余等待时间定时器
@property (nonatomic, strong)NSTimer * leaveTime;
@property (nonatomic, strong)NSTimer * pingTimer;
@property (nonatomic, strong)NSTimer * overtimeTimer;

@property (nonatomic, strong)FantasyGameOverView *gameOverView;

// 断线重连
@property (nonatomic, strong)UIAlertView * socketAlert;
@property (nonatomic, strong)NSTimer * socketTimer;
@property (nonatomic, assign)BOOL reConnect;

@end

@implementation FantasyGameChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.backImageView.image = [UIImage imageNamed:@"gameBackGroundView"];
    
    self.prepareGameView = [[PrepareGameView alloc]initWithFrame:CGRectMake(0, 64, self.backImageView.hd_width, 400)];
    self.prepareGameView.delegate = self;
    self.prepareGameView.hidden = NO;
    [self.backImageView addSubview:self.prepareGameView];
    
    self.fantasygameView = [[FantasyGameView alloc]initWithFrame:CGRectMake(0, 64, self.view.hd_width, 332 + 40)];
    self.fantasygameView.delegate = self;
    self.fantasygameView.hidden = YES;
    [self.backImageView addSubview:self.fantasygameView];
    self.reConnect = YES;
    if (_webSocket ==nil) {
        _webSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FANTASY_WEBSOCKET]]];
        _webSocket.delegate =self;
        [_webSocket open];
    }
    
    [self showGameRulerView];
    
//    NSDictionary *dic = @{@"GameCommand":@20003,@"Bonus":@267890,@"OperationUserId":@160540,@"CommonCard":@122,@"GameId":@161202,@"IsFinish":@0,@"IsViewer":@0,@"UserList":@[@{@"CardNumber":@"114,63",@"Status":@0,@"User":@{@"DisplayName":@"嘟嘟",@"PortraitUri":@"http://www.image.mstching.com/userhead/2016-11-01/5a9dae52fb914145b1c1118e7a6fb5df.png",@"UserId":@160540}},@{@"CardNumber":@"64,132",@"Status":@0,@"User":@{@"DisplayName":@"李玲玲",@"PortraitUri":@"http://www.image.mstching.com/userhead/2016-11-02/461cb5f7e81b4c6c8b73fc6ead5ee325.png",@"UserId":@160539}},@{@"CardNumber":@"34,113",@"Status":@0,@"User":@{@"DisplayName":@"yun7",@"PortraitUri":@"http://www.image.mstching.com/userhead/2016-10-19/e380bdcae6514670ab69893b35b6f22d.png",@"UserId":@160542}},@{@"CardNumber":@"41,22",@"Status":@0,@"User":@{@"DisplayName":@"朱",@"PortraitUri":@"http://www.image.mstching.com/userhead/2016-09-29/ec3d6bcde9cf4886b167ac365e8a9223.png",@"UserId":@160536}}],@"WinUserId":@0};
//    [self startGame:dic];
}

- (void)setUpGameChatGroup
{
    NSLog(@"群组设置");
    GroupDetailViewController * groupDetailVC = [[GroupDetailViewController alloc]init];
    groupDetailVC.groupID = self.targetId;
    __weak FantasyGameChatViewController * weakSelf = self;
    [groupDetailVC quitGameRoom:^{
        [weakSelf removeAllsubViews];
    }];
    [self.navigationController pushViewController:groupDetailVC animated:YES];
    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
//    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
//    [dictionary setValue:@(QUITFANTASYGAME) forKey:@"GameCommand"];
//    [dictionary setValue:self.gameId forKey:@"GameId"];
//    
//    [quitTipView dismiss];
//    [_webSocket send:[dictionary JSONString]];
}

#pragma mark set up in the game
- (void)lookRuler
{
    NSArray * typeArr = @[@"52张扑克随机打乱(没有大小王) 系统随机分配出牌顺序，会给每人两张底牌（只有自己看到），一张公牌各玩家共用，这三张牌将组成自己的牌。", @"按照玩家顺序依次操作，玩家有不换、换底牌、换公牌三种操作，当您觉得自己的牌满意即可选择不换，轮到下一玩家操作。如果不满意可以选择换底牌（需要扣除50碰碰币）或者换公牌（需要扣除100碰碰币）直到满意。", @"选择换牌的玩家后面的玩家都可以有一次操作机会，直到最近一次换牌玩家后面的玩家都选择不换牌，系统会进行开牌比牌，换牌扣除的碰碰币都会进入奖池，最终牌面最大的玩家将赢得奖池所有碰碰币。", @"比牌大小依据： 自己手中的两张牌加公牌一共三张\n1、豹子（AAA最大，222最小）。\n2、同花顺（AKQ最大，A23最小）。\n3、同花（AKJ最大，352最小）。\n4、顺子（AKQ最大，234最小）。\n5、对子（AAK最大，223最小）。\n6、单张（AKJ最大，352最小）"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"梦幻游戏规则" content:typeArr isRule:YES ishaveQuit:YES];
    [setTipView show];
    
}

- (void)forceOut
{
    NSLog(@"退出");
    
    if (_webSocket.readyState == SR_CLOSED) {
        [self removeAllsubViews];
        
        if ([self isfriendListVc]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];;
            
        }else
        {
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];;
        }
        
    }else
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
        [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
        [dictionary setValue:@(QUITFANTASYGAME) forKey:@"GameCommand"];
        [dictionary setValue:self.gameId forKey:@"GameId"];
        
        [quitTipView dismiss];
        [_webSocket send:[dictionary JSONString]];
        NSLog(@"callDicePOint %@", [dictionary JSONString]);
    }
    
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

#pragma mark - SRWebSocketDelegate 写上具体聊天逻辑
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(2001) forKey:@"GameCommand"];
    
    [_webSocket send:[dictionary JSONString]];
    
    self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pingAction) userInfo:nil repeats:YES];
    
    self.reConnect = YES;
    [hud hide:YES];
    [self.socketTimer invalidate];
    self.socketTimer = nil;
    [self.socketAlert performSelector:@selector(dismiss) withObject:nil afterDelay:0];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    
    NSLog(@"webSocket - didFailWithError");
    if (_reConnect) {
        hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"网络不稳定，连接中...";
        [hud show:YES];
        self.socketTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(socketConnectTimeout) userInfo:nil repeats:NO];
        _reConnect = NO;
    }
    
    [self.pingTimer invalidate];
    self.pingTimer = nil;
    [self.overtimeTimer invalidate];
    self.overtimeTimer = nil;
    _webSocket.delegate = nil;
    [_webSocket close];
    
    [self connectSocket];
}

- (void)socketConnectTimeout
{
    [hud hide:YES];
    self.socketAlert = [[UIAlertView alloc]initWithTitle:nil message:@"连接失败" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新连接", nil];
    [self.socketAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.socketAlert]) {
        if (buttonIndex == 1) {
            _reConnect = YES;
        }else
        {
            [self quitgame];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message//监控消息
{
    NSLog(@"%@ *** %@", [message class], message);
    NSError *errpr = nil;
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * messageDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&errpr];
    if(errpr) {
        NSLog(@"json解析失败：%@",errpr);
        return;
    }
    if ([messageDic objectForKey:@"Code"] == nil || ([messageDic objectForKey:@"Code"] && [[messageDic objectForKey:@"Code"] intValue] == 200)) {
        switch ([[messageDic objectForKey:@"GameCommand"] intValue]) {
            case 20011:
                // 发送游戏链接
                break;
            case 20021:
                // 准备游戏
                [self prepareAction1];
                break;
            case 20041:
                // 换公牌
                // push里面有操作，此处就不用再进行操作了
                break;
            case 20051:
                // 换底牌
                [self changePrivateCard:messageDic];
                break;
            case 20061:
                // 玩家不换及超时不叫
                // push里面有操作，此处就不用再进行操作了
                break;
            case 20081:
                // 退出游戏
                [self quitgame];
                break;
            case 20091:
                // 游戏结束
                [self showgameOverView:messageDic];
                break;
            case 20002:
                // 准备push
                [self gameuserPrepareAction:messageDic];
                break;
            case 20003:
                // 开始游戏
                [self startGame:messageDic];
                break;
            case 20004:
                // 玩家换公牌
                [self changePublicCardPush:messageDic];
                break;
            case 20005:
                // 玩家换底牌
                [self changePrivateCardPush:messageDic];
                break;
            case 20006:
                // 玩家不换及超时不叫
                [self nochangeCardPush:messageDic];
                break;
            case 20007:
                // 显示游戏结果-开牌
                [self showGameresultCard:messageDic];
                break;
            case 20009:
                // 游戏结束
                [self gameOver];
                break;
            default:
                break;
        }
    }else
    {
        if ([[messageDic objectForKey:@"Message"] length] == 0) {
            ;
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [messageDic objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@" ----- socket - 断开了");
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    if (self.overtimeTimer) {
        [self.overtimeTimer invalidate];
        self.overtimeTimer = nil;
    }
}

- (void)pingAction
{
    if (_webSocket.readyState == SR_OPEN) {
        NSData * data = [NSData data];
        [_webSocket sendPing:data];
    }
    self.overtimeTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(overTimeAction) userInfo:nil repeats:NO];
//    NSLog(@"发送了ping");
}

- (void)overTimeAction
{
    NSLog(@"断开连接了");
    [self.pingTimer invalidate];
    self.pingTimer = nil;
    [self.overtimeTimer invalidate];
    self.overtimeTimer = nil;
    _webSocket.delegate = nil;
    [_webSocket close];
    [self connectSocket];
}

- (void)connectSocket
{
    _webSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FANTASY_WEBSOCKET]]];
    _webSocket.delegate =self;
    [_webSocket open];
}

#pragma mark - PrepareGameProtocol
- (void)prepareAction
{
    if (_webSocket == nil || _webSocket.readyState != SR_OPEN) {
        return;
    }
    NSLog(@"发送准备命令");
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(2002) forKey:@"GameCommand"];
    [_webSocket send:[dictionary JSONString]];
    
}

- (void)prepareAction1
{
    [self.GameUserInfoArr addObject:[RCIM sharedRCIM].currentUserInfo];
    [self.prepareGameView.dataSourceArray addObject:[RCIM sharedRCIM].currentUserInfo];
    [self.prepareGameView reloadDataAction];
    self.prepareGameView.prepareBT.hidden = YES;
    self.prepareGameView.preparedButton.hidden = NO;
}

- (void)quitPrepareViewAction
{
    // 点击退出时候，判断是否已经准备游戏，准备的话发送退出命令，没准备的话直接退出，此时由于还没有开始游戏，故而没有gameId，传0
    BOOL isgameUser = NO;
    for (RCUserInfo * userInfo in self.GameUserInfoArr) {
        if ([userInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            isgameUser = YES;
            break;
        }
    }
    if (isgameUser) {
        if (_webSocket.readyState == SR_CLOSED) {
            [self removeAllsubViews];
            if ([self isfriendListVc]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];;
                
            }else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];;
            }
        }else
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
            [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
            [dictionary setValue:@(QUITFANTASYGAME) forKey:@"GameCommand"];
            [dictionary setValue:@0 forKey:@"GameId"];
            
            NSLog(@"%@", [dictionary description]);
            
            [_webSocket send:[dictionary JSONString]];
            NSLog(@"callDicePOint %@", [dictionary JSONString]);
            NSLog(@"请求后退出");
        }
    }else
    {
        [self removeAllsubViews];
        if ([self isfriendListVc]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];;
            
        }else
        {
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];;
        }
    }
}


- (void)quitgame
{
    [self removeAllsubViews];
    NSLog(@"退出游戏");
    if ([self isfriendListVc]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];;
    }else
    {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];;
    }
}

#pragma FantasyGameViewProtocol

- (void)changePublicCard
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(CHANGE_PUBLICCARD) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}
- (void)changePrivateCard
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(CHANGE_PRIVATECARD) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}
- (void)nochangeCard
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(CHANGE_NO) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}
- (void)timeoutAction
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(CHANGE_NO) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}
- (void)getGameResultSourceRequest{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(FANTASYGAMEOVERREQUEST) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}
- (void)quitFantasyGameView{
    if (self.IsViewer) {
        [self removeAllsubViews];
        if ([self isfriendListVc]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];;
        }else
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];;
        }
    }else
    {
        NSLog(@"开始游戏");
        quitTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:[NSString stringWithFormat:@"%@房间", self.targetId] quit:YES];
        quitTipView.IsViewer = self.IsViewer;
        [quitTipView getPickerData:^(NSString *string) {
            if ([string isEqualToString:@"lookRuler"]) {
                [self lookRuler];
            }else
            {
                [self forceOut];
            }
        }];
        [quitTipView show];
    }
}

#pragma mark - 人准备或者有人离开的时候收到Push消息
- (void)gameuserPrepareAction:(NSDictionary *)dic
{
    NSArray * gameUserArr = [dic objectForKey:@"UserList"];
    [self.GameUserInfoArr removeAllObjects];
    [self.prepareGameView.dataSourceArray removeAllObjects];
    for (NSDictionary * userDic in gameUserArr) {
        RCUserInfo * user = [RCUserInfo new];
        user.name = [userDic objectForKey:@"DisplayName"];
        user.userId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"UserId"]];
        user.portraitUri = [userDic objectForKey:@"PortraitUri"];
        [self.prepareGameView.dataSourceArray addObject:user];
        [self.GameUserInfoArr addObject:user];
    }
    
    if (self.prepareGameView.dataSourceArray.count >=3 && self.prepareGameView.dataSourceArray.count < 6) {
        if (self.leaveTime) {
            [self stopTimeDown];
        }
        self.headerView.timeLabel.text = @"5";
        self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
    }else
    {
        self.headerView.timeLabel.hidden = YES;
        self.headerView.view1.hidden = NO;
        self.headerView.view2.hidden = NO;
    }
    
    [self.prepareGameView reloadDataAction];
}


#pragma mark - startgame
- (void)startGame:(NSDictionary *)dic
{
    self.isFinishGame = NO;
    self.gameId = [dic objectForKey:@"GameId"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"GameId"] forKey:@"GameId"];
    
    if ([[dic objectForKey:@"IsViewer"] intValue] == 1) {
        self.IsViewer = YES;
    }else
    {
        self.IsViewer = NO;
    }
    
    NSArray * gameUserArr = [dic objectForKey:@"UserList"];
    [self.GameUserInfoArr removeAllObjects];
    [self.prepareGameView.dataSourceArray removeAllObjects];
    for (NSDictionary * userDic1 in gameUserArr) {
        NSDictionary * userDic = [userDic1 objectForKey:@"User"];
        RCUserInfo * user = [RCUserInfo new];
        user.name = [userDic objectForKey:@"DisplayName"];
        user.userId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"UserId"]];
        user.portraitUri = [userDic objectForKey:@"PortraitUri"];
        [self.prepareGameView.dataSourceArray addObject:user];
        [self.GameUserInfoArr addObject:user];
    }
    [self.prepareGameView reloadDataAction];
    self.prepareGameView.hidden = YES;
    self.isStartGame = YES;
    self.fantasygameView.hidden = NO;
    [self.fantasygameView cratGameUserInformation:self.GameUserInfoArr  withDic:dic];
    
    self.headerView.timeLabel.text = @"30";
    if (self.leaveTime) {
        [self stopTimeDown];
    }
    self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
}

#pragma mark - 换底牌响应
- (void)changePrivateCard:(NSDictionary *)dic
{
    [self.fantasygameView changePrivateCard:dic];
}

- (void)changePublicCardPush:(NSDictionary *)dic
{
    [self.fantasygameView changePublicCardPush:dic];
    [self downTimeAction];
}

- (void)changePrivateCardPush:(NSDictionary *)dic
{
    [self.fantasygameView changePrivateCardPush:dic];
    [self downTimeAction];
}
- (void) nochangeCardPush:(NSDictionary *)dic
{
    [self.fantasygameView nochangeCardPush:dic];
    if ([[dic objectForKey:@"IsFinish"] intValue] != 1) {
        [self downTimeAction];
    }
}

- (void)showGameresultCard:(NSDictionary *)dic
{
    if (self.leaveTime) {
        [self stopTimeDown];
    }
    __weak typeof(self) wealself = self;
    NSTimer * showReaultTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [wealself.fantasygameView showGameresultCard:dic];
    }];
}

- (void)showgameOverView:(NSDictionary *)dic
{
//    dic = @{@"UserList":@[@{@"IsWinnner":@0,@"TakeCoins":@50,@"User":@{@"DisplayName":@"嘟嘟",@"PortraitUri":@"http://www.image.mstching.com/userhead/2016-11-01/5a9dae52fb914145b1c1118e7a6fb5df.png",@"UserId":@160540}},@{@"IsWinnner":@0,@"TakeCoins":@0,@"User":@{@"DisplayName":@"朱",@"PortraitUri":@"http://www.image.mstching.com/userhead/2016-09-29/ec3d6bcde9cf4886b167ac365e8a9223.png",@"UserId":@160536}},@{@"IsWinnner":@0,@"TakeCoins":@0,@"User":@{@"DisplayName":@"李玲玲",@"PortraitUri":@"http://www.image.mstching.com/userhead/2016-11-02/461cb5f7e81b4c6c8b73fc6ead5ee325.png",@"UserId":@160539}}]};
    
    NSMutableArray * resultDataArr = [NSMutableArray array];
    NSArray * userListArr = [dic objectForKey:@"UserList"];
    NSString * winUserId = @"";
    for (NSDictionary * gameUserDic in userListArr) {
        NSDictionary * userinfoDic = [gameUserDic objectForKey:@"User"];
        
        RCUserInfo * userInfo = [RCUserInfo new];
        userInfo.name = [userinfoDic objectForKey:@"DisplayName"];
        userInfo.userId = [NSString stringWithFormat:@"%@", [userinfoDic objectForKey:@"UserId"]];
        userInfo.portraitUri = [userinfoDic objectForKey:@"PortraitUri"];
        
        FantasyGamerInfoModel * model = [[FantasyGamerInfoModel alloc]init];
        model.gameUserInfo = [RCUserInfo new];
        model.gameUserInfo.name = userInfo.name;
        model.gameUserInfo.portraitUri = userInfo.portraitUri;
        model.gameUserInfo.userId = userInfo.userId;
        model.exchangeCardType = ExchangeCardType_nomal;
        if ([[gameUserDic objectForKey:@"IsWinnner"] intValue] == 1) {
            model.isWin = IsWinTheFantasyGame_win;
            winUserId = model.gameUserInfo.userId;
        }else
        {
            model.isWin = IsWinTheFantasyGame_lose;
        }
        
        if (model.gameUserInfo.userId.intValue == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
            model.isUserself = YES;
        }
        
        model.winCoins = [[gameUserDic objectForKey:@"TakeCoins"] intValue];
        [resultDataArr addObject:model];
    }
    
    
    if ([winUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        PlayMusicModel * playmusic = [PlayMusicModel share];
        [playmusic playMusicWithName:@"fantasyWin"];
    }else
    {
        PlayMusicModel * playmusic = [PlayMusicModel share];
        [playmusic playMusicWithName:@"fantasyLose" type:@"mp3"];
    }
    
    self.gameOverView = [[FantasyGameOverView alloc]initWithFrame:[UIScreen mainScreen].bounds andDataArr:resultDataArr];
    [_gameOverView show];
    [self performSelector:@selector(dismissGameOverView) withObject:nil afterDelay:5];
    
}

- (void)dismissGameOverView
{
    [self.gameOverView dismiss];
    if (self.prepareGameView.hidden) {
        [self.gameOverView dismiss];
        [self.GameUserInfoArr removeAllObjects];
        [self.fantasygameView begainGame];
        [self.prepareGameView begainState];
        self.prepareGameView.hidden = NO;
        self.fantasygameView.hidden = YES;
    }
}

- (void)gameOver
{
    if (self.leaveTime) {
        [self stopTimeDown];
    }
    [self.gameOverView dismiss];
    [self.GameUserInfoArr removeAllObjects];
    [self.fantasygameView begainGame];
    [self.prepareGameView begainState];
    self.prepareGameView.hidden = NO;
    self.fantasygameView.hidden = YES;
}

- (void)downTimeAction
{
    self.headerView.timeLabel.text = @"30";
    if (self.leaveTime) {
        [self stopTimeDown];
    }
    self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)stopTimeDown
{
    [self.leaveTime invalidate];
    self.leaveTime = nil;
    self.headerView.timeLabel.hidden = YES;
    self.headerView.view1.hidden = NO;
    self.headerView.view2.hidden = NO;
}
- (BOOL)isfriendListVc
{
    UIViewController * viewContoller = self.navigationController.viewControllers[0];
    if ([viewContoller isKindOfClass:[FriendListViewController class]] ) {
        return YES;
    }else
    {
        return NO;
    }
}
// 倒计时
- (void)leaveTimeAction
{
    self.headerView.timeLabel.hidden = NO;
    self.headerView.view2.hidden = YES;
    self.headerView.view1.hidden = YES;
    int leavetime = self.headerView.timeLabel.text.intValue;
    leavetime--;
    self.headerView.timeLabel.text = [NSString stringWithFormat:@"%d", leavetime];
    if (leavetime <= 0) {
        self.headerView.timeLabel.text = @"0";
        leavetime = 0;
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
}

- (void)removeAllsubViews
{
    if (self.pingTimer) {
        [self.pingTimer invalidate];
        self.pingTimer = nil;
        NSLog(@"ping销毁");
    }
    if (self.overtimeTimer) {
        [self.overtimeTimer invalidate];
        self.overtimeTimer = nil;
    }
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
    _webSocket.delegate = nil;
    [_webSocket close];
    [self.fantasygameView removeALLproperty];
    self.prepareGameView = nil;
    self.fantasygameView = nil;
    [super leftBarButtonItemPressed:nil];
}

- (void)showGameRulerView
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"JoinFantasyGameCount"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"JoinFantasyGameCount"] intValue] == 1) {
        ;
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"JoinFantasyGameCount"];
        NSArray * typeArr = @[@"52张扑克随机打乱(没有大小王) 系统随机分配出牌顺序，会给每人两张底牌（只有自己看到），一张公牌各玩家共用，这三张牌将组成自己的牌。", @"按照玩家顺序依次操作，玩家有不换、换底牌、换公牌三种操作，当您觉得自己的牌满意即可选择不换，轮到下一玩家操作。如果不满意可以选择换底牌（需要扣除50碰碰币）或者换公牌（需要扣除100碰碰币）直到满意。", @"选择换牌的玩家后面的玩家都可以有一次操作机会，直到最近一次换牌玩家后面的玩家都选择不换牌，系统会进行开牌比牌，换牌扣除的碰碰币都会进入奖池，最终牌面最大的玩家将赢得奖池所有碰碰币。", @"比牌大小依据： 自己手中的两张牌加公牌一共三张\n1、豹子（AAA最大，222最小）。\n2、同花顺（AKQ最大，A23最小）。\n3、同花（AKJ最大，352最小）。\n4、顺子（AKQ最大，234最小）。\n5、对子（AAK最大，223最小）。\n6、单张（AKJ最大，352最小）"];
        GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"梦幻游戏规则" content:typeArr isRule:YES];
        [setTipView performSelector:@selector(show) withObject:nil afterDelay:1];
        [setTipView performSelector:@selector(dismiss) withObject:nil afterDelay:5];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
