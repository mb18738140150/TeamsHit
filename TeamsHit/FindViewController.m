//
//  FindViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FindViewController.h"
#import "WXViewController.h"
#import "TypeofGameTableViewCell.h"
#import "TypeofGameModel.h"
#import "GroupDetailSetTipView.h"
#import "CreatGroupChatRoomViewController.h"
#import "BragGameChatViewController.h"
#import "FantasyGameChatViewController.h"
#import "ChooseCreatGameTypeView.h"

#define TYPEOFGAMECELLIDENTIFIRE @"TypeofGameCell"

@interface FindViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD* hud ;
    UIButton * doneInKeyboardButton;
    GroupDetailSetTipView * setTipView;
}
@property (strong, nonatomic) IBOutlet UIView *friendCircle;
@property (strong, nonatomic) IBOutlet UILabel *noreadMassageNumberLabel;
@property (strong, nonatomic) IBOutlet UITableView *gameTypelist;

@property (nonatomic, strong)NSMutableArray * typedDatesourceArr;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"navigationlogo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    UITapGestureRecognizer * friendCircleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(friendCircleTapAction:)];
    [self.friendCircle addGestureRecognizer:friendCircleTap];
    
    self.noreadMassageNumberLabel.layer.cornerRadius = 8;
    self.noreadMassageNumberLabel.layer.masksToBounds = YES;
    self.noreadMassageNumberLabel.text = @"";
    self.noreadMassageNumberLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.gameTypelist registerNib:[UINib nibWithNibName:@"TypeofGameTableViewCell" bundle:nil] forCellReuseIdentifier:TYPEOFGAMECELLIDENTIFIRE];
//    self.gameTypelist.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendCircleMessageCount:) name:@"UpdateFriendCircleMessageCount" object:nil];
    
    self.typedDatesourceArr = [NSMutableArray array];
    for (int i = 0; i<2; i++) {
        TypeofGameModel * model = [[TypeofGameModel alloc]init];
        
        switch (i) {
            case 0:
                model.backGroundImageViewtext = @"bragBackgroundcolorView";
                model.typeOfGameImageViewtext = @"BragSign";
                model.titlelabeltext = @"吹牛";
                [self.typedDatesourceArr addObject:model];
                break;
            case 1:
                model.backGroundImageViewtext = @"21pointBackgroundcolorView";
                model.typeOfGameImageViewtext = @"21pointSign";
                model.titlelabeltext = @"梦幻";
                [self.typedDatesourceArr addObject:model];
                break;
            case 2:
                model.backGroundImageViewtext = @"21pointBackgroundcolorView";
                model.typeOfGameImageViewtext = @"21pointSign";
                model.titlelabeltext = @"21点";
                [self.typedDatesourceArr addObject:model];
                break;
            default:
                break;
        }
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOnDelay:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateFriendCircleMessageCount:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.noreadMassageNumberLabel.hidden) {
            weakSelf.noreadMassageNumberLabel.hidden = NO;
        }
        NSLog(@"[[RCDataBaseManager shareInstance]getFriendcircleMessageNumber] = %d", [[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]);
        weakSelf.noreadMassageNumberLabel.text = [NSString stringWithFormat:@"%d", [[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]];
        weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",[[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    if ([[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]) {
        self.noreadMassageNumberLabel.hidden = NO;
        self.noreadMassageNumberLabel.text = [NSString stringWithFormat:@"%d", [[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]];
    }else{
        self.noreadMassageNumberLabel.hidden = YES;
        self.tabBarItem.badgeValue = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)friendCircleTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"朋友圈界面");
    WXViewController * wxVC = [[WXViewController alloc]init];
    wxVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wxVC animated:YES];
}

