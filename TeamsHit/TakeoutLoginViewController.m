//
//  TakeoutLoginViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/22.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "TakeoutLoginViewController.h"
#import "StoreInformationViewController.h"
#import "TakeoutAccountModel.h"

@interface TakeoutLoginViewController ()<UITextFieldDelegate>
{
    MBProgressHUD * hud;
}
@property (strong, nonatomic) IBOutlet UIImageView *logoImageIcon;
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *hidepasswordBT;

@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *getVerifyCodeBT;

@property (strong, nonatomic) IBOutlet UIView *verifyCodeView;
@property (strong, nonatomic) IBOutlet UIButton *loginBT;

@property (nonatomic, copy)NSString * verifyCodeImageStr;
@property (nonatomic, copy)NSString * typeName;

@property (nonatomic, copy)NSString * BdToken;

@end

@implementation TakeoutLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.verifyCodeView.hidden = YES;
    switch (self.type) {
        case 1:
            self.title = @"美团授权登录";
            self.logoImageIcon.image = [UIImage imageNamed:@"美团2"];
            self.loginBT.backgroundColor = UIColorFromRGB(0xFFD705);
            self.typeName = @"美团";
            break;
        case 2:
            self.title = @"饿了么授权登录";
            self.logoImageIcon.image = [UIImage imageNamed:@"饿了么1"];
            self.loginBT.backgroundColor = UIColorFromRGB(0x3286C4);
            self.typeName = @"饿了么";
            break;
        case 3:
            self.title = @"百度外卖授权登录";
            self.logoImageIcon.image = [UIImage imageNamed:@"百度外卖1"];
            self.loginBT.backgroundColor = UIColorFromRGB(0xE7304F);
            self.typeName = @"百度外卖";
            self.verifyCodeView.hidden = NO;
            [self getverifyCodeImage];
            break;
            
        default:
            break;
    }
    [self.hidepasswordBT setImage:[[UIImage imageNamed:@"password_hide.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.hidepasswordBT setImage:[[UIImage imageNamed:@"password_show.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    if (self.account && self.password) {
        self.accountTF.text = self.account;
        self.passwordTF.text = self.password;
    }
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)hidePasswordAction:(id)sender {
    ((UIButton *)sender).selected = !((UIButton *)sender).selected;
    if (((UIButton *)sender).selected) {
        self.passwordTF.secureTextEntry = NO;
        self.passwordTF.text = self.passwordTF.text;
    }else
    {
        self.passwordTF.secureTextEntry = YES;
        self.passwordTF.text = self.passwordTF.text;
    }
    
}

- (IBAction)getVerifyCodeAction:(id)sender {
    
    NSLog(@"获取验证码");
    [self getverifyCodeImage];
}
#pragma mark - 获取验证码
- (void)getverifyCodeImage
{
    hud = [MBProgressHUD showHUDAddedTo:self.getVerifyCodeBT animated:YES];
    [hud show:YES];
    
    // 饿了么获取验证码需要商家账户
    NSString * account = @"";
    if (self.type == 2) {
        if (self.accountTF.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            account = self.accountTF.text;
        }
    }
    
    NSDictionary * jsonDic = @{
                               @"Account":account,
                               @"TakeoutType":@(self.type)
                               };
    NSLog(@"%@", [jsonDic description]);
    NSString * url = [NSString stringWithFormat:@"%@takeout/GetTakeoutVerifyCode?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        
//        NSLog(@"%@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            self.verifyCodeImageStr = [responseObject objectForKey:@"VerifyCode"];
            if (self.type == 3) {
                self.BdToken = [responseObject objectForKey:@"BdToken"];
                [self getVerifyCodeImageWithURLStr:self.verifyCodeImageStr];
            }else
            {
                [self getVerifyCodeImageWithStr:self.verifyCodeImageStr];
            }
        }else
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
#warning getVerifyCodeImageStr ******
- (void)getVerifyCodeImageWithStr:(NSString * )str
{
    
    NSString * mStr = [str substringFromIndex:21];
    
    NSLog(@"--- %@", mStr);
    NSData * data = [[NSData alloc] initWithBase64EncodedString:mStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage * image = [UIImage imageWithData:data];
    self.getVerifyCodeBT.backgroundColor = [UIColor clearColor];
    [self.getVerifyCodeBT setTitle:@"" forState:UIControlStateNormal];
    [self.getVerifyCodeBT setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)getVerifyCodeImageWithURLStr:(NSString *)str
{
    NSLog(@"URLStr =  %@", str);
    __weak TakeoutLoginViewController * weakSelf = self;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 22)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.getVerifyCodeBT.backgroundColor = [UIColor clearColor];
        [weakSelf.getVerifyCodeBT setTitle:@"" forState:UIControlStateNormal];
        [weakSelf.getVerifyCodeBT setBackgroundImage:imageView.image forState:UIControlStateNormal];
    }];
}

- (IBAction)loginAction:(id)sender {
    NSLog(@"登录");
    
    if (self.accountTF.text.length == 0 || self.passwordTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号密码均不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!self.verifyCodeView.hidden && self.verifyCodeTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString * verify = @"";
    if (!self.verifyCodeView.hidden) {
        verify = self.verifyCodeTF.text;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中";
    [hud show:YES];
    
    NSString * bdToken = @"";
    if (self.type == 3) {
        bdToken = self.BdToken;
    }
    
    NSDictionary * jsonDic = @{
                               @"Account":self.accountTF.text,
                               @"Password":self.passwordTF.text,
                               @"VerifyCode":verify,
                               @"TakeoutType":@(self.type),
                               @"BdToken":bdToken
                               };
    NSLog(@"%@", [jsonDic description]);
    NSString * url = [NSString stringWithFormat:@"%@takeout/TakeoutAuthorizationLogin?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:jsonDic progress:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        
        NSLog(@"%@", responseObject);
        
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            TakeoutAccountModel * model = [[TakeoutAccountModel alloc]init];
            model.accountName = self.accountTF.text;
            model.password = self.passwordTF.text;
            model.typeName = self.typeName;
            
            model.accountNumber = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"AccountNumber"]];
            
            [self storeTakeoutAccount:model];
            
            StoreInformationViewController * storeinfoVC = [[StoreInformationViewController alloc]initWithNibName:@"StoreInformationViewController" bundle:nil];
            storeinfoVC.accountNumber = [[responseObject objectForKey:@"AccountNumber"] integerValue];
            storeinfoVC.type = self.type;
            [self.navigationController pushViewController:storeinfoVC animated:YES];
            
        }else if (code == 1000)
        {
            if ([[responseObject objectForKey:@"MessageVerifyCode"] length] != 0) {
                self.verifyCodeView.hidden = NO;
                self.verifyCodeImageStr = [responseObject objectForKey:@"MessageVerifyCode"];
                [self getVerifyCodeImageWithStr:[responseObject objectForKey:@"MessageVerifyCode"]];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void )storeTakeoutAccount:(TakeoutAccountModel *)model
{
    NSArray * accountArr = [[RCDataBaseManager shareInstance]getTakeoutAccounts];
    for (TakeoutAccountModel * tmodel in accountArr) {
        if ([tmodel.accountName isEqualToString:model.accountName] && [tmodel.typeName isEqualToString:model.typeName]) {
            [[RCDataBaseManager shareInstance]deleteTakeoutAccountWithModel:tmodel];
            break;
        }
    }
    
    [[RCDataBaseManager shareInstance]insertTakeoutAccountModel:model];
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
