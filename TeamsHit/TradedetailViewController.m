//
//  TradedetailViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TradedetailViewController.h"
#import "TradeDetailTableViewCell.h"
#import "TransactiondetailsModel.h"

#define CELL_ID @"TradeDetailTableViewCell"
@interface TradedetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray * datasourceArr;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * allCount;
@end

@implementation TradedetailViewController
- (NSMutableArray *)datasourceArr
{
    if (!_datasourceArr) {
        _datasourceArr = [NSMutableArray array];
    }
    return _datasourceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"交易明细";
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height - 64) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableview.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    [self.tableview registerNib:[UINib nibWithNibName:@"TradeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableview.mj_header beginRefreshing];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNewData
{
    _page = 1;
    _tableview.mj_footer.state = MJRefreshStateIdle;
    NSDictionary * jsonDic = @{
                               @"Page":@1,
                               @"Count":@10
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@coins/getTeamCoinsDetail?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak TradedetailViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [_tableview.mj_header endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        
            if (code == 200) {
                
                _allCount = [responseObject objectForKey:@"AllCount"];
                
                if (wxVC.datasourceArr.count > 0) {
                    [wxVC.datasourceArr removeAllObjects];
                }
                
                NSArray * RechargeRecordList = [NSArray array];
                RechargeRecordList = [responseObject objectForKey:@"TeamCoinDetailList"];
                for (NSDictionary * dic in RechargeRecordList) {
                    TransactiondetailsModel * model = [[TransactiondetailsModel alloc]initWithDic:dic];
                    [wxVC.datasourceArr addObject:model];
                }
                [wxVC.tableview reloadData];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [_tableview.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData
{
    
    if (_datasourceArr.count >= _allCount.intValue) {
        [_tableview.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    _page++;
    
    NSNumber * page = @(_page);
    
    NSDictionary * jsonDic = @{
                               @"Page":page,
                               @"Count":@10
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@coins/getTeamCoinsDetail?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak TradedetailViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [_tableview.mj_footer endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                NSArray * RechargeRecordList = [NSArray array];
                RechargeRecordList = [responseObject objectForKey:@"TeamCoinDetailList"];
                if (RechargeRecordList.count > 0) {
                    for (NSDictionary * dic in RechargeRecordList) {
                        TransactiondetailsModel * model = [[TransactiondetailsModel alloc]initWithDic:dic];
                        [wxVC.datasourceArr addObject:model];
                    }
                    [wxVC.tableview reloadData];
                }else
                {
                    [_tableview.mj_footer endRefreshingWithNoMoreData];
                }
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [_tableview.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    cell.model = self.datasourceArr[indexPath.row];
    [cell creatButtomLine];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
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