#pragma mark - 按房号加房间
- (IBAction)addGroupAction:(id)sender {
    
    NSLog(@"加入群");
    
    NSArray * typeArr = [NSArray array];
    setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请输入房间号" content:typeArr];
    setTipView.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    setTipView.textFiled.returnKeyType = UIReturnKeyDone;
//    setTipView.textFiled.delegate = self;
    [setTipView.textFiled becomeFirstResponder];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(string.intValue)
                                   };
        __weak FindViewController * weakSelf = self;
        [[HDNetworking sharedHDNetworking]quickJoinWithGroupid:jsonDic success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            [hud hide:YES];
            
            if ([[responseObject objectForKey:@"GroupType"] intValue] == 1) {
                [weakSelf pushgameViewWith:string];
            }else if ([[responseObject objectForKey:@"GroupType"] intValue] == 2)
            {
                [weakSelf pushFantasygameView:string];
            }
            
            
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
                ;
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                NSLog(@"%@", error);
            }
        }];
        
    }];
}
- (IBAction)creatGroupAction:(id)sender {
    
    NSLog(@"creat a group");
    
//    ChooseCreatGameTypeView * chooseView = [[ChooseCreatGameTypeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [chooseView show];
    
    CreatGroupChatRoomViewController * crearGroupVc = [[CreatGroupChatRoomViewController alloc]init];
    crearGroupVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:crearGroupVc animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typedDatesourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TypeofGameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TYPEOFGAMECELLIDENTIFIRE forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    TypeofGameModel * model = self.typedDatesourceArr[indexPath.row];
    cell.backGroundImageView.image = [UIImage imageNamed:model.backGroundImageViewtext];
    cell.typeOfGameImageView.image = [UIImage imageNamed:model.typeOfGameImageViewtext];
    cell.titlelabel.text = model.titlelabeltext;
    __weak FindViewController * weakself = self;
    [cell begainGame:^{
        [weakself begainGame:indexPath];
    }];
    
    [cell lookRuller:^{
        [weakself lookRuller:indexPath];
    }];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"select");
//    if (indexPath.row == 0) {
//        
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [hud show:YES];
//        NSDictionary * jsonDic = @{
//                                   @"GroupType":@(indexPath.row + 1)
//                                   };
//        __weak FindViewController * weakSelf = self;
//        [[HDNetworking sharedHDNetworking]randomAssignWithGroupType:jsonDic success:^(id  _Nonnull responseObject) {
//            NSLog(@"responseObject = %@", responseObject);
//            [hud hide:YES];
//            
//            [weakSelf pushgameViewWith:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"GroupId"]]];
//            
//            
//            
//        } failure:^(NSError * _Nonnull error) {
//            [hud hide:YES];
//            if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
//                ;
//            }else
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//                [alert show];
//                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
//                NSLog(@"%@", error);
//            }
//        }];
//    }else if (indexPath.row == 1)
//    {
//        FantasyGameChatViewController * conversationVC = [[FantasyGameChatViewController alloc]init];
//        conversationVC.conversationType = ConversationType_GROUP;
//        conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
//        conversationVC.enableUnreadMessageIcon=YES;
//        conversationVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:conversationVC animated:YES];
//        // 同步组群
//        [RCDDataSource syncGroups];
//    }else if (indexPath.row == 2)
//    {
//        NSLog(@"21点");
//    }
    
}

- (void)begainGame:(NSIndexPath *)indexPath
{
    NSLog(@"select");
    if (indexPath.row == 0) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupType":@(1)
                                   };
        __weak FindViewController * weakSelf = self;
        [[HDNetworking sharedHDNetworking]randomAssignWithGroupType:jsonDic success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            
            [weakSelf pushgameViewWith:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"GroupId"]]];
            
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
                ;
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                NSLog(@"%@", error);
            }
        }];
    }else if (indexPath.row == 1)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupType":@(2)
                                   };
        __weak FindViewController * weakSelf = self;
        [[HDNetworking sharedHDNetworking]randomAssignWithGroupType:jsonDic success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            [hud hide:YES];
            
            [weakSelf pushFantasygameView:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"GroupId"]]];
            
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            if ([[error.userInfo objectForKey:@"miss"] isEqualToString:@"请求失败"]) {
                ;
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                NSLog(@"%@", error);
            }
        }];
        
    }else if (indexPath.row == 2)
    {
        NSLog(@"21点");
    }
    
}

