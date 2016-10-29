//
//  UserFriendCircleViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "UserFriendCircleViewController.h"
#import "UserFrienfCircleCell.h"
#import "UserFriendCircleModel.h"
#import "FriendCircleMessgaeViewController.h"
#import "AppDelegate.h"
#import "ExchangeBackwallImageViewController.h"

#define CELLID @"UserFrienfCircleCellID"
@interface UserFriendCircleViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * mainTable;
    UIImageView * backImageView;
    UIImageView * iconImageView;
    UILabel * nameLabel;
    UIView * backwallView;
}
@property (nonatomic, strong)NSMutableArray * datasourceArr;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSNumber * AllCount;

@property (nonatomic, copy)NSString * coverUrl;// 背景墙连接
@property (nonatomic, copy)ExchangeWallImageBlock myBlock;
@property (nonatomic, assign)BOOL isExchangeWallImage;
@end

@implementation UserFriendCircleViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.userId.intValue == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
        TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
        [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
        self.title = @"我的";
        TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"informationCenter"]];
        [rightBarItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateNormal];
        [rightBarItem addTarget:self action:@selector(lookallcomment:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    }else
    {
        RCDUserInfo * rcdUserInfo = [[RCDataBaseManager shareInstance]getFriendInfo:[NSString stringWithFormat:@"%@", self.userId]];
        TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:rcdUserInfo.displayName];
        [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    }
    
    [self initTableview];
    [mainTable.mj_header beginRefreshing];
    
}

