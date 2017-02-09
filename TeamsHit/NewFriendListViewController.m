//
//  NewFriendListViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "NewFriendListViewController.h"
#import "NewFriendListTableViewCell.h"
#import "NewFriendModel.h"
#import "FriendInformationViewController.h"
#import "ChatViewController.h"

//#import "NewFriendVerifyViewController.h"

#define CELL_IDENTIFIRE @"cellId"

@interface NewFriendListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UITableView *friendtableview;
@property (nonatomic, strong)NSMutableArray * newfriendListArray;
@end

@implementation NewFriendListViewController

- (NSMutableArray *)newfriendListArray
{
    if (!_newfriendListArray) {
        _newfriendListArray = [NSMutableArray array];
    }
    return _newfriendListArray;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
            }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"新的朋友";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.friendtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.friendtableview registerClass:[NewFriendListTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIRE];
    

    [self getFriendlistData];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getFriendlistData
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    NSString * url = [NSString stringWithFormat:@"%@userinfo/getNewFriendList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak NewFriendListViewController * newFVC = self;
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSArray * nfList = [responseObject objectForKey:@"NewFriendList"];
            for (NSDictionary * dic in nfList) {
                NewFriendModel * model = [[NewFriendModel alloc]initWithDictionary:dic];
                [newFVC.newfriendListArray addObject:model];
            }
            [newFVC.friendtableview reloadData];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
       NSLog(@"%@", error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newfriendListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIRE forIndexPath:indexPath];
    
    [cell createSubView:tableView.bounds];
    NewFriendModel * model = self.newfriendListArray[indexPath.row];
    cell.nFriendModel = model;
    
    __weak NewFriendListViewController * newFriendVC = self;
    [cell acceptRequest:^{
        [newFriendVC acceptRequestWith:model atIndexPath:indexPath];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NewFriendVerifyViewController * newfriendVerifyVC = [[NewFriendVerifyViewController alloc]initWithNibName:@"NewFriendVerifyViewController" bundle:nil];
//    [self.navigationController pushViewController:newfriendVerifyVC animated:YES];
    
    FriendInformationViewController * vc = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
    NewFriendModel * model = self.newfriendListArray[indexPath.row];
    vc.targetId = [NSString stringWithFormat:@"%@", model.userId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)acceptRequestWith:(NewFriendModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * jsonDic = @{
                               @"TargetId":model.userId,
                               @"LeaveMsg":@"",
                               @"ApplyId":model.applyId,
                               @"Type":@2,
                               @"IsPhoneNumber":@2
                               };
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"处理中...";
    [hud show:YES];
    NSString * url = [NSString stringWithFormat:@"%@userinfo/operationFriend?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak NewFriendListViewController * newFriendVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            model.status = @1;
            [newFriendVC.friendtableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            ChatViewController * chatVc = [[ChatViewController alloc]init];
            chatVc.hidesBottomBarWhenPushed = YES;
            chatVc.conversationType = ConversationType_PRIVATE;
            chatVc.displayUserNameInCell = NO;
            chatVc.targetId = [NSString stringWithFormat:@"%@", model.userId];
            chatVc.title = model.nickname;
            chatVc.enableNewComingMessageIcon=YES;//开启消息提醒
            chatVc.enableUnreadMessageIcon=YES;
            chatVc.needPopToRootView = YES;
            [self.navigationController pushViewController:chatVc animated:YES];
            NSString * url = [NSString stringWithFormat:@"%@userinfo/getFriendList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
            [RCDDataSource syncFriendList:url complete:^(NSMutableArray * result) {
            
            }];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"%@", error);
    }];
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
