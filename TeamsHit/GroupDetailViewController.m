//
//  GroupDetailViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "FriendListViewController.h"

#import "GroupDetailSetTipView.h"
#import "TeamHitCollectionView.h"
#import "CreatGroupChatRoomViewController.h"
#import "GroupNumberDetailsViewController.h"
#import "FriendInformationViewController.h"
#import "GameBackImageViewController.h"
@interface GroupDetailViewController ()<LookUserDetailDelegate>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UIView *groupMenberInfo;
@property (strong, nonatomic) IBOutlet UILabel *groupNumberLabel;// 群组人数
@property (strong, nonatomic) IBOutlet UILabel *groupRoomNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupVerifyLabel;

@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupMumberlabel;// 游戏人数
@property (strong, nonatomic) IBOutlet UIButton *noticeBT;// 消息免打扰按钮
@property (strong, nonatomic) IBOutlet UILabel *minCoinNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *quitBT;

@property (nonatomic, strong)TeamHitCollectionView * teamCollectionView;
@property (nonatomic, strong)NSMutableArray * groupMemberArr;
@property (nonatomic, assign)int GroupType;
@property (nonatomic, assign)int VerificationType;
@property (nonatomic, assign)int minCoin;
@property (nonatomic, assign)int minGameUserCount;
@property (nonatomic, copy)QuitGroupBlock myBlock;
@property (nonatomic, copy)NSString * groupManagerID;

@property (nonatomic, copy)NSString * groupMumberIDs;

@end

@implementation GroupDetailViewController

- (NSMutableArray *)groupMemberArr
{
    if (!_groupMemberArr) {
        _groupMemberArr = [NSMutableArray array];
    }
    return _groupMemberArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    RCDGroupInfo * rcGroupInfo = [[RCDataBaseManager shareInstance]getGroupByGroupId:self.groupID];;
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.title = rcGroupInfo.groupName;
    
    [self.noticeBT setImage:[UIImage imageNamed:@"noForbid"] forState:UIControlStateNormal];
    [self.noticeBT setImage:[UIImage imageNamed:@"forbid"] forState:UIControlStateSelected];
    
    
    self.teamCollectionView = [[TeamHitCollectionView alloc]initWithFrame:CGRectMake(0, 9, screenWidth, (screenWidth - 64) / 5 + 16)];
    [self.groupMenberInfo addSubview:_teamCollectionView];
    _teamCollectionView.delegate = self;
    self.groupManagerID = rcGroupInfo.creatorId;
    __weak GroupDetailViewController * weakSelf = self;
    [self.teamCollectionView addNewGroupMumber:^{
        [weakSelf addNewGroupMumber];
    }];
    
    self.groupNumberLabel.text = [NSString stringWithFormat:@"全部房间成员（%@）", rcGroupInfo.number];
    self.groupRoomNumberLabel.text = rcGroupInfo.groupId;
    self.groupNameLabel.text = rcGroupInfo.groupName;
    self.groupMumberlabel.text = rcGroupInfo.number;
    if (rcGroupInfo.GroupType == 1) {
        self.groupTypeLabel.text = @"吹牛";
    }else
    {
        self.groupTypeLabel.text = @"梦幻";
    }
    
    [self startLoadView];
    [self loadGroupData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNewGroupMumber
{
    __weak GroupDetailViewController * vc = self;
    CreatGroupChatRoomViewController * crearGroupVc = [[CreatGroupChatRoomViewController alloc]init];
    crearGroupVc.addGroupMember = YES;
    crearGroupVc.targetId = self.groupMumberIDs;
    crearGroupVc.groupID = self.groupID;
    [crearGroupVc addgroupMumberAction:^{
        [vc loadGroupData];
    }];
    
    crearGroupVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:crearGroupVc animated:YES];
}
#pragma mark - LookUserDetailDelegate
- (void)lookUserDetailWithUserid:(NSString *)userId
{
    FriendInformationViewController * friend = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
    friend.targetId = userId;
    [self.navigationController pushViewController:friend animated:YES];
}

-(void)startLoadView
{
//    currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP
//                                                                targetId:self.groupID];
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP
                                                            targetId:self.groupID
                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                 
                                                                 if (nStatus == DO_NOT_DISTURB) {
                                                                     NSLog(@"消息免打扰开启");
                                                                     self.noticeBT.selected = YES;
                                                                 }else
                                                                 {
                                                                     NSLog(@"消息免打扰开启未开启");
                                                                     self.noticeBT.selected = NO;
                                                                 }
                                                             }
                                                               error:^(RCErrorCode status){
                                                                   
                                                               }];
    
}