- (void)initTableview
{
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.tableHeaderView = [self getMainTableHeadView];
    
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    [mainTable registerClass:[UserFrienfCircleCell class] forCellReuseIdentifier:CELLID];
    mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mainTable.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
- (UIView *)getMainTableHeadView
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_width - 40)];
    
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headView.hd_width, headView.hd_height - 30)];
    backImageView.image = [UIImage imageNamed:@"defaultBackimge"];
    [backImageView setContentMode:UIViewContentModeScaleAspectFill];
    backImageView.clipsToBounds = YES;
    [headView addSubview:backImageView];
    
    if (self.userId.intValue == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeBackWallImage)];
        backImageView.userInteractionEnabled = YES;
        [backImageView addGestureRecognizer:tap];
    }
    
    
    iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headView.hd_width - 95, headView.hd_height - 80, 80, 80)];
    iconImageView.image = [UIImage imageNamed:@"placeHolderImage1"];
    [headView addSubview:iconImageView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, iconImageView.hd_y + 15, headView.hd_width - 15 * 3 - iconImageView.hd_width, 20)];
    nameLabel.text = @"";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = 2;
    [headView addSubview:nameLabel];
    
    return headView;
}
- (void)backAction:(UIButton *)button
{
    if (self.isExchangeWallImage) {
        if (self.myBlock) {
            _myBlock(backImageView.image);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lookallcomment:(UIButton *)button
{
    NSLog(@"查看所有评论");
    
//    [[RCDataBaseManager shareInstance]clearFriendcircleMessage];
    FriendCircleMessgaeViewController * messageVc = [[FriendCircleMessgaeViewController alloc]init];
    messageVc.allMessage = YES;

    [self.navigationController pushViewController:messageVc animated:YES];
}

- (void)loadNewData
{
    _page = 1;
    
    mainTable.mj_footer.state = MJRefreshStateIdle;
    NSDictionary * jsonDic = @{
                               @"Page":@1,
                               @"Count":@10,
                               @"UserId":self.userId
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@news/getFriendCircleInfo?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak UserFriendCircleViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [mainTable.mj_header endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                wxVC.AllCount = [responseObject objectForKey:@"AllCount"];
                
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[responseObject objectForKey:@"User"] objectForKey:@"PortraitUri"]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
                nameLabel.text = [[responseObject objectForKey:@"User"] objectForKey:@"DisplayName"];
                [backImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"CoverUrl"]] placeholderImage:[UIImage imageNamed:@"defaultBackimge"]];
                
                
                if (wxVC.datasourceArr.count > 0) {
                    [wxVC.datasourceArr removeAllObjects];
                }
                
                NSArray * FirendCircleList = [NSArray array];
                FirendCircleList = [responseObject objectForKey:@"FriendCircleInfor"];
//                [wxVC getdataWithArray:FirendCircleList];
                
                for (NSDictionary * dic in FirendCircleList) {
                    UserFriendCircleModel * model = [[UserFriendCircleModel alloc]init];
                    
                    NSString *string = [dic objectForKey:@"TakePhoto"];
                    if (string.length!=0) {
                        NSArray * strArr = [string componentsSeparatedByString:@","];
                        for (NSString * imagrUrlStr in strArr) {
                            //                        NSString * str = [imagrUrlStr stringByAppendingString:@".w150.png"];
                            [model.takeImageArr addObject:imagrUrlStr];
                        }
                    }
                    
                    model.takeId = [dic objectForKey:@"TakeId"];
                    model.takeContent = [dic objectForKey:@"TakeContent"];
                    model.creatTime = [dic objectForKey:@"CreateTime"];
                    [wxVC.datasourceArr addObject:model];
                }
                
                [mainTable reloadData];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [mainTable.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData
{
    
    if (_datasourceArr.count >= _AllCount.intValue) {
        [mainTable.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    _page++;
    NSNumber * page = @(_page);
    
    NSDictionary * jsonDic = @{
                               @"Page":page,
                               @"Count":@10,
                               @"UserId":self.userId
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@news/getFriendCircleInfo?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak UserFriendCircleViewController * wxVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [mainTable.mj_footer endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                NSArray * FirendCircleList = [NSArray array];
                FirendCircleList = [responseObject objectForKey:@"FriendCircleInfor"];
                if (FirendCircleList.count > 0) {
                
                    for (NSDictionary * dic in FirendCircleList) {
                        UserFriendCircleModel * model = [[UserFriendCircleModel alloc]init];
                        
                        NSString *string = [dic objectForKey:@"TakePhoto"];
                        if (string.length!=0) {
                            NSArray * strArr = [string componentsSeparatedByString:@","];
                            for (NSString * imagrUrlStr in strArr) {
                                NSString * str = [imagrUrlStr stringByAppendingString:@".w150.png"];
                                [model.takeImageArr addObject:str];
                            }
                        }
                        
                        model.takeId = [dic objectForKey:@"TakeId"];
                        model.takeContent = [dic objectForKey:@"TakeContent"];
                        model.creatTime = [dic objectForKey:@"CreateTime"];
                        [wxVC.datasourceArr addObject:model];
                    }
                    [mainTable reloadData];
                }else
                {
                    [mainTable.mj_footer endRefreshingWithNoMoreData];
                }
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [mainTable.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserFrienfCircleCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    
    UserFriendCircleModel * model = self.datasourceArr[indexPath.row];
    [cell creatcontantViewWith:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserFriendCircleModel * model = self.datasourceArr[indexPath.row];
    return model.height;
}

#pragma mark - 修改背景墙
- (void)exchangeBackWallImage
{
    backwallView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backwallView.backgroundColor = [UIColor clearColor];
    
    UIView * clearView = [[UIView alloc]initWithFrame:backwallView.bounds];
    clearView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.5];
    [backwallView addSubview:clearView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissexchangeView)];
    [clearView addGestureRecognizer:tap];
    
    UIButton * exchangeBackWallImageBT = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBackWallImageBT.frame = CGRectMake((screenWidth - 218) / 2, 64 + screenWidth - 75, 218, 38);
    exchangeBackWallImageBT.layer.cornerRadius = 3;
    exchangeBackWallImageBT.layer.masksToBounds = YES;
    exchangeBackWallImageBT.backgroundColor = [UIColor whiteColor];
    [exchangeBackWallImageBT setTitle:@"更换背景封面" forState:UIControlStateNormal];
    exchangeBackWallImageBT.titleLabel.font = [UIFont systemFontOfSize:18];
    [exchangeBackWallImageBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backwallView addSubview:exchangeBackWallImageBT];
    
    [exchangeBackWallImageBT addTarget:self action:@selector(exchangeImageAction) forControlEvents:UIControlEventTouchUpInside];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:backwallView];
    
}
- (void)dismissexchangeView
{
    [backwallView removeFromSuperview];
}
- (void)exchangeImageAction
{
    [backwallView removeFromSuperview];
    ExchangeBackwallImageViewController * exchangeVC = [[ExchangeBackwallImageViewController alloc]initWithNibName:@"ExchangeBackwallImageViewController" bundle:nil];
    __weak UserFriendCircleViewController * weakSelf = self;
    [exchangeVC getBackWallImage:^(UIImage *image) {
        if (image) {
            backImageView.image = image;
            weakSelf.isExchangeWallImage = YES;
        }
    }];
    [self.navigationController pushViewController:exchangeVC animated:YES];
    
}

- (void)exchangeWallImage:(ExchangeWallImageBlock)block
{
    self.myBlock = [block copy];
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
