//
//  BusinessServeViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "BusinessServeViewController.h"
#import "TakeoutAccountTableViewCell.h"
#import "TakeOutNewAcountTableViewCell.h"
#import "TakeoutLoginViewController.h"
#import "TakeoutAccountModel.h"
#import "StoreInformationViewController.h"

#define TAKEOUTACCOUNTID @"TakeoutAccountTableViewCellID"
#define TAKEOUTNEWACCOUNTID @"TakeOutNewAcountTableViewCellID"

@interface AccountTypeModel : NSObject

@property (nonatomic, copy)NSString * typeName;
@property (nonatomic, copy)NSString * typeImage;
@end

@implementation AccountTypeModel

@end

@interface BusinessServeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD * hud;
}
@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray * accountArray;
@property (nonatomic, strong)NSMutableArray * accountTypeArray;
@property (nonatomic, strong)NSMutableArray * datasourceArray;

@end


@implementation BusinessServeViewController

- (NSMutableArray *)accountArray
{
    if (!_accountArray) {
        _accountArray = [NSMutableArray array];
    }
    return _accountArray;
}
- (NSMutableArray *)accountTypeArray
{
    if (!_accountTypeArray) {
        _accountTypeArray = [NSMutableArray array];
    }
    return _accountTypeArray;
}

- (NSMutableArray *)datasourceArray
{
    if (!_datasourceArray) {
        _datasourceArray = [NSMutableArray array];
    }
    return _datasourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"授权登录"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
//    self.title = @"授权登录";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    AccountTypeModel * meituanModel = [[AccountTypeModel alloc]init];
    meituanModel.typeName = @"美团";
    meituanModel.typeImage = @"美团1";
    AccountTypeModel * baiduModel = [[AccountTypeModel alloc]init];
    baiduModel.typeName = @"百度外卖";
    baiduModel.typeImage = @"百度外卖";
    AccountTypeModel * elemeModel = [[AccountTypeModel alloc]init];
    elemeModel.typeName = @"饿了么";
    elemeModel.typeImage = @"饿了么";
    [self.accountTypeArray addObject:meituanModel];
    [self.accountTypeArray addObject:elemeModel];
    [self.accountTypeArray addObject:baiduModel];
    [self.datasourceArray addObject:self.accountTypeArray];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 7, self.view.hd_width, self.view.hd_height - 27) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"TakeoutAccountTableViewCell" bundle:nil] forCellReuseIdentifier:TAKEOUTACCOUNTID];
    [self.tableview registerNib:[UINib nibWithNibName:@"TakeOutNewAcountTableViewCell" bundle:nil] forCellReuseIdentifier:TAKEOUTNEWACCOUNTID];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:self.tableview];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.accountArray.count > 0) {
        [self.datasourceArray removeObjectAtIndex:0];
    }
    self.accountArray = [[RCDataBaseManager shareInstance]getTakeoutAccounts];
    for (TakeoutAccountModel * model in self.accountArray) {
        NSLog(@"model.time = %@", model.accountNumber);
    }
    if (self.accountArray.count > 0) {
        [self.datasourceArray insertObject:self.accountArray atIndex:0];
    }
    [self.tableview performSelector:@selector(reloadData) withObject:nil afterDelay:.2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak BusinessServeViewController * weakSelf = self;
    if (self.datasourceArray.count == 2 && indexPath.section == 0) {
        TakeoutAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TAKEOUTACCOUNTID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TakeoutAccountModel * model = [self.datasourceArray[indexPath.section] objectAtIndex:indexPath.row];
        cell.takeoutAccountLabel.text = model.accountName;
        cell.takeouttypename = model.typeName;
        [cell quickLogin:^{
            [weakSelf quickLoginWith:model];
        }];
        return cell;
    }else
    {
        TakeOutNewAcountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TAKEOUTNEWACCOUNTID forIndexPath:indexPath];
        AccountTypeModel * model = [self.datasourceArray[indexPath.section] objectAtIndex:indexPath.row];
        cell.takeoutTypeImageView.image = [UIImage imageNamed:model.typeImage];
        cell.takeoutTypeNameLabel.text = model.typeName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasourceArray.count == 2 && indexPath.section == 0) {
        return 44;
    }else
    {
        return 46;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 10, 26, 26)];
    imageView.image = [UIImage imageNamed:@"businessAccountIcon"];
    [headView addSubview:imageView];
    
    UILabel * textlabel = [[UILabel alloc]initWithFrame:CGRectMake(51, 16, 150, 15)];
    textlabel.font = [UIFont systemFontOfSize:15];
    textlabel.textColor = UIColorFromRGB(0x12B7F5);
    [headView addSubview:textlabel];
    
    if (self.datasourceArray.count == 2 && section == 0) {
        
        textlabel.text = @"已有账号登录";
        
        return headView;
    }else
    {
        textlabel.text = @"新账号登录";
        return headView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 44)];
    footView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasourceArray.count == 2 && indexPath.section == 0) {
        
    }else
    {
        TakeoutLoginViewController * takeoutloginVC = [[TakeoutLoginViewController alloc]initWithNibName:@"TakeoutLoginViewController" bundle:nil];
        takeoutloginVC.type = indexPath.row + 1;
        
        [self.navigationController pushViewController:takeoutloginVC animated:YES];
    }
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak BusinessServeViewController * weakSelf = self;
    if (self.datasourceArray.count == 2 && indexPath.section == 0) {
       UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
           TakeoutAccountModel * model = [weakSelf.datasourceArray[indexPath.section] objectAtIndex:indexPath.row];
           [[RCDataBaseManager shareInstance]deleteTakeoutAccountWithModel:model];
           
           [weakSelf.accountArray removeAllObjects];
           weakSelf.accountArray = [[RCDataBaseManager shareInstance]getTakeoutAccounts];
           if (weakSelf.accountArray.count == 0) {
               [weakSelf.datasourceArray removeObjectAtIndex:0];
           }else
           {
               [weakSelf.datasourceArray replaceObjectAtIndex:0 withObject:weakSelf.accountArray];
           }
           
           for (TakeoutAccountModel * model in weakSelf.accountArray) {
               NSLog(@"model.time = %@", model.accountNumber);
           }
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [weakSelf.tableview reloadData];
           });
       }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction];
        
    }
    return nil;
}

