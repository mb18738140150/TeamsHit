//
//  GroupNumberDetailsViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GroupNumberDetailsViewController.h"
#import "GroupMemberDetailsTableViewCell.h"
#import "FriendInformationViewController.h"
#import "MeDetailInfomationViewController.h"
#define CELL_ID @"cellId"

@interface GroupNumberDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *memberTableView;

@end

@implementation GroupNumberDetailsViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.title = @"房间成员";
    
    self.memberTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, self.view.hd_height) style:UITableViewStylePlain];
    self.memberTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.memberTableView.delegate = self;
    self.memberTableView.dataSource = self;
    [self.memberTableView registerNib:[UINib nibWithNibName:@"GroupMemberDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.memberTableView setTableFooterView:v];
    
    [self.view addSubview:self.memberTableView];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupMemberDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    RCUserInfo * user = _dataArr[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"meIcon_default"]];
    
    cell.nickName.text = user.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     if (user.userId.intValue == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
         cell.meLabel.hidden = NO;
     }else
     {
         cell.meLabel.hidden = YES;
     }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCUserInfo * user = _dataArr[indexPath.row];
    
    if (user.userId.intValue == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
        MeDetailInfomationViewController * meinfoVC = [[MeDetailInfomationViewController alloc]initWithNibName:@"MeDetailInfomationViewController" bundle:nil];
        meinfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:meinfoVC animated:YES];
    }else
    {
        FriendInformationViewController * friend = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
        friend.targetId = user.userId;
        [self.navigationController pushViewController:friend animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