- (void)loadGroupData
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"GroupId":@(self.groupID.intValue)
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@groups/getGroupDetail?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak GroupDetailViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
//        NSLog(@"PortraitUri = %@", [responseObject objectForKey:@"PortraitUri"]);
//        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            [weakSelf refreshUIWith:responseObject];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        NSLog(@"%@", error);
    }];
}

- (void)refreshUIWith:(NSDictionary *)dic
{
    RCDGroupInfo * userInfo = [[RCDGroupInfo alloc]init];
    userInfo.groupId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"GroupId"]];
    userInfo.groupName = [dic objectForKey:@"GroupName"];
    userInfo.portraitUri = [dic objectForKey:@"PortraitUri"];
    userInfo.number = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Number"]];
    userInfo.maxNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"MaxNumber"]];
    userInfo.introduce = [dic objectForKey:@"Introduce"];
    userInfo.creatorId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CreatorId"]];
    self.groupManagerID = userInfo.creatorId;
    userInfo.creatorTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CreatorTime"]];
    if ([[dic objectForKey:@"Role"] intValue] == 1) {
        userInfo.isJoin = YES;
    }else
    {
        userInfo.isJoin = NO;
    }
    userInfo.GroupType = [[dic objectForKey:@"GroupType"] intValue];
//    if ([[dic objectForKey:@"GroupType"] intValue] == 1) {
//    }else if ([[dic objectForKey:@"GroupType"] intValue] == 2)
//    {
//        userInfo.GroupType = 2;
//    }
    if ([[dic objectForKey:@"IsDismiss"] intValue] == 1) {
        userInfo.isDismiss = @"1";
    }else
    {
        userInfo.isDismiss = @"0";
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[RCDataBaseManager shareInstance] insertGroupToDB:userInfo];
    });
    
    self.groupNumberLabel.text = [NSString stringWithFormat:@"全部房间成员（%@）", userInfo.number];
    self.groupNameLabel.text = userInfo.groupName;
    self.groupRoomNumberLabel.text = userInfo.groupId;
    self.GroupType = [[dic objectForKey:@"GroupType"] intValue];
    if (self.GroupType == 1) {
        self.groupTypeLabel.text = @"吹牛";
    }else if (self.GroupType == 2)
    {
        self.groupTypeLabel.text = @"梦幻";
    }
    self.groupMumberlabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"GamePeople"]];
    self.minCoinNumberLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"LeastCoins"]];
    NSArray * groupMenberInfoarr = [dic objectForKey:@"FriendList"];
    
    
    [self.teamCollectionView.dateSourceArray removeAllObjects];
    [self.groupMemberArr removeAllObjects];
    for (int i = 0; i < groupMenberInfoarr.count; i++) {
        NSDictionary * userDic = [groupMenberInfoarr objectAtIndex:i];
        RCUserInfo * user = [[RCUserInfo alloc]init];
        user.userId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"UserId"]];
        user.name = [userDic objectForKey:@"DisplayName"];
        user.portraitUri = [userDic objectForKey:@"PortraitUri"];
        [self.groupMemberArr addObject:user];
        if (i < 4) {
            [self.teamCollectionView.dateSourceArray addObject:user];
        }
        
        if (i == 0) {
            self.groupMumberIDs = user.userId;
        }else
        {
            self.groupMumberIDs = [self.groupMumberIDs stringByAppendingFormat:@",%@", user.userId];
        }
        
    }
    
    [self.teamCollectionView reloadDataAction];
}


