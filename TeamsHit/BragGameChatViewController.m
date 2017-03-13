//
//  BragGameChatViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

/*
 游戏命令：
 （一）客户端请求命令
 1.发送游戏链接 ------- 1001 ，
 响应参数     ------ 10011
 2.准备游戏    ------- 1002，
 响应参数    ------- 10021
 3.摇骰子      ------- 1005，
 响应参数    ------- 10051
 4.重新摇骰子   ------- 1006，
 响应参数     ------- 10061
 5.确定摇到的骰子数 --- 1007，
 响应参数       -----10071
 6.叫点        ------- 1008，
 响应参数     ------- 10081
 7.开点        ------- 1009，
 响应参数     ------- 10091
 8.超时不叫  -------- 10010，
 响应参数    -------- 100101
 9.退出        ------- 10011，
 响应参数     ------- 100111
 
 （二）服务器push命令
 1.准备情况  ----- 10002
 2.开始     ----- 10003
 3.第一个叫点人 --  10004
 4.摇骰子情况 ---- 10007
 5.有人叫点   ---- 10008
 6.有人开点   ---- 10009
 7.超时不叫  ----- 100010
 8.普通退出游戏 --- 100011
 9.游戏结束  ----- 100012
 
 
 */

#import "BragGameChatViewController.h"
#import "GroupDetailViewController.h"
#import "PrepareGameView.h"
#import "BragGameView.h"
#import "BragGameModel.h"
#import "GroupDetailSetTipView.h"
#import "BragGameOverView.h"
#import "AppDelegate.h"

#import "ChatListViewController.h"
#import "FriendListViewController.h"


#define SHAKEDICEPOINT 1005
#define RE_SHAKEDICEPOINT 1006
#define COMPLETE_SHAKEDICEPOINT 1007
#define CALLDICEPOINT 1008
#define OPENDICEPOINT 1009
#define TIMEOUTACTION 1010
#define QUITGAME 1011
#define GAMEOVERREQUEST 1012
#define Web_Socket @"ws://120.26.131.140:8182/" // 正式
//#define Web_Socket @"ws://120.26.131.140:8183/" // 测试
//#define Web_Socket @"ws://192.168.1.108:8183/"// 测试ping

@interface BragGameChatViewController ()< PrepareGameProtocol, BragGameViewProtocol, UIAlertViewDelegate, SRWebSocketDelegate>
{
    GroupDetailSetTipView * quitTipView;
     SRWebSocket *_webSocket;
    MBProgressHUD * hud;
}

@property (nonatomic, strong)PrepareGameView * prepareGameView;
@property (nonatomic, strong)BragGameView * bragGameView;
@property (nonatomic, strong)NSMutableArray * GameUserInfoArr;// 存储游戏用户信息
//@property (nonatomic, strong)NSMutableArray * gameUserInformationArr;// 存储用户游戏信息
@property (nonatomic, strong)NSNumber * gameId;

@property (nonatomic, strong)BragGameOverView * gameOverView;

@property (nonatomic, assign)BOOL isStartGame;
@property (nonatomic, assign)BOOL isFinishGame;
@property (nonatomic, assign)BOOL IsViewer;
// 剩余等待时间定时器
@property (nonatomic, strong)NSTimer * leaveTime;

@property (nonatomic, strong)NSTimer * pingTimer;
@property (nonatomic, strong)NSTimer * overtimeTimer;

// 断线重连
@property (nonatomic, strong)UIAlertView * socketAlert;
@property (nonatomic, strong)NSTimer * socketTimer;
@property (nonatomic, assign)BOOL reConnect;

@end

@implementation BragGameChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.prepareGameView = [[PrepareGameView alloc]initWithFrame:CGRectMake(0, 64, self.backImageView.hd_width, 400)];
    self.prepareGameView.delegate = self;
    self.prepareGameView.hidden = NO;
    [self.backImageView addSubview:self.prepareGameView];
    
    self.bragGameView = [[BragGameView alloc]initWithFrame:CGRectMake(0, 64, self.view.hd_width, self.view.hd_height)];
    self.bragGameView.hidden = YES;
    self.bragGameView.delegate = self;
    [self.backImageView addSubview:self.bragGameView];
    
    self.GameUserInfoArr = [NSMutableArray array];
