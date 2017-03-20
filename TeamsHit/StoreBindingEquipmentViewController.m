//
//  StoreBindingEquipmentViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "StoreBindingEquipmentViewController.h"

@interface StoreBindingEquipmentViewController ()<UITextFieldDelegate>
{
    MBProgressHUD * hud;
}
@property (strong, nonatomic) IBOutlet UITextField *equipmentNumberLB;
@property (strong, nonatomic) IBOutlet UITextField *codeLB;
@property (strong, nonatomic) IBOutlet UITextField *printNumLB;

@property (strong, nonatomic) IBOutlet UIButton *bindBT;

@end

@implementation StoreBindingEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"绑定设备"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
//    self.title = @"商家信息";
    
//    self.equipmentNumberLB.text = @"5b18606c40301f3a";
//    self.codeLB.text = @"4e767c13";
    self.equipmentNumberLB.text = @"";
    self.codeLB.text = @"";
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)bindAction:(id)sender {
    
    [self.equipmentNumberLB resignFirstResponder];
    [self.codeLB resignFirstResponder];
    [self.printNumLB resignFirstResponder];
    
    if (self.equipmentNumberLB.text.length == 0) {
        [self showAlert:@"设备不能为空"];
        return;
    }
    if (self.codeLB.text.length == 0) {
        [self showAlert:@"授权码不能为空"];
        return;
    }
    if (self.printNumLB.text.length <= 0 || self.printNumLB.text.intValue <= 0) {
        [self showAlert:@"打印份数最少为1"];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"AccountNumber":@(self.account),
                               @"TakeoutType":@(self.type),
                               @"AuthorizationCode":self.codeLB.text,
                               @"EquipmentNumber":self.equipmentNumberLB.text,
                               @"PrintNumber":@(self.printNumLB.text.intValue)
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@takeout/BindingStoreEquipment?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak StoreBindingEquipmentViewController * weakSelf = self;
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            if (weakSelf.myBlock) {
                weakSelf.myBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
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

- (void)showAlert:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)addDeviceAction:(AddDeviceBlock)block
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
