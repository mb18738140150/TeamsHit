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
#define TYPEOFGAMECELLIDENTIFIRE @"TypeofGameCell"

@interface FindViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD* hud ;
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
    for (int i = 0; i<1; i++) {
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
                model.titlelabeltext = @"21点";
                [self.typedDatesourceArr addObject:model];
                break;
                
            default:
                break;
        }
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)updateFriendCircleMessageCount:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.noreadMassageNumberLabel.hidden) {
            self.noreadMassageNumberLabel.hidden = NO;
        }
        NSLog(@"[[RCDataBaseManager shareInstance]getFriendcircleMessageNumber] = %d", [[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]);
        self.noreadMassageNumberLabel.text = [NSString stringWithFormat:@"%d", [[RCDataBaseManager shareInstance]getFriendcircleMessageNumber]];
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
    }else{
        self.noreadMassageNumberLabel.hidden = YES;
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
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请输入房间号" content:typeArr];
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
            
            [weakSelf pushgameViewWith:string];
            
            
            
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
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select");
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"GroupType":@(indexPath.row + 1)
                               };
    __weak FindViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking]randomAssignWithGroupType:jsonDic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [hud hide:YES];
        
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
    

}

- (void)pushgameViewWith:(NSString *)typeid
{
    BragGameChatViewController * conversationVC = [[BragGameChatViewController alloc]init];
    conversationVC.conversationType = ConversationType_GROUP;
    conversationVC.targetId = typeid;
    //    _conversationVC.userName = group.groupName;
//    conversationVC.title = group.groupName;
    //    _conversationVC.conversation = model;
    //    _conversationVC.unReadMessage = model.unreadMessageCount;
    conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    conversationVC.enableUnreadMessageIcon=YES;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
    // 同步组群
    [RCDDataSource syncGroups];
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