//    self.gameUserInformationArr = [NSMutableArray array];
    
    self.reConnect = YES;
    // 建立WebSocket连接
    if (_webSocket ==nil) {
        _webSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Web_Socket]]];
        _webSocket.delegate =self;
        [_webSocket open];
    }
    
//    self.headerView.typeLabel.text = @"吹牛";
    
    [self showGameRulerView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - BrageGameViewHeaderViewProtocol
- (void)setUpGameChatGroup
{
    NSLog(@"群组设置");
    GroupDetailViewController * groupDetailVC = [[GroupDetailViewController alloc]init];
    groupDetailVC.groupID = self.targetId;
    __weak BragGameChatViewController * weakSelf = self;
    [groupDetailVC quitGameRoom:^{
        [weakSelf removeAllsubViews];
    }];
    [self.navigationController pushViewController:groupDetailVC animated:YES];
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
    }
}

#pragma mark set up in the game
- (void)lookRuler
{
    NSArray * typeArr = @[@"轮流叫出不超过桌面上所有骰子的个数。", @"当你认为上家加的点数太大时，就开 TA吧！", @"一点可以当其他使用，但如果有人叫 了一点后，就变成一个普通点了。"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"吹牛游戏规则" content:typeArr isRule:YES ishaveQuit:YES];
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
        [dictionary setValue:@(QUITGAME) forKey:@"GameCommand"];
        [dictionary setValue:self.gameId forKey:@"GameId"];
        
        [quitTipView dismiss];
        [_webSocket send:[dictionary JSONString]];
        NSLog(@"callDicePOint %@", [dictionary JSONString]);
    }
    
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
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
    [self.bragGameView removeALLproperty];
    self.prepareGameView = nil;
    self.bragGameView = nil;
    self.gameOverView = nil;
    [super leftBarButtonItemPressed:nil];
}

#pragma mark - SRWebSocketDelegate 写上具体聊天逻辑
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(1001) forKey:@"GameCommand"];
    
    [_webSocket send:[dictionary JSONString]];
    
    self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pingAction) userInfo:nil repeats:YES];
    
    self.reConnect = YES;
    [hud hide:YES];
    [self.socketTimer invalidate];
    self.socketTimer = nil;
    [self.socketAlert performSelector:@selector(dismiss) withObject:nil afterDelay:0.01];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    if (_reConnect) {
        hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"网络不稳定，连接中...";
        [hud show:YES];
        self.socketTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(socketConnectTimeout) userInfo:nil repeats:NO];
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
            case 10011:
                // 发送游戏链接
                break;
            case 10021:
                // 准备游戏
                [self prepareAction1];
                break;
            case 10051:
                // 摇骰子
                [self selfShakeDice:messageDic];
                break;
            case 10061:
                // 重新摇骰子
                [self selfShakeDice:messageDic];
                break;
            case 10071:
                // 确定摇到的骰子数
                // push里面有操作，此处就不用再进行操作了
                break;
            case 10081:
                // 叫点
                // push里面有操作，此处就不用再进行操作了
                break;
            case 10091:
                // 开点
                // push里面有操作，此处就不用再进行操作了
                break;
            case 10101:
                // 超时不叫
                // push里面有操作，此处就不用再进行操作了
                break;
            case 10111:
                // 退出游戏
                [self quitgame];
                break;
            case 10121:
                // 游戏结束
                [self showgameOverView:messageDic];
                break;
            case 10002:
                // 准备push
                [self gameuserPrepareAction:messageDic];
                break;
            case 10003:
                // 开始游戏
                [self startGame:messageDic];
                break;
            case 10004:
                // 第一个叫点的人
                [self setFirstCallDicePointUser:messageDic];
                break;
            case 10007:
                // 有人摇骰子
                [self shakeDice:messageDic];
                break;
            case 10008:
                // 有人叫点
                [self callDicePoint:messageDic];
                break;
            case 10009:
                // 有人开点
                [self openDIcePoint:messageDic];
                break;
            case 100010:
                // 超时不叫
                [self callDicePoint:messageDic];
                break;
            case 100011:
                // 普通退出游戏
                [self gameUserQuitGame:messageDic];
                break;
            case 100012:
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
    
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
//    NSLog(@"pong");
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
    self.overtimeTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(overTimeAction) userInfo:nil repeats:YES];
    NSLog(@"发送了ping");
}

