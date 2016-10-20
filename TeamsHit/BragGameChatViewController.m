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

#define SHAKEDICEPOINT 1005
#define RE_SHAKEDICEPOINT 1006
#define COMPLETE_SHAKEDICEPOINT 1007
#define CALLDICEPOINT 1008
#define OPENDICEPOINT 1009
#define TIMEOUTACTION 1010
#define QUITGAME 1011
#define GAMEOVERREQUEST 1012

@interface BragGameChatViewController ()< PrepareGameProtocol, BragGameViewProtocol, UIAlertViewDelegate>
{
    GroupDetailSetTipView * quitTipView;
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
    
    // Do any additional setup after loading the view.
}

#pragma mark - BrageGameViewHeaderViewProtocol
- (void)setUpGameChatGroup
{
    
    if (self.isStartGame) {
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
        
    }else
    {
        NSLog(@"群组设置");
        GroupDetailViewController * groupDetailVC = [[GroupDetailViewController alloc]init];
        groupDetailVC.groupID = self.targetId;
        [self.navigationController pushViewController:groupDetailVC animated:YES];
    }
    
}

// 倒计时
- (void)leaveTimeAction
{
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
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(QUITGAME) forKey:@"GameCommand"];
    [dictionary setValue:self.gameId forKey:@"GameId"];
    
    [_webSocket send:[dictionary JSONString]];
    [quitTipView dismiss];
//    [_webSocket close];
    NSLog(@"callDicePOint %@", [dictionary JSONString]);
    
    
    
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

- (void)removeAllsubViews
{
    self.prepareGameView = nil;
    self.bragGameView = nil;
    self.gameOverView = nil;
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
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
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接失败，是否重新连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10000;
    [alert show];
    
}

#warning *** socket connect question
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 10000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        if (alertView.tag == 10000) {
            [_webSocket close];
            [self connectSocket];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message//监控消息
{
    NSError *errpr = nil;
    NSLog(@"%@ *** %@", [message class], message);
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
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [messageDic objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}

#pragma mark - PrepareGameProtocol
- (void)prepareAction
{
    NSLog(@"发送准备命令");
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
    [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
    [dictionary setValue:@(1002) forKey:@"GameCommand"];
    if (_webSocket.readyState) {
        ;
    }
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
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
        [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
        [dictionary setValue:@(QUITGAME) forKey:@"GameCommand"];
        [dictionary setValue:@0 forKey:@"GameId"];
        
        NSLog(@"%@", [dictionary description]);
        
        [_webSocket send:[dictionary JSONString]];
        NSLog(@"callDicePOint %@", [dictionary JSONString]);
        NSLog(@"请求后退出");
    }else
    {
//        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//        [dictionary setValue:@([RCIM sharedRCIM].currentUserInfo.userId.intValue) forKey:@"UserId"];
//        [dictionary setValue:@(self.targetId.intValue) forKey:@"GroupId"];
//        [dictionary setValue:@(QUITGAME) forKey:@"GameCommand"];
//        [dictionary setValue:@0 forKey:@"GameId"];
//        
//        [_webSocket send:[dictionary JSONString]];
//        NSLog(@"callDicePOint %@", [dictionary JSONString]);
//        [self.navigationController popViewControllerAnimated:YES];
    }
    [_webSocket close];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

- (void)quitgame
{
    [_webSocket close];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
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
        self.headerView.timeLabel.text = @"25";
        if (self.leaveTime) {
            [self.leaveTime invalidate];
            self.leaveTime = nil;
        }
        self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
    }else
    {
       self.headerView.timeLabel.text = @"0";
    }
    
    [self.prepareGameView reloadDataAction];
}

- (void)gameUserQuitGame:(NSDictionary *)dic
{
    RCUserInfo * user = [RCUserInfo new];
    
    for (RCUserInfo * userInfo in self.GameUserInfoArr) {
        if ([userInfo.userId isEqualToString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"UserId"]]]) {
            user = userInfo;
            break;
        }
    }
    
    [self.GameUserInfoArr removeObject:user];
    [self.prepareGameView reloadDataAction];
    [self removeAllsubViews];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

}

#pragma mark - BragGameViewProtocol
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
    
    self.headerView.timeLabel.text = @"25";
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
    self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
}

// 第一个叫点的人
- (void)setFirstCallDicePointUser:(NSDictionary *)dic
{
    [self.bragGameView FirstCallDicePointUser:[NSString stringWithFormat:@"%@", [dic objectForKey:@"UserId"]]];
    self.headerView.timeLabel.text = @"30";
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
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
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
    self.leaveTime  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leaveTimeAction) userInfo:nil repeats:YES];
}

// 有人开点
- (void)openDIcePoint:(NSDictionary *)dic
{
    [self.bragGameView openDIcePoint:dic];
    self.headerView.timeLabel.text = @"0";
    if (self.leaveTime) {
        [self.leaveTime invalidate];
        self.leaveTime = nil;
    }
    
}

// 游戏结束
- (void)gameOver
{
    // 网络没问题的话，结束响应肯定在push之前
    if (self.isFinishGame) {
        // 已经收到结束响应，就不用再处理push了
        self.isStartGame = NO;
        [self.GameUserInfoArr removeAllObjects];
        
        [self.bragGameView begainState];
        [self.prepareGameView begainState];
    }else
    {
        // 如果已经收到游戏结束响应的话，界面已经被重置了，此时根据界面是否重置，判断是否已经接受到结束响应，没收到的话根据push命令来重置界面
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

- (void)dealloc
{
    [_webSocket close];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
