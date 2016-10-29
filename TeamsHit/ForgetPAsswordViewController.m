//
//  ForgetPAsswordViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ForgetPAsswordViewController.h"

@interface ForgetPAsswordViewController ()<UITextFieldDelegate>
{
    int _t;
    MBProgressHUD * hud;
}
@property (strong, nonatomic) IBOutlet UITextField *telephonenumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *countDownBT;
@property (strong, nonatomic) IBOutlet UITextField *nPasswordTF;
// 验证码倒计时
@property (nonatomic, strong)NSTimer * codeTimer;
/**
 *  服务器返回MD5加密的手机验证码
 */
@property (nonatomic, copy)NSString * md5Code;

@property (nonatomic, strong)NSDate * codeDate;

@end

@implementation ForgetPAsswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"忘记密码";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)getVerifyCodeBT:(id)sender {
    UIButton * button = sender;
    [self.telephonenumberTF resignFirstResponder];
    [self.verifyCodeTF resignFirstResponder];
    [self.nPasswordTF resignFirstResponder];
    if ([NSString isTelPhoneNub:self.telephonenumberTF.text]) {
        _t = 60;
        _verifyCodeTF.enabled = YES;
        self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(codeTime) userInfo:nil repeats:YES];
        //        button.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        button.enabled = NO;
        [button setTitle:[NSString stringWithFormat:@"%ds后重发", _t] forState:UIControlStateDisabled];
        [self performSelector:@selector(passTime) withObject:nil afterDelay:60];
        
        NSDictionary * jsonDic = @{
                                   @"PhoneNumber":self.telephonenumberTF.text
                                   };
        [[HDNetworking sharedHDNetworking] POST:@"user/getVerificationCode" parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            self.md5Code = [responseObject objectForKey:@"Verifycode"];
            if ([[responseObject objectForKey:@"Code"] intValue] != 200) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"Message"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
            self.codeDate = [NSDate date];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error = %@", error);
        }];
    }else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}
- (void)codeTime
{
    [_countDownBT setTitle:[NSString stringWithFormat:@"%ds后重发", --_t] forState:UIControlStateDisabled];
//    NSLog(@"%d", _t);
}
- (void)passTime
{
    self.countDownBT.enabled = YES;
    //    _getVerifyCodeBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [_countDownBT setTitle:@"重新获取" forState:UIControlStateNormal];
    [self.codeTimer invalidate];
    self.codeTimer = nil;
}
- (IBAction)complateAction:(id)sender {
    
    if (self.verifyCodeTF.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else
    {
        if ([self.md5Code isEqualToString:[[[NSString stringWithFormat:@"%@vwBYVr6n", self.verifyCodeTF.text] md5] lowercaseString]]) {
            NSTimeInterval seconds = [[NSDate date]timeIntervalSinceDate:self.codeDate];
            if (seconds >1200) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间超时,请重新获取验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else
            {
                if (self.nPasswordTF.text.length > 0) {
                    [self registerAccount];
                }else
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
                }
                
            }
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
    }
}

- (void)registerAccount
{
    
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"Phone":self.telephonenumberTF.text,
                               @"Password":self.nPasswordTF.text
                               };
    
    __weak ForgetPAsswordViewController * weakself = self;
    [[HDNetworking sharedHDNetworking] POST:@"user/resetPassword" parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"**%@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            [weakself.navigationController popViewControllerAnimated:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"error = %@", error);
    }];
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
