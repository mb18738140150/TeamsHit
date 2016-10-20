//
//  FriendCircleMessgaeViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FriendCircleMessgaeViewController.h"
#import "FriendCircleMessgaeCell.h"
#import "FriendCircleMessgaeModel.h"

@interface FriendCircleMessgaeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSNumber * MessageId;
@property (nonatomic, strong)NSNumber * allCount;
@property (nonatomic, assign)int page;

@property (nonatomic, copy)NoreadBlock myBlock;

@end

@implementation FriendCircleMessgaeViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"新评论列表"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"title_right_icon"] title:@"清空"];
    [rightBarItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    
    _page = 0;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height - 64) style:UITableViewStylePlain];
    [self.tableView registerClass:[FriendCircleMessgaeCell class] forCellReuseIdentifier:KFriendCircleMessgaeCellIdentifire];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)backAction:(UIButton *)button
{
    if (self.myBlock) {
        self.myBlock();
    }
    self.allMessage = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)publishAction:(UIButton *)button
{
    NSLog(@"删除");
    
    NSString * url = [NSString stringWithFormat:@"%@news/deleteFriendCircleMessage?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak FriendCircleMessgaeViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:nil progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"清空成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)loadData
{
    NSNumber * curpage;
    NSNumber * isgetall;
    if (self.allMessage) {
        _page++;
        curpage = @(_page);
        isgetall = @1;
    }else
    {
        isgetall = @0;
        curpage = @0;
    }
    
    NSDictionary * jsonDic = @{
                               @"CurPage":curpage,
                               @"CurCount":@10,
                               @"MessageId":@0,
                               @"IsGetAll":isgetall
                               };
     NSLog(@"%@", [jsonDic description]);
    NSString * url = [NSString stringWithFormat:@"%@news/getFriendCircleMessage?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak FriendCircleMessgaeViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                wxVC.allCount = [responseObject objectForKey:@"AllCount"];
                wxVC.MessageId = [responseObject objectForKey:@"MessageId"];
                NSArray * FirendCircleList = [NSArray array];
                FirendCircleList = [responseObject objectForKey:@"FriendCircleMessageList"];
                [wxVC getdataWithArray:FirendCircleList];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCircleMessgaeCell * cell = [tableView dequeueReusableCellWithIdentifier:KFriendCircleMessgaeCellIdentifire forIndexPath:indexPath];
    [cell creatcellUIwith:tableView.bounds];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCircleMessgaeModel * model = [_dataArray objectAtIndex:indexPath.row];
    
    if (model.IsFavoriteAndComenmt.intValue == 1) {
        return 103;
    }else
    {
        return 103 - 15 + model.commentHeight;
    }
}

- (void)loadMoreData
{
    
    if (_dataArray.count >= _allCount.intValue) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSNumber * isgetall;
    if (self.allMessage) {
        isgetall = @1;
    }else
    {
        isgetall = @0;
    }
    _page++;
    NSNumber * page = @(_page);
    
    NSDictionary * jsonDic = @{
                               @"CurPage":page,
                               @"CurCount":@10,
                               @"MessageId":self.MessageId,
                               @"IsGetAll":isgetall
                               };
    NSLog(@"%@", [jsonDic description]);
    NSString * url = [NSString stringWithFormat:@"%@news/getFriendCircleMessage?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak FriendCircleMessgaeViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [_tableView.mj_footer endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            self.MessageId = [responseObject objectForKey:@"MessageId"];
            NSArray * FirendCircleList = [NSArray array];
            FirendCircleList = [responseObject objectForKey:@"FriendCircleMessageList"];
            if (FirendCircleList.count > 0) {
                [wxVC getdataWithArray:FirendCircleList];
            }else
            {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [_tableView.mj_footer endRefreshing];
    }];
}
- (void)getdataWithArray:(NSArray *)array
{
    for (NSDictionary * dic in array) {
        FriendCircleMessgaeModel * model = [[FriendCircleMessgaeModel alloc]initWithDictionary:dic];
        [model calculatecommentHeight];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)noreadAction:(NoreadBlock)block
{
    self.myBlock = [block copy];
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
