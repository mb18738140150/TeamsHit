//
//  EquipmentManagerViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "EquipmentManagerViewController.h"
#import "EquipmentTableViewCell.h"
#import "EquipmentModel.h"
#import "ChangeEquipmentNameView.h"
#import "ConfigurationWiFiViewController.h"
#import "AppDelegate.h"
#import "AddEquipmentViewController.h"
#import "ConcentrationlistView.h"

#define CELL_IDENTIFIRE @"cellid"


@interface EquipmentManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UIView *addNewEquipmentView;
@property (strong, nonatomic) IBOutlet UITableView *equipmentTableView;
@property (nonatomic, strong)NSMutableArray * equipmentArray;

@property (nonatomic, strong)ConcentrationlistView * concentrationListView;

// 修改设备名称
@property (nonatomic, strong)ChangeEquipmentNameView  * changeNameView;

@end

@implementation EquipmentManagerViewController

- (NSMutableArray *)equipmentArray
{
    if (!_equipmentArray) {
        _equipmentArray = [NSMutableArray array];
    }
    return _equipmentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"配置设备";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    [self.equipmentTableView registerClass:[EquipmentTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIRE];
//    self.equipmentTableView.bounces = NO;
    self.equipmentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    
    UITapGestureRecognizer * equipmentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(equipmentAction:)];
    [self.addNewEquipmentView addGestureRecognizer:equipmentTap];
    
    [self getDeviceData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self getDeviceData];
}
- (void)getDeviceData
{
//    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud show:YES];
    NSString * url = [NSString stringWithFormat:@"%@userinfo/getDeviceList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak EquipmentManagerViewController * equipmentVC = self;
    
    [[HDNetworking sharedHDNetworking]GET:url parameters:nil success:^(id  _Nonnull responseObject) {
//        [hud hide:YES];
        [equipmentVC.equipmentTableView.mj_header endRefreshing];
        NSLog(@"responseObject = %@", responseObject);
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        
        if (code == 200) {
            
            if (equipmentVC.equipmentArray.count != 0) {
                [equipmentVC.equipmentArray removeAllObjects];
            }
            
            NSArray * array = [responseObject objectForKey:@"DeviceList"];
            
            for (NSDictionary * dic in array) {
                EquipmentModel * model = [[EquipmentModel alloc]initWithDictionary:dic];
                [equipmentVC.equipmentArray addObject:model];
            }
            
            [equipmentVC.equipmentTableView reloadData];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        [equipmentVC.equipmentTableView.mj_header endRefreshing];
    }];
}

- (void)refreshNewData
{
    [self getDeviceData];
}

- (void)equipmentAction:(UITapGestureRecognizer *)sender
{
    
    AddEquipmentViewController * addVC = [[AddEquipmentViewController alloc]init];
    __weak EquipmentManagerViewController * equipmentVC = self;
    [addVC refreshDeviceData:^{
        [equipmentVC getDeviceData];
    }];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.equipmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EquipmentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIRE forIndexPath:indexPath];
    
    EquipmentModel * model = self.equipmentArray[indexPath.row];
    [cell createSubView:tableView.bounds];
    cell.emodel = model;
    
    __weak EquipmentManagerViewController * equipmentVC = self;
    [cell getEquipmentOption:^(NSInteger type) {
        switch (type) {
            case 0:
            {
                NSLog(@"配置WiFi");
                ConfigurationWiFiViewController * configurationVC = [[ConfigurationWiFiViewController alloc]initWithNibName:@"ConfigurationWiFiViewController" bundle:nil];
                configurationVC.isEquipmentManagerVc = YES;
                [equipmentVC.navigationController pushViewController:configurationVC animated:YES];
            }
                break;
            case 1:
            {
                NSLog(@"设备名称");
                
                if (equipmentVC.changeNameView) {
                   AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                    [delegate.window addSubview:self.changeNameView];
                }else
                {
                    NSArray * nibarr = [[NSBundle mainBundle]loadNibNamed:@"ChangeEquipmentNameView" owner:self options:nil];
                    equipmentVC.changeNameView = [nibarr objectAtIndex:0];
                    CGRect tmpFrame = [[UIScreen mainScreen] bounds];
                    equipmentVC.changeNameView.frame = tmpFrame;
                    self.changeNameView.equipmentNameTF.delegate = self.changeNameView;
                    equipmentVC.changeNameView.equipmentNameTF.text = model.deviceName;
                    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
                    [delegate.window addSubview:self.changeNameView];
                    
//                    __weak EquipmentManagerViewController * equipmentVC = self;
                    [equipmentVC.changeNameView getEquipmentOption:^(NSString *name) {
                        NSLog(@"name = %@", name);
                        [equipmentVC.changeNameView removeFromSuperview];
                        
                        NSDictionary * jsonDic = @{
                                                   @"Uuid":model.uuid,
                                                   @"NewDeviceName":equipmentVC.changeNameView.equipmentNameTF.text
                                                   };
                        
                        NSString * url = [NSString stringWithFormat:@"%@userinfo/ModifyDeviceName?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
                        
                        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
                            ;
                        } success:^(id  _Nonnull responseObject) {
                            NSLog(@"responseObject = %@", responseObject);
                            int code = [[responseObject objectForKey:@"Code"] intValue];
                            if (code == 200) {
                                model.deviceName = equipmentVC.changeNameView.equipmentNameTF.text;
                            }else
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                                [alert show];
                                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                            }
                            [equipmentVC.equipmentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } failure:^(NSError * _Nonnull error) {
                            NSLog(@"%@", error);
                        }];
                        
                    }];
                }
                
            }
                break;
            case 3:
            {
                NSLog(@"蜂鸣器");
                NSNumber * state = @0;
                if (model.buzzer.intValue == 0) {
                    state = @1;
                }
                
                NSDictionary * jsonDic = @{
                                           @"Uuid":model.uuid,
                                           @"BuzzerState":state
                                           };
                
                NSString * url = [NSString stringWithFormat:@"%@userinfo/BuzzerSwitch?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
                
                [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
                    ;
                } success:^(id  _Nonnull responseObject) {
                    NSLog(@"responseObject = %@", responseObject);
                    int code = [[responseObject objectForKey:@"Code"] intValue];
                    if (code == 200) {
                        model.buzzer = state;
                    }else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [alert show];
                        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                    }
                    [equipmentVC.equipmentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@", error);
                }];
                
            }
                break;
            case 4:
            {
                NSLog(@"指示灯");
                NSNumber * state = @0;
                if (model.indicator.intValue == 0) {
                    state = @1;
                }
                
                NSDictionary * jsonDic = @{
                                           @"Uuid":model.uuid,
                                           @"IndicatorState":state
                                           };
                
                NSString * url = [NSString stringWithFormat:@"%@userinfo/IndicatorSwitch?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
                
                [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
                    ;
                } success:^(id  _Nonnull responseObject) {
                    NSLog(@"responseObject = %@", responseObject);
                    int code = [[responseObject objectForKey:@"Code"] intValue];
                    if (code == 200) {
                        model.indicator = state;
                    }else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [alert show];
                        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                    }
                    [equipmentVC.equipmentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@", error);
                }];
            }
                break;
            case 2:
            {
                NSLog(@"修改打印浓度");
                [equipmentVC modifyConcentration:model];
            }
                break;
            case 100:
            {
                NSLog(@"删除设备");
                [equipmentVC unBindWithUuid:model.uuid];
            }
                break;
                
            default:
                break;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148;
}

#pragma mark - 解绑
- (void)unBindWithUuid:(NSString *)uuid
{
    NSDictionary * jsonDic = @{
                               @"Uuid":uuid,
                               @"UserFor":@2
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/binddevice?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak EquipmentManagerViewController * equipmentVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (command == 10010) {
            if (code == 200) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"解绑成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                [equipmentVC getDeviceData];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 浓度设置
- (void)modifyConcentration:(EquipmentModel*)model
{
    __weak EquipmentManagerViewController * weakSelf= self;
    self.concentrationListView = [[ConcentrationlistView alloc]initWithFrame:[UIScreen mainScreen].bounds with:model.concentration.intValue];
    [self.concentrationListView show];
    [self.concentrationListView modifyConcentration:^(int concentrationNum) {
        NSLog(@"%d", concentrationNum);
        
        // 浓度改变
        if (concentrationNum != model.concentration.intValue) {
            [weakSelf modifiConcentration:concentrationNum withModel:model];
        }
        
    }];
    
}

- (void)modifiConcentration:(int)number withModel:(EquipmentModel *)model
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    __weak EquipmentManagerViewController * weakSelf= self;
    NSDictionary * jsonDic = @{
                               @"Uuid":model.uuid,
                               @"Concentration":@(number)
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/ModifyDeviceConcentration?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            model.concentration = @(number);
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
        [weakSelf.equipmentTableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", @"服务器连接失败"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
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