#pragma mark - quickLogin
- (void)quickLoginWith:(TakeoutAccountModel *)model
{
    
    int type = 0;
    
    TakeoutLoginViewController * takeoutloginVC = [[TakeoutLoginViewController alloc]initWithNibName:@"TakeoutLoginViewController" bundle:nil];
    if ([model.typeName isEqualToString:@"美团"]) {
        type = 1;
    }else if ([model.typeName isEqualToString:@"饿了么"])
    {
        type = 2;
    }else
    {
        type = 3;
    }
    if (type == 3) {
        takeoutloginVC.account = model.accountName;
        takeoutloginVC.password = model.password;
        takeoutloginVC.type = 3;
        [self.navigationController pushViewController:takeoutloginVC animated:YES];
    }else
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"登录中";
        [hud show:YES];
        NSDictionary * jsonDic = @{
                                   @"Account":model.accountName,
                                   @"Password":model.password,
                                   @"VerifyCode":@"",
                                   @"TakeoutType":@(type),
                                   @"BdToken":@""
                                   };
        
        NSString * url = [NSString stringWithFormat:@"%@takeout/TakeoutAuthorizationLogin?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"%@", responseObject);
            
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                if (model.accountNumber.integerValue == 0) {
                    takeoutloginVC.account = model.accountName;
                    takeoutloginVC.password = model.password;
                    takeoutloginVC.type = type;
                    [self.navigationController pushViewController:takeoutloginVC animated:YES];
                }else
                {
                    StoreInformationViewController * storeinfoVC = [[StoreInformationViewController alloc]initWithNibName:@"StoreInformationViewController" bundle:nil];
                    storeinfoVC.accountNumber = model.accountNumber.integerValue;
                    storeinfoVC.type = type;
                    [self.navigationController pushViewController:storeinfoVC animated:YES];
                }
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                takeoutloginVC.account = model.accountName;
                takeoutloginVC.password = model.password;
                takeoutloginVC.type = type;
                [self.navigationController pushViewController:takeoutloginVC animated:YES];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }];
    }
    
    
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
