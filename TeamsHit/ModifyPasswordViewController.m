//
//  ModifyPasswordViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (strong, nonatomic) IBOutlet UITextField *nPassword;

@property (strong, nonatomic) IBOutlet UITextField *againnPassword;


@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
        self.title = @"修改密码";
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}
- (IBAction)modifyPasswordAction:(id)sender {
    
    if (self.oldPasswordTF.text.length != 0 && self.nPassword.text.length != 0 && self.againnPassword.text.length != 0) {
        hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        
        NSDictionary *requestContents = @{
                                          @"OldPassword": self.oldPasswordTF.text,
                                          @"NewPassword":self.nPassword.text,
                                          @"ConfirmPassword":self.againnPassword.text
                                          };
        
        __weak ModifyPasswordViewController * weakSelf = self;
        NSString * url = [NSString stringWithFormat:@"%@userinfo/modifyPassword?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:requestContents progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                [weakSelf backAction];
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            NSLog(@"%@", error);
        }];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"旧密码、新密码均不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
