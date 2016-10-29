//
//  FriendDetailDataSettingViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FriendDetailDataSettingViewController.h"
#import "AppDelegate.h"
#import "ChangeEquipmentNameView.h"
#import "FriendInformationModel.h"

@interface FriendDetailDataSettingViewController ()<TipViewDelegate, UITextFieldDelegate>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UILabel *displaNameLabel;

@property (strong, nonatomic) IBOutlet UIView *remaekView;
@property (strong, nonatomic) IBOutlet UIButton *forbidLookFriendCircleBT;// 1、让他看我的朋友圈 2、不让他看我的朋友
@property (strong, nonatomic) IBOutlet UIButton *noLookHisFriendCircleBT;// 1、看他的朋友圈 2、不看他的朋友圈
@property (strong, nonatomic) IBOutlet UIButton *blackListBT;
// 修改昵称
@property (nonatomic, strong)ChangeEquipmentNameView  * changeNameView;
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;

@property (nonatomic,strong) RCUserInfo *userInfo;

@end

@implementation FriendDetailDataSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.title = @"资料设置";
    
    [self.forbidLookFriendCircleBT setImage:[[UIImage imageNamed:@"forbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.forbidLookFriendCircleBT setImage:[[UIImage imageNamed:@"noForbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.noLookHisFriendCircleBT setImage:[[UIImage imageNamed:@"forbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.noLookHisFriendCircleBT setImage:[[UIImage imageNamed:@"noForbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.blackListBT setImage:[[UIImage imageNamed:@"forbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.blackListBT setImage:[[UIImage imageNamed:@"noForbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UITapGestureRecognizer * remarkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNickName)];
    [self.remaekView addGestureRecognizer:remarkTap];
    
    self.userInfo = [RCUserInfo new];
    self.userInfo.userId = [NSString stringWithFormat:@"%@", self.model.userId];
    self.userInfo.portraitUri = self.model.iconUrl;
    self.userInfo.name = self.model.nickName;
    
    if (self.model.displayName.length != 0) {
        self.displayNameLabel.text = self.model.displayName;
    }else
    {
        self.displayNameLabel.text = self.model.nickName;
    }
    
    __weak FriendDetailDataSettingViewController *weakSelf = self;
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:[NSString stringWithFormat:@"%@", self.model.userId] success:^(int bizStatus) {
        weakSelf.blackListBT.selected = (bizStatus == 0);
        
    } error:^(RCErrorCode status) {
        NSArray *array = [[RCDataBaseManager shareInstance] getBlackList];
        for (RCUserInfo *blackInfo in array) {
            if ([blackInfo.userId isEqualToString: [NSString stringWithFormat:@"%@", self.model.userId]]) {
                weakSelf.blackListBT.selected = YES;
            }
        }
    }];
    
    [self getpermission];
    
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

- (void)getpermission
{
    NSDictionary * dic = @{@"TargetId":self.model.userId};
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    __weak FriendDetailDataSettingViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking]getPermission:dic success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSNumber * targetPermission = [responseObject objectForKey:@"TargetPermission"];
            NSNumber * userPermission = [responseObject objectForKey:@"UserPermission"];
            if (targetPermission.intValue == 2) {
                weakSelf.forbidLookFriendCircleBT.selected = YES;
            }else
            {
                weakSelf.forbidLookFriendCircleBT.selected = NO;
            }
            if (userPermission.intValue == 2) {
                weakSelf.noLookHisFriendCircleBT.selected = YES;
            }else
            {
                weakSelf.noLookHisFriendCircleBT.selected = NO;
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }];
}

#pragma mark - 修改备注
- (void)changeNickName
{
    if (self.changeNameView) {
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:self.changeNameView];
        self.changeNameView.alpha = 0;
        
        self.changeNameView.equipmentNameTF.returnKeyType = UIReturnKeyDone;
        [UIView animateWithDuration:.3 animations:^{
            self.changeNameView.alpha = 1;
        }];
    }else
    {
        NSArray * nibarr = [[NSBundle mainBundle]loadNibNamed:@"ChangeEquipmentNameView" owner:self options:nil];
        self.changeNameView = [nibarr objectAtIndex:0];
        CGRect tmpFrame = [[UIScreen mainScreen] bounds];
        self.changeNameView.frame = tmpFrame;
        self.changeNameView.equipmentNameTF.returnKeyType = UIReturnKeyDone;
        self.changeNameView.equipmentNameTF.delegate = self;
        self.changeNameView.title = @"备注";
        self.changeNameView.titleLabel.text = @"修改备注";
        self.changeNameView.equipmentNameTF.placeholder = @"请输入备注";
        self.changeNameView.equipmentNameTF.text = self.displayNameLabel.text;
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        [delegate.window addSubview:self.changeNameView];
        self.changeNameView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.changeNameView.alpha = 1;
        }];
        __weak FriendDetailDataSettingViewController * fVC = self;
        [self.changeNameView getEquipmentOption:^(NSString *name) {
            NSLog(@"name = %@", name);
            [fVC.changeNameView removeFromSuperview];
            [fVC setFriendDisplayName:name];
            
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setFriendDisplayName:(NSString *)name
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"设置中...";
    [hud show:YES];
    
    NSDictionary * dic = @{
                           @"TargetId":self.model.userId,
                           @"DisplayName":name
                           };
    
    [[HDNetworking sharedHDNetworking]setFriendDisplayName:dic success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设置成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            self.displayNameLabel.text = name;
            
            RCDUserInfo *user = [[RCDataBaseManager shareInstance]getFriendInfo:[NSString stringWithFormat:@"%@", self.model.userId]];
            user.displayName = name;
            [[RCDataBaseManager shareInstance]insertFriendToDB:user];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"renameFriendName" object:nil userInfo:@{@"displayName":name}];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
         [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }];
}

#pragma mark - 黑名单
- (IBAction)blacklistAction:(id)sender {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak FriendDetailDataSettingViewController *weakSelf = self;
    if (self.blackListBT.selected) {
        NSLog(@"移除黑名单");
        hud.labelText = @"正在从黑名单移除";
        [hud show:YES];
        [[RCIMClient sharedRCIMClient]removeFromBlacklist:[NSString stringWithFormat:@"%@", self.model.userId] success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
            [[RCDataBaseManager shareInstance]removeBlackList:weakSelf.userInfo.userId];
            self.blackListBT.selected = NO;
        } error:^(RCErrorCode status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"从黑名单移除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil
                                          , nil];
                [alertView show];
            });
            self.blackListBT.selected = YES;
        }];
    }else
    {
        NSLog(@"添加黑名单");
        hud.labelText = @"正在加入黑名单";
        [hud show:YES];
        [[RCIMClient sharedRCIMClient] addToBlacklist:self.userInfo.userId success:^{
            weakSelf.blackListBT.selected = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
            [[RCDataBaseManager shareInstance] insertBlackListToDB:weakSelf.userInfo];
            
        } error:^(RCErrorCode status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"加入黑名单失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil
                                          , nil];
                [alertView show];
            });
           
            weakSelf.blackListBT.selected = NO;
        }];
    }
    
}

