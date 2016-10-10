//
//  GroupDetailViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GroupDetailViewController.h"

#import "GroupDetailSetTipView.h"
#import "TeamHitCollectionView.h"

@interface GroupDetailViewController ()
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

@property (nonatomic, assign)int GroupType;
@property (nonatomic, assign)int VerificationType;
@property (nonatomic, assign)int minCoin;
@property (nonatomic, assign)int minGameUserCount;

@property (nonatomic, copy)NSString * groupManagerID;

@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    RCDGroupInfo * rcGroupInfo = [[RCDataBaseManager shareInstance]getGroupByGroupId:self.groupID];;
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:rcGroupInfo.groupName];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    [self.noticeBT setImage:[UIImage imageNamed:@"noForbid"] forState:UIControlStateNormal];
    [self.noticeBT setImage:[UIImage imageNamed:@"forbid"] forState:UIControlStateSelected];
    
    
    self.teamCollectionView = [[TeamHitCollectionView alloc]initWithFrame:CGRectMake(0, 9, screenWidth, (screenWidth - 64) / 5 + 16)];
    [self.groupMenberInfo addSubview:_teamCollectionView];
    self.groupManagerID = rcGroupInfo.creatorId;
    self.groupNumberLabel.text = [NSString stringWithFormat:@"全部群成员（%@）", rcGroupInfo.number];
    self.groupRoomNumberLabel.text = rcGroupInfo.groupId;
    self.groupNameLabel.text = rcGroupInfo.groupName;
    self.groupMumberlabel.text = rcGroupInfo.number;
    if (rcGroupInfo.GroupType == 1) {
        self.groupTypeLabel.text = @"吹牛";
    }else
    {
        self.groupTypeLabel.text = @"21点";
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


-(void)startLoadView
{
//    currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP
//                                                                targetId:self.groupID];
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_PRIVATE
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
    
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            [self refreshUIWith:responseObject];
            
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
    if ([[dic objectForKey:@"GroupType"] intValue] == 1) {
        userInfo.GroupType = 1;
    }else if ([[dic objectForKey:@"GroupType"] intValue] == 2)
    {
        userInfo.GroupType = 2;
    }
    if ([[dic objectForKey:@"IsDismiss"] intValue] == 1) {
        userInfo.isDismiss = @"1";
    }else
    {
        userInfo.isDismiss = @"0";
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[RCDataBaseManager shareInstance] insertGroupToDB:userInfo];
    });
    
    self.groupNumberLabel.text = [NSString stringWithFormat:@"全部群成员（%@）", userInfo.number];
    self.groupNameLabel.text = userInfo.groupName;
    self.groupRoomNumberLabel.text = userInfo.groupId;
    self.GroupType = [[dic objectForKey:@"GroupType"] intValue];
    if (self.GroupType == 1) {
        self.groupTypeLabel.text = @"吹牛";
    }else
    {
        self.groupTypeLabel.text = @"21点";
    }
    self.groupMumberlabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"GamePeople"]];
    self.minCoinNumberLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"LeastCoins"]];
    NSArray * groupMenberInfoarr = [dic objectForKey:@"FriendList"];
    
    for (int i = 0; i < groupMenberInfoarr.count; i++) {
        NSDictionary * userDic = [groupMenberInfoarr objectAtIndex:i];
        RCUserInfo * user = [[RCUserInfo alloc]init];
        user.userId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"UserId"]];
        user.name = [userDic objectForKey:@"DisplayName"];
        user.portraitUri = [userDic objectForKey:@"PortraitUri"];
        
        if (i < 4) {
            [self.teamCollectionView.dateSourceArray addObject:user];
        }
        
    }
    
    [self.teamCollectionView reloadDataAction];
}


- (IBAction)changeNameAction:(id)sender {
    
    if (![self isGroupManager]) {
        [self showNotManagerTip];
        return;
    }
    
    NSLog(@"改变群名称");
    
    
    NSArray * typeArr = [NSArray array];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"修改房间名称" content:typeArr];
    [setTipView show];
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
            self.groupNameLabel.text = string;
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
    
    NSLog(@"改变群type");
    NSArray * typeArr = @[@"吹牛", @"21点"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"游戏模式" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        if ([string isEqualToString:@"21点"]) {
            self.GroupType = 2;
        }else
        {
            self.GroupType = 1;
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
            if (self.GroupType == 2) {
                self.groupTypeLabel.text = @"21点";
            }else
            {
                self.groupTypeLabel.text = @"吹牛";
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
- (IBAction)lookRuleAction:(id)sender {
    NSLog(@"查看规则");
    
    NSArray * typeArr = @[@"轮流叫出不超过桌面上所有骰子的个数。", @"当你认为上家加的点数太大时，就开 TA吧！", @"一点可以当其他使用，但如果有人叫 了一点后，就变成一个普通点了。"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"吹牛游戏规则" content:typeArr isRule:YES];
    [setTipView show];
    
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
    NSLog(@"消息免打扰");
//    UIButton * button = (UIButton *)sender;
//    button.selected = !button.selected;
    
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE
                                                            targetId:self.groupID
                                                           isBlocked:!self.noticeBT.selected
                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                 NSLog(@"设置消息免打扰成功");
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
    NSLog(@"退出群组");
    NSArray * typeArr = @[@"确定退出群组？"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"退出群组" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   };
        
        [[HDNetworking sharedHDNetworking]quitGroup:jsonDic success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
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
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"群组验证" content:typeArr];
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
    NSLog(@"改变碰碰币");
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
                                   };;
        
        [[HDNetworking sharedHDNetworking]modifyGroupLeastCoins:jsonDic success:^(id  _Nonnull responseObject) {
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