- (void)overTimeAction
{
    NSLog(@"断开连接了");
    [self.pingTimer invalidate];
    self.pingTimer = nil;
    [self.overtimeTimer invalidate];
    self.overtimeTimer = nil;
    [_webSocket close];
    [self connectSocket];
}

- (void)connectSocket
{
    _webSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Web_Socket]]];
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
    [dictionary setValue:@(1002) forKey:@"GameCommand"];
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
            [dictionary setValue:@(QUITGAME) forKey:@"GameCommand"];
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
    
    if (self.prepareGameView.dataSourceArray.count >=2 && self.prepareGameView.dataSourceArray.count < 6) {
        if (self.leaveTime) {
            [self stopTimeDown];
        }
        self.headerView.timeLabel.text = @"15";
        self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
    }else
    {
        self.headerView.timeLabel.hidden = YES;
        self.headerView.view1.hidden = NO;
        self.headerView.view2.hidden = NO;
    }
    
    [self.prepareGameView reloadDataAction];
}

- (void)gameUserQuitGame:(NSDictionary *)dic
{
    if (!self.isStartGame) {
        [self gameuserPrepareAction:dic];
    }
}

#pragma mark - BragGameViewProtocol

- (void)quitBragGameView
{
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

- (void)bragShakeDIceCup
{
    NSLog(@"开始摇骰盅");
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(SHAKEDICEPOINT) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}
- (void)bragReshakeCup
{
    NSLog(@"重新摇晃");
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(RE_SHAKEDICEPOINT) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}
- (void)bragCompleteShakeDiceCup
{
    NSLog(@"摇晃完成");
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(COMPLETE_SHAKEDICEPOINT) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}

- (void)bragChooseCompleteWithnumber:(int)number point:(int )point
{
    NSLog(@"您选择了 %d 个 *** %d 点", number , point);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(CALLDICEPOINT) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    [dictionary setValue:@(number) forKey:@"DiceCount"];
    [dictionary setValue:@(point) forKey:@"DicePoint"];
    
    [_webSocket send:[dictionary JSONString]];
    
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
    
//    self.bragGameView.hidden = YES;
//    [self.bragGameView begainState];
//    [self.prepareGameView begainState];
//    self.prepareGameView.hidden = NO;
    
}

// 超时不叫
- (void)timeoutAction
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(TIMEOUTACTION) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
}

- (void)openGameuser:(NSString *)beOpendUserId
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(OPENDICEPOINT) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    [dictionary setValue:@(beOpendUserId.intValue) forKey:@"BeOpenUserId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
    
}

// 游戏结束，获取最后结果
- (void)getGameResultSourceRequest
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(GAMEOVERREQUEST) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
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
    self.bragGameView.hidden = NO;
    [self.bragGameView cratGameUserInformation:self.GameUserInfoArr  withDic:dic];
    
    self.headerView.timeLabel.text = @"30";
    if (self.leaveTime) {
        [self stopTimeDown];
    }
    self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
}

// 第一个叫点的人
- (void)setFirstCallDicePointUser:(NSDictionary *)dic
{
    [self.bragGameView FirstCallDicePointUser:[NSString stringWithFormat:@"%@", [dic objectForKey:@"UserId"]]];
    self.headerView.timeLabel.text = @"30";
    if (self.leaveTime) {
         [self stopTimeDown];
    }
    self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
}

// 自己摇点
- (void)selfShakeDice:(NSDictionary *)dic
{
    [self.bragGameView selfShakeDice:dic];
}

