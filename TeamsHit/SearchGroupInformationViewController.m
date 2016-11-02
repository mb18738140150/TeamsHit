//
//  SearchGroupInformationViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SearchGroupInformationViewController.h"
#import "TeamHitCollectionView.h"
#import "BragGameChatViewController.h"

#import "PublishCollectionViewCell.h"
#define kGroupInfoCellID @"GroupInfoCellID"
@interface SearchGroupInformationViewController ()
{
    MBProgressHUD* hud ;
    RCDGroupInfo * userInfo;
}
@property (strong, nonatomic) IBOutlet UIImageView *groupIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *groupLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupIntroLabel;

@property (strong, nonatomic) IBOutlet UIView *colectionViewBackView;

@property (strong, nonatomic) IBOutlet UICollectionView *groupmembers;
@property (strong, nonatomic) IBOutlet UILabel *groupNumber;
@property (strong, nonatomic) IBOutlet UILabel *groupTypeLabel;

@property (strong, nonatomic) IBOutlet UIButton *applyJoinIngroupBT;

@property (nonatomic, assign)int GroupType;
@property (nonatomic, strong)TeamHitCollectionView *teamCollectionView;

@property (nonatomic, assign)BOOL isGroupMember;
@property (nonatomic, strong)NSMutableArray * dateSourceArray;
@end

@implementation SearchGroupInformationViewController

- (NSMutableArray *)dateSourceArray
{
    if (!_dateSourceArray) {
        _dateSourceArray = [NSMutableArray array];
    }
    return _dateSourceArray;
}

- (void)viewDidLayoutSubviews
{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((screenWidth - 64) / 5, (screenWidth - 64) / 5 + 16);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    // item之间最小间距
    layout.minimumInteritemSpacing = 8;
    // item最小行间距
    layout.minimumLineSpacing = 10;
    // 集合视图滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.groupmembers.backgroundColor = [UIColor whiteColor];
    self.groupmembers.collectionViewLayout = layout;
     [self.groupmembers registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:kGroupInfoCellID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RCDGroupInfo * rcGroupInfo = [[RCDataBaseManager shareInstance]getGroupByGroupId:self.groupid];;
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:rcGroupInfo.groupName];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
     [self loadGroupData];
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)loadGroupData
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"GroupId":@(self.groupid.intValue)
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
    userInfo = [[RCDGroupInfo alloc]init];
    userInfo.groupId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"GroupId"]];
    userInfo.groupName = [dic objectForKey:@"GroupName"];
    userInfo.portraitUri = [dic objectForKey:@"PortraitUri"];
    userInfo.number = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Number"]];
    userInfo.maxNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"MaxNumber"]];
    userInfo.introduce = [dic objectForKey:@"Introduce"];
    userInfo.creatorId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CreatorId"]];
//    self.groupManagerID = userInfo.creatorId;
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
    

    [self.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    self.groupNumber.text = [NSString stringWithFormat:@"全部房间成员（%@）", userInfo.number];
    self.groupLabel.text = userInfo.groupName;
    self.groupLabel.text = userInfo.groupId;
    self.GroupType = [[dic objectForKey:@"GroupType"] intValue];
    if (self.GroupType == 1) {
        self.groupTypeLabel.text = @"吹牛";
    }else
    {
        self.groupTypeLabel.text = @"21点";
    }
//    self.groupMumberlabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"GamePeople"]];
//    self.minCoinNumberLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"LeastCoins"]];
    NSArray * groupMenberInfoarr = [dic objectForKey:@"FriendList"];
    
    for (int i = 0; i < groupMenberInfoarr.count; i++) {
        NSDictionary * userDic = [groupMenberInfoarr objectAtIndex:i];
        RCUserInfo * user = [[RCUserInfo alloc]init];
        user.userId = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"UserId"]];
        user.name = [userDic objectForKey:@"DisplayName"];
        user.portraitUri = [userDic objectForKey:@"PortraitUri"];
        
        if (i < 4) {
            [self.dateSourceArray addObject:user];
        }
        
    }
    [self.groupmembers reloadData];
//    [self.teamCollectionView reloadDataAction];
    
    NSArray * groupArr = [[RCDataBaseManager shareInstance] getAllGroup];
    for (RCDGroupInfo * groupInfo in groupArr) {
        if ([groupInfo.groupId isEqualToString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"GroupId"]]]) {
            self.isGroupMember = YES;
            break;
        }
    }
    if (self.isGroupMember) {
        [self.applyJoinIngroupBT setTitle:@"发起会话" forState:UIControlStateNormal];
    }else
    {
        [self.applyJoinIngroupBT setTitle:@"申请加入房间" forState:UIControlStateNormal];
    }
    
}
- (IBAction)applyJoinInBT:(id)sender {
    if ([((UIButton *)sender).titleLabel.text isEqualToString:@"申请加入房间"]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupid.intValue),
                                   @"GroupName":userInfo.groupName
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@groups/joinGroup?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        [[RCDataBaseManager shareInstance] insertGroupToDB:userInfo];
                    });
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
    }else
    {
        NSLog(@"发起会话");
        
        BragGameChatViewController * conversationVC = [[BragGameChatViewController alloc]init];
        conversationVC.conversationType = ConversationType_GROUP;
        conversationVC.targetId = userInfo.groupId;
        //    _conversationVC.userName = group.groupName;
        conversationVC.title = userInfo.groupName;
        //    _conversationVC.conversation = model;
        //    _conversationVC.unReadMessage = model.unreadMessageCount;
        conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        conversationVC.enableUnreadMessageIcon=YES;
        conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
        
    }
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dateSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接重用cell，不用创建，因为仓库里没有cell的话，collectionView会自己创建该wifeCell,不用我们管（更深层次的原因是，我们已经把wifeCell注册给collectionView了，所以collectionView会自己完成cell的创建工作）
    PublishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGroupInfoCellID forIndexPath:indexPath];
    
        RCUserInfo * user = [self.dateSourceArray objectAtIndex:indexPath.row];
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"logo(1)"]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
