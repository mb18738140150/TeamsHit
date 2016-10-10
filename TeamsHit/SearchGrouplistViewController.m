//
//  SearchGrouplistViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SearchGrouplistViewController.h"
#import "SearcgGroupListCell.h"
#import "SearchGroupListModel.h"
#import "SearchGroupInformationViewController.h"
#import "GroupDetailViewController.h"
#define CELL_IDENTIFIRE @"searchGroupCellIdentifire"

@interface SearchGrouplistViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * groupTableView;

@end

@implementation SearchGrouplistViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.groupInfoArr = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"查找结果"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 17, self.view.hd_width, self.view.hd_height - 64 - 17) style:UITableViewStylePlain];
    self.groupTableView.delegate = self;
    self.groupTableView.dataSource = self;
    [self.groupTableView registerNib:[UINib nibWithNibName:@"SearcgGroupListCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIRE];
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.groupTableView];
    self.groupTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    // Do any additional setup after loading the view.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupInfoArr.count;
//    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearcgGroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIRE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImageView.layer.masksToBounds = YES;
    
    SearchGroupListModel * model = self.groupInfoArr[indexPath.row];
    RCDGroupInfo * groupModel = [[RCDGroupInfo alloc]init];
    groupModel.portraitUri = model.groupIconUrl;
    groupModel.groupName = model.GroupName;
    groupModel.groupId = [NSString stringWithFormat:@"%@", model.GroupId];
    groupModel.introduce = model.groupIntro;
    cell.model = groupModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        SearchGroupListModel * model = self.groupInfoArr[indexPath.row];
    SearcgGroupListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    SearchGroupInformationViewController * groupinfoVC = [[SearchGroupInformationViewController alloc]initWithNibName:@"SearchGroupInformationViewController" bundle:nil];
    groupinfoVC.groupid = [NSString stringWithFormat:@"%@", model.GroupId];
    [self.navigationController pushViewController:groupinfoVC animated:YES];
    
    
//    GroupDetailViewController * groupDetailVC = [[GroupDetailViewController alloc]init];
//    groupDetailVC.groupID = [NSString stringWithFormat:@"%@", model.GroupId];
//    [self.navigationController pushViewController:groupDetailVC animated:YES];
    
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