// 更新摇点状态
- (void)shakeDice:(NSDictionary *)dic
{
    [self.bragGameView shakeDiceWithDic:dic];
}

// 有人叫点
- (void)callDicePoint:(NSDictionary *)dic
{
    [self.bragGameView callDicePoint:dic];
    self.headerView.timeLabel.text = @"30";
    if (self.leaveTime) {
         [self stopTimeDown];
    }
    self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
}

// 有人开点
- (void)openDIcePoint:(NSDictionary *)dic
{
    [self.bragGameView openDIcePoint:dic];
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
    self.headerView.timeLabel.text = @"0";
}

// 游戏结束
- (void)gameOver
{
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
        self.headerView.timeLabel.text = @"0";
    }
    // 网络没问题的话，结束响应肯定在push之前
    if (self.isFinishGame) {
        // 已经收到结束响应，就不用再处理push了
        NSLog(@"游戏已结束,重置界面");
        self.isStartGame = NO;
        [self.GameUserInfoArr removeAllObjects];
        
        [self.bragGameView begainState];
        [self.prepareGameView begainState];
    }else
    {
        // 如果已经收到游戏结束响应的话，界面已经被重置了，此时根据界面是否重置，判断是否已经接受到结束响应，没收到的话根据push命令来重置界面
        NSLog(@"还没有收到结束响应");
        if (self.prepareGameView.hidden) {
            self.isStartGame = NO;
            [self.GameUserInfoArr removeAllObjects];
            
            [self.bragGameView begainState];
            [self.prepareGameView begainState];
        }
    }
    
}

// 收到游戏结束请求
- (void)showgameOverView:(NSDictionary *)dic
{
    self.isFinishGame = YES;
    NSArray * nibarr = [[NSBundle mainBundle]loadNibNamed:@"BragGameOverView" owner:self options:nil];
    self.gameOverView = [nibarr objectAtIndex:0];
    
    NSMutableDictionary * dic1 = [dic mutableCopy];
    NSNumber * winUserId = [dic objectForKey:@"WinUserId"];
    NSNumber * loseUserId = [dic objectForKey:@"LoseUserId"];
    NSString * winUserIcon = @"";
    NSString * loseUserIcon = @"";
    for (BragGameModel * model in self.bragGameView.gameUserInformationArr) {
        if (winUserId.intValue == model.gameUserInfo.userId.intValue) {
            winUserIcon = model.gameUserInfo.portraitUri;
        }
        if (loseUserId.intValue == model.gameUserInfo.userId.intValue) {
            loseUserIcon = model.gameUserInfo.portraitUri;
        }
    }
    [dic1 setObject:winUserIcon forKey:@"WinUserIcon"];
    [dic1 setObject:loseUserIcon forKey:@"LoseUserIcon"];
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    [self.gameOverView creatUIWithDic:dic1];
    self.gameOverView.hd_centerX = self.view.hd_centerX;
    [delegate.window addSubview:self.gameOverView];
    
    [self performSelector:@selector(removeGameOverView) withObject:nil afterDelay:5];
}
- (void)removeGameOverView
{
    [self.gameOverView removeFromSuperview];
    [self gameOver];
}
- (void)stopTimeDown
{
    [self.leaveTime invalidate];
    self.leaveTime = nil;
    self.headerView.timeLabel.hidden = YES;
    self.headerView.view1.hidden = NO;
    self.headerView.view2.hidden = NO;
}

- (void)dealloc
{
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
    NSLog(@"关闭socket连接");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showGameRulerView
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"JoinBragGameCount"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"JoinBragGameCount"] intValue] == 1) {
        ;
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"JoinBragGameCount"];
        NSArray * typeArr = @[@"轮流叫出不超过桌面上所有骰子的个数。", @"当你认为上家加的点数太大时，就开 TA吧！", @"一点可以当其他使用，但如果有人叫 了一点后，就变成一个普通点了。"];
        GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"吹牛游戏规则" content:typeArr isRule:YES];
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
