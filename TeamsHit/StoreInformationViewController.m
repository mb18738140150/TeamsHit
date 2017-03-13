//
//  StoreInformationViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "StoreInformationViewController.h"
#import "StoreImformationCell.h"
#import "StoreEquipmentInformationTableViewCell.h"
#import "StoreinformationModel.h"
#import "StoreEquipmentInfoModel.h"
#import "GroupDetailSetTipView.h"
#import "StoreBindingEquipmentViewController.h"

#import "PrintHistoryViewController.h"

#define STOREINFORMATIONCELLID @"StoreImformationCellID"
#define STOREEQUIPMENTINFOCELLID @"StoreEquipmentInformationTableViewCellID"


@interface StoreInformationViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD * hud;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)StoreinformationModel * storeInfoModel;
@property (nonatomic, strong)StoreEquipmentInfoModel * equipmentInfoModel;
@property (nonatomic, strong)NSMutableArray * dataArr;
@end

@implementation StoreInformationViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"商家信息";
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"title_right_icon"] title:@"绑定"];
    [rightBarItem setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(bindAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"StoreImformationCell" bundle:nil] forCellReuseIdentifier:STOREINFORMATIONCELLID];
    [self.tableview registerNib:[UINib nibWithNibName:@"StoreEquipmentInformationTableViewCell" bundle:nil] forCellReuseIdentifier:STOREEQUIPMENTINFOCELLID];
    [self getData];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bindAction:(UIButton *)sender
{
    StoreBindingEquipmentViewController * bindVC = [[StoreBindingEquipmentViewController alloc]initWithNibName:@"StoreBindingEquipmentViewController" bundle:nil];
    bindVC.account = self.accountNumber;
    bindVC.type = self.type;
    __weak StoreInformationViewController * weakSelf = self;
    [bindVC addDeviceAction:^{
        [weakSelf getData];
    }];
    
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)getData
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"AccountNumber":@(self.accountNumber),
                               @"TakeoutType":@(self.type)
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@takeout/StoreInformation?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            [self refreshUI:responseObject];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        
    }];
}

- (void)refreshUI:(NSDictionary *)dic
{
    self.storeInfoModel = [[StoreinformationModel alloc]init];
    self.storeInfoModel.storeUserName = [dic objectForKey:@"UserName"];
    self.storeInfoModel.storeName = [dic objectForKey:@"StoreName"];
    self.storeInfoModel.storeId = [dic objectForKey:@"StoreId"];
    self.storeInfoModel.autoreciveOrder = [[dic objectForKey:@"AutoReceiveOrder"] intValue];
    
    [self.dataArr removeAllObjects];
    NSArray * equipmentArr = [dic objectForKey:@"EquipmentList"];
    for (NSDictionary * equipDic in equipmentArr) {
        StoreEquipmentInfoModel * model = [[StoreEquipmentInfoModel alloc]init];
        model.number = [[equipDic objectForKey:@"Number"] integerValue];
        model.equipmentNumber = [equipDic objectForKey:@"EquipmentNumber"] ;
        model.ptintNumber = [[equipDic objectForKey:@"PrintNumber"] intValue];
        model.equipmentState = [[equipDic objectForKey:@"EquipmentState"] intValue];
        [self.dataArr addObject:model];
    }
    [self.tableview reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArr.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return _dataArr.count;
    }else
    {
        return 1;
    }
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak StoreInformationViewController * weakSelf = self;
    if (indexPath.section == 0) {
        StoreImformationCell * cell = [tableView dequeueReusableCellWithIdentifier:STOREINFORMATIONCELLID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.storeInfoModel;
        [cell autoReceiveOrderAction:^(int type) {
            
            if (type == 100) {
                [weakSelf lookPrintHistory];
            }else
            {
                [weakSelf autoReceiveOrder:type];
            }
            
        }];
        return cell;
    }else
    {
        StoreEquipmentInformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:STOREEQUIPMENTINFOCELLID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        StoreEquipmentInfoModel * model = self.dataArr[indexPath.row];
        cell.model = model;
        [cell operationAction:^(NSString *opetation) {
            if ([opetation isEqualToString:@"edit"]) {
                [self editPrintNumberWithModel:model];
            }else
            {
                [self deleteEquipmentWithModel:model];
            }
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210 + 47;
    }else
    {
        return 250;
    }
}

#pragma mark - printHistory
- (void)lookPrintHistory
{
    NSLog(@"printHistory");
    
    PrintHistoryViewController * printVC = [[PrintHistoryViewController alloc]init];
    printVC.accountNumber = self.accountNumber;
    [self.navigationController pushViewController:printVC animated:YES];
    
}

#pragma mark - autoreceoveorder
- (void)autoReceiveOrder:(int)type
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"AccountNumber":@(self.accountNumber),
                               @"TakeoutType":@(self.type),
                               @"AutoReceiveOrder":@(type)
                               };
    NSLog(@"%@", [jsonDic description]);
    NSString * url = [NSString stringWithFormat:@"%@takeout/AutoReceiveOrder?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    UICollectionViewCell * cell;
    
    
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            self.storeInfoModel.autoreciveOrder = type;
            [self.tableview reloadData];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        
    }];
}


#pragma mark - operation
- (void)editPrintNumberWithModel:(StoreEquipmentInfoModel *)model
{
    NSArray * typeArr = @[@"1", @"2", @"3", @"4"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"选择打印份数" content:typeArr];
    [setTipView show];
    
    __weak StoreInformationViewController * weakSelf = self;
    [setTipView getPickerData:^(NSString *string) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        int printNumber = 0;
        if (string) {
            printNumber = string.intValue;
        }else
        {
            printNumber = 1;
        }
        
        NSDictionary * jsonDic = @{
                                   @"AccountNumber":@(self.accountNumber),
                                   @"TakeoutType":@(self.type),
                                   @"EquipmentNumber":model.equipmentNumber,
                                   @"PrintNumber":@(printNumber)
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@takeout/EditEquipmentPrintNum?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        
        [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                model.ptintNumber = printNumber;
                [weakSelf.tableview reloadData];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }];
    }];
    
}

- (void)deleteEquipmentWithModel:(StoreEquipmentInfoModel *)model
{
    __weak StoreInformationViewController * weakSelf = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"AccountNumber":@(self.accountNumber),
                               @"TakeoutType":@(self.type),
                               @"EquipmentNumber":model.equipmentNumber
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@takeout/DeleteStoreEquipment?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            [weakSelf.dataArr removeObject:model];
            [weakSelf.tableview reloadData];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        
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
