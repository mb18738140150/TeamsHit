//
//  PrintHistoryViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/10.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "PrintHistoryViewController.h"

#import "PrintOrderModel.h"

#import "OrderPrintTableViewCell.h"
#define ORDERPRINTCELLID @"OrderPrintTableViewCellid"

@interface PrintHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArr;
@property (nonatomic, assign)int allCount;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)UIView * bottomView;

@property (nonatomic, strong)NSMutableArray * selectArr;

@end

@implementation PrintHistoryViewController

- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"订单打印记录"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
//    self.title = @"授权登录";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithTitle:@"打印" backgroundcolor:UIColorFromRGB(0x12B7F5) cornerRadio:3];
    [rightBarItem addTarget:self action:@selector(printAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, screenHeight - 64 - 47) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderPrintTableViewCell" bundle:nil] forCellReuseIdentifier:ORDERPRINTCELLID];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.tableView.tableHeaderView = [self getHeadView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    self.allCount = 0;
    
    [self prepareBottomView];
    [self.tableView.mj_header beginRefreshing];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headRefresh
{
    NSLog(@"头部刷新");
    __weak PrintHistoryViewController * weakSelf = self;
    self.page = 1;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    NSDictionary * jsonDic = @{
                               @"CurPage":@(self.page),
                               @"CurCount":@10,
                               @"AccountNumber":@(self.accountNumber)
                               };
    NSString * url = [NSString stringWithFormat:@"%@takeout/OrderPrintHistory?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    }  success:^(id  _Nonnull responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"Code"] intValue] == 200) {
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf.allCount = [[responseObject objectForKey:@"AllCount"] intValue];
            NSArray * orderList = [responseObject objectForKey:@"PrintOrderList"];
            [weakSelf.dataArr removeAllObjects];
            
            for (NSDictionary * dic in orderList) {
                PrintOrderModel * model = [[PrintOrderModel alloc]initWithDic:dic];
                model.printOrderType = Print_Nomal;
                
                [weakSelf.dataArr addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
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
    
    [self cancelPrint];
}

- (void)footRefresh
{
    NSLog(@"底部刷新");
    
    if (self.dataArr.count < self.allCount) {
        __weak PrintHistoryViewController * weakSelf = self;
        self.page++;
        NSDictionary * jsonDic = @{
                                   @"CurPage":@(self.page),
                                   @"CurCount":@10,
                                   @"AccountNumber":@(self.accountNumber)
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@takeout/OrderPrintHistory?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        }  success:^(id  _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            
            if ([[responseObject objectForKey:@"Code"] intValue] == 200) {
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.allCount = [[responseObject objectForKey:@"AllCount"] intValue];
                NSArray * orderList = [responseObject objectForKey:@"PrintOrderList"];
                
                for (NSDictionary * dic in orderList) {
                    PrintOrderModel * model = [[PrintOrderModel alloc]initWithDic:dic];
                    model.printOrderType = Print_Nomal;
                    
                    [weakSelf.dataArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
            
            
        } failure:^(NSError * _Nonnull error) {
            [weakSelf.tableView.mj_header endRefreshing];
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
        
        [self cancelPrint];
    }else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPrintTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ORDERPRINTCELLID forIndexPath:indexPath];
    
    PrintOrderModel * model = self.dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrintOrderModel * model = self.dataArr[indexPath.row];
    if (model.printOrderType) {
        if (model.printOrderType == Print_NOSelect) {
            model.printOrderType = Print_Select;
            [self.selectArr addObject:model];
        }else
        {
            model.printOrderType = Print_NOSelect;
            [self.selectArr removeObject:model];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UIView *)getHeadView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
    view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, screenWidth, 15)];
    tipLB.text = @"小提示:打印记录只可以查询今天的打印记录";
    tipLB.textAlignment = 1;
    tipLB.font = [UIFont systemFontOfSize:13];
    tipLB.textColor = UIColorFromRGB(0x999999);
    [view addSubview:tipLB];
    
    return view;
}


- (void)printAction:(UIButton *)button
{
    TeamHitBarButtonItem * rightBarItem = self.navigationItem.rightBarButtonItem.customView;
    if ([rightBarItem.titleLabel.text isEqualToString:@"打印"]) {
        
        [rightBarItem setTitle:@"确定" forState:UIControlStateNormal];
        [self startSelect];
        for (PrintOrderModel * model in self.dataArr) {
            model.printOrderType = Print_NOSelect;
        }
        [self.tableView reloadData];
    }else if ([rightBarItem.titleLabel.text isEqualToString:@"确定"])
    {
        if (self.selectArr.count == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"打印订单不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        [rightBarItem setTitle:@"打印" forState:UIControlStateNormal];
        
        [self printOrder:[self.selectArr copy]];
        
        for (PrintOrderModel * model in self.dataArr) {
            model.printOrderType = Print_Nomal;
        }
        [self.tableView reloadData];
        [self cancelPrint];
    }
    
}

- (void)prepareBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.hd_height, screenWidth, 47)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    UIButton * cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBT.frame = CGRectMake(60, 15, 40, 20);
    [cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:cancelBT];
    
    UIButton * allselectBT = [UIButton buttonWithType:UIButtonTypeCustom];
    allselectBT.frame = CGRectMake(screenWidth - 100, 15, 40, 20);
    [allselectBT setTitle:@"全选" forState:UIControlStateNormal];
    [allselectBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:allselectBT];
    
    [cancelBT addTarget:self action:@selector(cancelSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [allselectBT addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelSelectAction:(UIButton *)sender
{
    [self cancelPrint];
    for (PrintOrderModel * model in self.dataArr) {
        model.printOrderType = Print_Nomal;
    }
    [self.tableView reloadData];
}

- (void)allSelectAction:(UIButton *)sender
{
    [self.selectArr removeAllObjects];
    for (PrintOrderModel * model in self.dataArr) {
        model.printOrderType = Print_Select;
        [self.selectArr addObject:model];
    }
    [self.tableView reloadData];
}

- (void)startSelect
{
    [UIView animateWithDuration:.3 animations:^{
        self.bottomView.frame = CGRectMake(0, self.view.hd_height - 47, screenWidth, 47);
    } completion:^(BOOL finished) {
        self.tableView.hd_height = screenHeight - 64 - 47;
    }];
}

- (void)cancelPrint
{
    [self.selectArr removeAllObjects];
    self.bottomView.frame = CGRectMake(0, self.view.hd_height, screenWidth, 47);

    self.tableView.hd_height = screenHeight - 64;
    TeamHitBarButtonItem * rightBarItem = self.navigationItem.rightBarButtonItem.customView;
    [rightBarItem setTitle:@"打印" forState:UIControlStateNormal];
}

#pragma mark - printOrder
- (void)printOrder:(NSArray *)arr
{
    NSString * taskNumber = @"";
    for (PrintOrderModel * model in arr) {
        taskNumber = [taskNumber stringByAppendingFormat:@"%ld,", model.taskNumber];
    }
    taskNumber = [taskNumber substringToIndex:taskNumber.length - 1];
    NSLog(@"%@", taskNumber);
    __weak PrintHistoryViewController * weakSelf = self;
    NSDictionary * jsonDic = @{
                               @"TaskNumber":taskNumber,
                               @"AccountNumber":@(self.accountNumber)
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@takeout/PrintOrder?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    }  success:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"Code"] intValue] == 200) {
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
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
    
    [self cancelPrint];
    
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
