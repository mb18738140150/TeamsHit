//
//  RegisterViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "RegisterViewController.h"
#import "CompleteInformationViewController.h"
#import "RCDUtilities.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    int _t;
}
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (strong, nonatomic) IBOutlet UITextField *phonrNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *getVerifyCodeBT;
@property (strong, nonatomic) IBOutlet UIButton *refisteBT;

// 验证码倒计时
@property (nonatomic, strong)NSTimer * codeTimer;
/**
 *  服务器返回MD5加密的手机验证码
 */
@property (nonatomic, copy)NSString * md5Code;

@property (nonatomic, strong)NSDate * codeDate;

@property (nonatomic, strong)UIButton * backBT;
@property (nonatomic, copy)NSString * titletext;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UIView * backView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    ((TeamsHitNavigationViewController *)(self.navigationController)).titletext = @"注册";
//    [((TeamsHitNavigationViewController *)(self.navigationController)).backBT addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.getVerifyCodeBT.layer.cornerRadius = 3;
    self.getVerifyCodeBT.layer.masksToBounds = YES;
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"注册"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.refisteBT.layer.cornerRadius = 3;
    self.refisteBT.layer.masksToBounds = YES;
    [_getVerifyCodeBT addTarget:self action:@selector(getCodeFromeServer:) forControlEvents:UIControlEventTouchUpInside];
    [_refisteBT addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    /*
     
     //    self.backBT = [UIButton buttonWithType:UIButtonTypeCustom];
     //    self.backBT.frame = CGRectMake(0, 0, 40, 40);
     //    [self.backBT setImage:[UIImage imageNamed:@"password_hide"] forState:UIControlStateNormal];
     //
     //    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 20, 40)];
     //    self.titleLB.textColor = [UIColor blackColor];
     ////    self.titleLB.backgroundColor = [UIColor redColor];
     //    self.titleLB.textAlignment = 1;
     //
     //    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
     //    [self.backView addSubview:self.backBT];
     //    [self.backView addSubview:self.titleLB];
     //    self.titletext = @"注册";
     //    [self.backBT addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
     //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backView];
     */
    
    // Do any additional setup after loading the view.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
//    self.backGroundView.frame = CGRectMake(0, 64, self.view.hd_width, self.view.hd_height);
}

#pragma mark - 获取验证码

- (void)getCodeFromeServer:(UIButton *)button
{
    [self.phonrNumberTF resignFirstResponder];
    [self.verifyCodeTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    if ([NSString isTelPhoneNub:self.phonrNumberTF.text]) {
        _t = 60;
        _verifyCodeTF.enabled = YES;
        self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(codeTime) userInfo:nil repeats:YES];
//        button.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        button.enabled = NO;
        [_getVerifyCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", _t] forState:UIControlStateDisabled];
        [self performSelector:@selector(passTime) withObject:nil afterDelay:10];
        
        NSDictionary * jsonDic = @{
                                   @"PhoneNumber":self.phonrNumberTF.text
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
    [_getVerifyCodeBT setTitle:[NSString stringWithFormat:@"%ds后重发", --_t] forState:UIControlStateDisabled];
}
- (void)passTime
{
    self.getVerifyCodeBT.enabled = YES;
//    _getVerifyCodeBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [_getVerifyCodeBT setTitle:@"重新获取" forState:UIControlStateNormal];
    [self.codeTimer invalidate];
    self.codeTimer = nil;
}

#pragma mark = 注册
- (void)registerAction:(UIButton *)button
{
    [self pushCompleteVC];
    
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
                if (self.passwordTF.text.length > 0) {
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
    NSDictionary * jsonDic = @{
                               @"Phone":self.phonrNumberTF.text,
                               @"Password":self.passwordTF.text,
                               @"RegFromType":@4
                               };
    [[HDNetworking sharedHDNetworking] POST:@"user/register" parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [self pushCompleteVC];
        NSLog(@"**%@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
    }];
}
- (void)setTitletext:(NSString *)titletext
{
    CGSize lableSize = [titletext hd_sizeWithFont:[UIFont systemFontOfSize:17] andMaxSize:CGSizeMake(CGFLOAT_MAX, self.titleLB.hd_height)];
    self.titleLB.text = titletext;
    self.titleLB.hd_width = lableSize.width;
    self.backView.hd_width = lableSize.width + 40;
}

// 注册成功后自动登录，获取token，成功后跳转到补全界面，完善信息
- (void)pushCompleteVC
{
    NSDictionary * jsonDic = @{
                               @"Account":self.phonrNumberTF.text,
                               @"Password":self.passwordTF.text,
                               };
    __weak RegisterViewController * rVC = self;
    [[HDNetworking sharedHDNetworking] POST:@"user/login" parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"**%@", responseObject);
        if ([[responseObject objectForKey:@"Code"] intValue] != 200) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"Message"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }else
        {
            [UserInfo shareUserInfo].userToken = [responseObject objectForKey:@"UserToken"];
            [UserInfo shareUserInfo].rongToken = [responseObject objectForKey:@"RongToken"];
            RCUserInfo *user = [RCUserInfo new];
            user.userId = [NSString stringWithFormat:@"%@", responseObject[@"UserId"]];
            user.name = [NSString stringWithFormat:@"name%@", [NSString stringWithFormat:@"%@", responseObject[@"UserId"]]];
            user.portraitUri = [RCDUtilities defaultUserPortrait:user];
            [RCIM sharedRCIM].currentUserInfo = user;
            
            NSLog(@"%@", [RCIM sharedRCIM].currentUserInfo.userId);
            CompleteInformationViewController * completeVc = [[CompleteInformationViewController alloc]initWithNibName:@"CompleteInformationViewController" bundle:nil];
            [rVC.navigationController pushViewController:completeVc animated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (void)pushComPleteVC
//{
//    CompleteInformationViewController * completeVc = [[CompleteInformationViewController alloc]initWithNibName:@"CompleteInformationViewController" bundle:nil];
//    [self.navigationController pushViewController:completeVc animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
