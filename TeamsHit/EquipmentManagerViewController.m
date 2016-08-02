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

#import "ConfigurationWiFiViewController.h"

#define CELL_IDENTIFIRE @"cellid"


@interface EquipmentManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *addNewEquipmentView;
@property (strong, nonatomic) IBOutlet UITableView *equipmentTableView;

@property (nonatomic, strong)NSMutableArray * equipmentArray;

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
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"配置设备"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    [self.equipmentTableView registerClass:[EquipmentTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIRE];
    self.equipmentTableView.bounces = NO;
    
    EquipmentModel * model = [[EquipmentModel alloc]init];
    model.equipmentTitle = @"对对机";
    model.state = @1;
    model.buzzer = @1;
    model.indicatorLight = @1;
    
    EquipmentModel * model1 = [[EquipmentModel alloc]init];
    model1.equipmentTitle = @"对对机";
    model1.state = @0;
    model1.buzzer = @0;
    model1.indicatorLight = @1;
    
    [self.equipmentArray addObject:model];
    [self.equipmentArray addObject:model1];
    
    
    UITapGestureRecognizer * equipmentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(equipmentAction:)];
    [self.addNewEquipmentView addGestureRecognizer:equipmentTap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)equipmentAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"跳转到绑定新设备界面");
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
                [equipmentVC.navigationController pushViewController:configurationVC animated:YES];
            }
                break;
            case 1:
            {
                NSLog(@"设备名称");
            }
                break;
            case 2:
            {
                NSLog(@"蜂鸣器");
            }
                break;
            case 3:
            {
                NSLog(@"指示灯");
                NSString * str = [NSString SSID];
            }
                break;
            case 100:
            {
                NSLog(@"删除设备");
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
    return 143;
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