- (void)lookRuller:(NSIndexPath *)indexPath
{
    NSLog(@"select");
    if (indexPath.row == 0) {
        NSArray * typeArr = @[@"轮流叫出不超过桌面上所有骰子的个数。", @"当你认为上家加的点数太大时，就开 TA吧！", @"一点可以当其他使用，但如果有人叫 了一点后，就变成一个普通点了。"];
        GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"吹牛游戏规则" content:typeArr isRule:YES];
        [setTipView show];
        
    }else if (indexPath.row == 1)
    {
        NSArray * typeArr = @[@"52张扑克随机打乱(没有大小王) 系统随机分配出牌顺序，会给每人两张底牌（只有自己看到），一张公牌各玩家共用，这三张牌将组成自己的牌。", @"按照玩家顺序依次操作，玩家有不换、换底牌、换公牌三种操作，当您觉得自己的牌满意即可选择不换，轮到下一玩家操作。如果不满意可以选择换底牌（需要扣除50碰碰币）或者换公牌（需要扣除100碰碰币）直到满意。", @"选择换牌的玩家后面的玩家都可以有一次操作机会，直到最近一次换牌玩家后面的玩家都选择不换牌，系统会进行开牌比牌，换牌扣除的碰碰币都会进入奖池，最终牌面最大的玩家将赢得奖池所有碰碰币。", @"比牌大小依据： 自己手中的两张牌加公牌一共三张\n1、豹子（AAA最大，222最小）。\n2、同花顺（AKQ最大，A23最小）。\n3、同花（AKJ最大，352最小）。\n4、顺子（AKQ最大，234最小）。\n5、对子（AAK最大，223最小）。\n6、单张（AKJ最大，352最小）"];
        GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"梦幻游戏规则" content:typeArr isRule:YES];
        [setTipView show];
    }else if (indexPath.row == 2)
    {
        NSLog(@"21点");
    }
}

- (void)pushgameViewWith:(NSString *)typeid
{
    // 同步组群
    __weak typeof(self) weakself = self;
    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        
        NSArray * groupArr = [[RCDataBaseManager shareInstance]getAllGroup];
        BOOL haveStore = NO;
        for ( RCDGroupInfo *groupInfo in groupArr) {
            if ([groupInfo.groupId isEqualToString:typeid]) {
                haveStore = YES;
            }
        }
        
        if (haveStore) {
            [hud hide:YES];
            BragGameChatViewController * conversationVC = [[BragGameChatViewController alloc]init];
            conversationVC.conversationType = ConversationType_GROUP;
            conversationVC.targetId = typeid;
            conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
            conversationVC.enableUnreadMessageIcon=YES;
            conversationVC.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:conversationVC animated:YES];
        }else
        {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                BOOL haveStore1 = NO;
                NSArray * groupArr1 = [[RCDataBaseManager shareInstance]getAllGroup];
                for ( RCDGroupInfo *groupInfo in groupArr1) {
                    if ([groupInfo.groupId isEqualToString:typeid]) {
                        haveStore1 = YES;
                    }
                }
                if (haveStore1) {
                    [timer invalidate];
                    timer = nil;
                    [hud hide:YES];
                    BragGameChatViewController * conversationVC = [[BragGameChatViewController alloc]init];
                    conversationVC.conversationType = ConversationType_GROUP;
                    conversationVC.targetId = typeid;
                    conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
                    conversationVC.enableUnreadMessageIcon=YES;
                    conversationVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:conversationVC animated:YES];
                }
            }];
        }
        
    }];
}

- (void)pushFantasygameView:(NSString *)typaId
{
    // 同步组群
    [RCDDataSource syncGroups];
    FantasyGameChatViewController * conversationVC = [[FantasyGameChatViewController alloc]init];
    conversationVC.conversationType = ConversationType_GROUP;
    conversationVC.targetId = typaId;
    conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    conversationVC.enableUnreadMessageIcon=YES;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    //用remove移除比隐藏好，有动画，加载时间比hidden长一点
    if (doneInKeyboardButton.superview)
    {
        [doneInKeyboardButton removeFromSuperview];
        //        doneInKeyboardButton.hidden=YES;
    }
}

- (void)keyboardWillShowOnDelay:(NSNotification *)notification {
    [self performSelector:@selector(keyboardWillShow:) withObject:nil afterDelay:0];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //确定屏幕位置
        doneInKeyboardButton.frame = CGRectMake(0, 163, 106, 53);
       
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        //图片自己找，没有的话注释下面两行，比较难看而已，正常的手写button代码
        [doneInKeyboardButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *foundKeyboard = nil;
    foundKeyboard = [self findKeyboard];
//    [foundKeyboard addSubview:doneInKeyboardButton];
}
- (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}
- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}
-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    [setTipView.textFiled resignFirstResponder];//功能同上，用一
}

- (void)dealloc {
    //反注册通知，不用了就得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