#pragma mark - 删除好友
- (IBAction)deleteFriend:(id)sender {
    
    TipView * tipView = [[TipView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"删除联系人" message:[NSString stringWithFormat:@"将联系人%@删除，将同时删除与该联系人的聊天记录", self.model.displayName] delete:YES];
    tipView.delegate = self;
    [tipView show];
}

- (void)complete
{
    NSDictionary * jsonDic = @{
                               @"TargetId":[NSString stringWithFormat:@"%@", self.model.userId],
                               @"LeaveMsg":@"",
                               @"ApplyId":@0,
                               @"Type":@5
                               };
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发送请求中...";
    [hud show:YES];
    NSString * url = [NSString stringWithFormat:@"%@userinfo/operationFriend?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak FriendDetailDataSettingViewController * verifyVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            // 删除聊天记录并从聊天列表中删除
            [[RCIMClient sharedRCIMClient]deleteMessages:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%@", self.model.userId] success:^{
                ;
            } error:^(RCErrorCode status) {
                ;
            }];
            
            [[RCIMClient sharedRCIMClient]removeConversation:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%@", self.model.userId]];
            
            // 更新好友列表
            NSString * url = [NSString stringWithFormat:@"%@userinfo/getFriendList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
            [RCDDataSource syncFriendList:url complete:^(NSMutableArray *friends) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteFriend" object:nil];
            }];
            
            [verifyVC.navigationController popToRootViewControllerAnimated:YES];
            
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

- (IBAction)forbidLookFriendCircleAction:(id)sender {
    NSDictionary * dic = [NSDictionary dictionary];
    if (self.forbidLookFriendCircleBT.selected) {
        dic = @{
                @"TargetId":self.model.userId,
                @"Permission":@1
                };
    }else{
        dic = @{
                @"TargetId":self.model.userId,
                @"Permission":@2
                };
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"设置中...";
    [hud show:YES];
    [[HDNetworking sharedHDNetworking]setTargetPermission:dic success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设置成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            self.forbidLookFriendCircleBT.selected = !self.forbidLookFriendCircleBT.selected;
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }];
    
}

- (IBAction)notLookFriendCircleAction:(id)sender {
    
    NSDictionary * dic = [NSDictionary dictionary];
    if (self.noLookHisFriendCircleBT.selected) {
        dic = @{
                @"TargetId":self.model.userId,
                @"Permission":@1
                };
    }else{
        dic = @{
                @"TargetId":self.model.userId,
                @"Permission":@2
                };
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"设置中...";
    [hud show:YES];
    [[HDNetworking sharedHDNetworking]setUserPermission:dic success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设置成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            self.noLookHisFriendCircleBT.selected = !self.noLookHisFriendCircleBT.selected;
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }];
}

- (IBAction)tousu:(id)sender {
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/report?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:[NSDictionary dictionary] progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"感谢举报，我们会尽快查实并进行处理!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
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
