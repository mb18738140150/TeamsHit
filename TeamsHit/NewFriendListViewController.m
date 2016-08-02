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
#import "NewFriendVerifyViewController.h"

#define CELL_IDENTIFIRE @"cellId"

@interface NewFriendListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *friendtableview;
@property (nonatomic, strong)NSMutableArray * newfriendLiatArray;
@end

@implementation NewFriendListViewController

- (NSMutableArray *)newfriendLiatArray
{
    if (!_newfriendLiatArray) {
        _newfriendLiatArray = [NSMutableArray array];
    }
    return _newfriendLiatArray;
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
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"新的朋友"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.friendtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.friendtableview registerClass:[NewFriendListTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIRE];
    for (int i = 0; i< 4; i++) {
        NewFriendModel * model = [[NewFriendModel alloc]init];
        model.iconImageUrl = @"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=%E5%9B%BE%E7%89%87&pn=1&spn=0&di=125546894330&pi=&rn=1&tn=baiduimagedetail&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1003704465%2C1400426357&os=4246966059%2C4277404619&simid=4210997991%2C798394471&adpicid=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic25.nipic.com%2F20121112%2F5955207_224247025000_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3FnAzdH3F0nAzdH3F0al8l0mhdj9v1c9n_z%26e3Bip4s&gsm=0";
        model.name = @"小马哥";
        model.detaile = @"我是小马哥呵呵哒";
        if (i == 0) {
            model.state = @1;
        }else
        {
            model.state = @0;
        }
        [self.newfriendLiatArray addObject:model];
    }

}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newfriendLiatArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIRE forIndexPath:indexPath];
    
    [cell createSubView:tableView.bounds];
    NewFriendModel * model = self.newfriendLiatArray[indexPath.row];
    cell.nFriendModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendVerifyViewController * newfriendVerifyVC = [[NewFriendVerifyViewController alloc]initWithNibName:@"NewFriendVerifyViewController" bundle:nil];
    [self.navigationController pushViewController:newfriendVerifyVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
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