- (IBAction)changeNameAction:(id)sender {
    
    if (![self isGroupManager]) {
        [self showNotManagerTip];
        return;
    }
    
    NSLog(@"改变房间名称");
    
    NSArray * typeArr = [NSArray array];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"修改房间名称" content:typeArr];
    [setTipView show];
    
    __weak GroupDetailViewController * weakself = self;
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   @"GroupName":string
                                   };;
        
        [[HDNetworking sharedHDNetworking]modifyGroupName:jsonDic success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            [hud hide:YES];
            weakself.groupNameLabel.text = string;
            RCDGroupInfo * rcGroupInfo = [[RCDataBaseManager shareInstance]getGroupByGroupId:weakself.groupID];
            rcGroupInfo.groupName = string;
            [weakself refresfGroupInfo:rcGroupInfo];
            RCGroup * group = [RCGroup new];
            group.groupName = rcGroupInfo.groupName;
            group.groupId = rcGroupInfo.groupId;
            group.portraitUri = rcGroupInfo.portraitUri;
            NSLog(@"%@, %@", group.portraitUri, rcGroupInfo.portraitUri);
            [[RCIM sharedRCIM] refreshGroupInfoCache:group
                                         withGroupId:weakself.groupID];
            
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
- (IBAction)changeTypeAction:(id)sender {
    
    if (![self isGroupManager]) {
        [self showNotManagerTip];
        return;
    }
    
    NSLog(@"改变房间type");
    NSArray * typeArr = @[@"吹牛", @"梦幻"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"游戏模式" content:typeArr];
    [setTipView show];
    __weak GroupDetailViewController * weakself = self;
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        if ([string isEqualToString:@"梦幻"]) {
            weakself.GroupType = 2;
        }else
        {
            weakself.GroupType = 1;
        }
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   @"GroupType":@(self.GroupType)
                                   };;
        
        [[HDNetworking sharedHDNetworking]modifyGroupType:jsonDic success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            if (weakself.GroupType == 2) {
                weakself.groupTypeLabel.text = @"梦幻";
            }else
            {
                weakself.groupTypeLabel.text = @"吹牛";
            }
            
            RCDGroupInfo * rcGroupInfo = [[RCDataBaseManager shareInstance]getGroupByGroupId:weakself.groupID];
            rcGroupInfo.GroupType = self.GroupType;
            [weakself refresfGroupInfo:rcGroupInfo];
            
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
- (IBAction)lookRuleAction:(id)sender {
    NSLog(@"查看规则");
    if (_GroupType == 1) {
        NSArray * typeArr = @[@"轮流叫出不超过桌面上所有骰子的个数。", @"当你认为上家加的点数太大时，就开 TA吧！", @"一点可以当其他使用，但如果有人叫 了一点后，就变成一个普通点了。"];
        GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"吹牛游戏规则" content:typeArr isRule:YES];
        [setTipView show];
    }else
    {
        NSArray * typeArr = @[@"52张扑克随机打乱(没有大小王) 系统随机分配出牌顺序，会给每人两张底牌（只有自己看到），一张公牌各玩家共用，这三张牌将组成自己的牌。", @"按照玩家顺序依次操作，玩家有不换、换底牌、换公牌三种操作，当您觉得自己的牌满意即可选择不换，轮到下一玩家操作。如果不满意可以选择换底牌（需要扣除50碰碰币）或者换公牌（需要扣除100碰碰币）直到满意。", @"选择换牌的玩家后面的玩家都可以有一次操作机会，直到最近一次换牌玩家后面的玩家都选择不换牌，系统会进行开牌比牌，换牌扣除的碰碰币都会进入奖池，最终牌面最大的玩家将赢得奖池所有碰碰币。", @"比牌大小依据： 自己手中的两张牌加公牌一共三张\n1、豹子（AAA最大，222最小）。\n2、同花顺（AKQ最大，A23最小）。\n3、同花（AKJ最大，352最小）。\n 4、顺子（AKQ最大，234最小）。\n5、对子（AAK最大，223最小）。\n6、单张（AKJ最大，352最小）"];
        GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"吹牛游戏规则" content:typeArr isRule:YES];
        [setTipView show];
    }
    
    
}
- (IBAction)changeMinCoinAction:(id)sender {
    
    if (![self isGroupManager]) {
        [self showNotManagerTip];
        return;
    }
    NSLog(@"改变碰碰币");
    NSArray * typeArr = @[@"50", @"100", @"200", @"400"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"最低碰碰币" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        if (string) {
            self.minCoin = string.intValue;
        }else
        {
            self.minCoin = 50;
            string = @"50";
        }
        NSLog(@"%@", string);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   @"LeastCoins":@(self.minCoin)
                                   };;
        
        [[HDNetworking sharedHDNetworking]modifyGroupLeastCoins:jsonDic success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            self.minCoinNumberLabel.text = string;
            
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
- (IBAction)noticeAction:(id)sender {
//    UIButton * button = (UIButton *)sender;
//    button.selected = !button.selected;
    
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP
                                                            targetId:self.groupID
                                                           isBlocked:!self.noticeBT.selected
                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     if (nStatus == DO_NOT_DISTURB) {
                                                                         NSLog(@"消息免打扰开启");
                                                                         self.noticeBT.selected = YES;
                                                                     }else
                                                                     {
                                                                         NSLog(@"消息免打扰未开启");
                                                                         self.noticeBT.selected = NO;
                                                                     }
                                                                 });
                                                                 
                                                             } error:^(RCErrorCode status) {
                                                                 NSLog(@"设置消息免打扰失败");
                                                             }];
    
}
- (IBAction)quitGroupAction:(id)sender {
    NSLog(@"退出房间");
    
    UIWebView*webView =[[UIWebView alloc] initWithFrame:CGRectMake(10,10,200,200)];
    
    NSURL *targetURL =[NSURL URLWithString:@"http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf"];
    NSURLRequest*request =[NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    return;
    
    NSArray * typeArr = @[@"确定退出房间？"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"退出房间" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   };
        __weak GroupDetailViewController * weakSelf = self;
        [[HDNetworking sharedHDNetworking]quitGroup:jsonDic success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            // 删除聊天记录并从聊天列表中删除
            [[RCIMClient sharedRCIMClient]deleteMessages:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%@", self.groupID] success:^{
                ;
            } error:^(RCErrorCode status) {
                ;
            }];
            
            [[RCIMClient sharedRCIMClient]removeConversation:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%@", weakSelf.groupID]];
            [[RCDataBaseManager shareInstance] deleteGroupToDB:self.groupID];
            
            if (weakSelf.myBlock) {
                weakSelf.myBlock();
            }
            
            UIViewController * viewController = [self.navigationController.viewControllers objectAtIndex:0];
            if ([viewController isKindOfClass:[FriendListViewController class]]) {
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }else
            {
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:0] animated:YES];
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
- (IBAction)groupVerifyAction:(id)sender {
    if (![self isGroupManager]) {
        [self showNotManagerTip];
        return;
    }
    NSArray * typeArr = @[@"允许任何人加入", @"不允许任何人加入"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"房间验证" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        if ([string isEqualToString:@"允许任何人加入"] || string == nil) {
            self.VerificationType = 1;
        }else if([string isEqualToString:@"不允许任何人加入"])
        {
            self.VerificationType = 2;
        }
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   @"VerificationType":@(self.VerificationType)
                                   };
        
        [[HDNetworking sharedHDNetworking]modifyGroupVerifition:jsonDic success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            if (self.VerificationType == 1) {
                self.groupVerifyLabel.text = @"允许任何人加入";
            }else if(self.VerificationType == 2)
            {
                self.groupVerifyLabel.text = @"不允许任何人加入";
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

- (IBAction)changeGameUserCountAction:(id)sender {
    
    if (![self isGroupManager]) {
        [self showNotManagerTip];
        return;
    }
    NSArray * typeArr = @[@"3", @"4", @"5", @"6"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"最大游戏人数" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        if (string) {
            self.minGameUserCount = string.intValue;
        }else
        {
            self.minGameUserCount = 3;
            string = @"3";
        }
        NSLog(@"%@", string);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   @"GamePeople":@(self.minGameUserCount)
                                   };
        
        [[HDNetworking sharedHDNetworking]modifyGamePeople:jsonDic success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            self.groupMumberlabel.text = string;
            
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

- (IBAction)changeGameBackImageAction:(id)sender {
    GameBackImageViewController * gameBackimageVC = [[GameBackImageViewController alloc]init];
    [self.navigationController pushViewController:gameBackimageVC animated:YES];
}

- (BOOL)isGroupManager
{
    if ([self.groupManagerID isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        return YES;
    }else
    {
        return NO;
    }
}

- (void)showNotManagerTip
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"只有房主可以修改" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.2];
}

- (void)refresfGroupInfo:(RCDGroupInfo *)userInfo
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[RCDataBaseManager shareInstance] insertGroupToDB:userInfo];
    });
}
- (IBAction)lookGroupMember:(id)sender {
    GroupNumberDetailsViewController * groupMemVC = [[GroupNumberDetailsViewController alloc]init];
    groupMemVC.dataArr = self.groupMemberArr;
    [self.navigationController pushViewController:groupMemVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)quitGameRoom:(QuitGroupBlock)block
{
    self.myBlock = [block copy];
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
