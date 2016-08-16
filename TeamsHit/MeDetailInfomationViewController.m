//
//  MeDetailInfomationViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MeDetailInfomationViewController.h"

@interface MeDetailInfomationViewController ()
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *completeBT;

@end

@implementation MeDetailInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"个人资料"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    [self getUserInfo];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUserInfo
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/getDetailInfor?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak MeDetailInfomationViewController * infoVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:nil progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            [infoVC.iconImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"PortraitUri"]] placeholderImage:[UIImage imageNamed:@"camera_icon.png"]];
            infoVC.userNameLabel.text = [responseObject objectForKey:@"UserName"];
            infoVC.genderLabel.text = [responseObject objectForKey:@"Gender"];
            infoVC.addressLabel.text = [responseObject objectForKey:@"City"];
            
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
