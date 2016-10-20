//
//  MeViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MeViewController.h"
#import "ProcessingImagesViewController.h"
#import "MaterialViewController.h"
#import "MeDetailInfomationViewController.h"

#import "EquipmentManagerViewController.h"

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface MeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *coinCountLB;
@property (strong, nonatomic) IBOutlet UILabel *counCountLabel;

@property (strong, nonatomic) IBOutlet UIButton *exitLoginBT;

@property (strong, nonatomic) IBOutlet UIView *equipmentmanagerView;
@property (strong, nonatomic) IBOutlet UIImageView *equipmentImage;
@property (strong, nonatomic) IBOutlet UILabel *equipmentLB;

@property (nonatomic, copy)NSString * iconImageStr;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"navigationlogo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    _iconImageView.userInteractionEnabled = YES;
    [_iconImageView addGestureRecognizer:imageTap];
    
    UITapGestureRecognizer * infoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    _infoView.userInteractionEnabled = YES;
    [_infoView addGestureRecognizer:infoTap];
    
    self.imagePic = [[UIImagePickerController alloc] init];
//    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    self.equipmentImage.userInteractionEnabled = YES;
    self.equipmentLB.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * equipmentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(equipmentAction:)];
    [self.equipmentmanagerView addGestureRecognizer:equipmentTap];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getUserInfo];
        });
    });
    
    // Do any additional setup after loading the view from its nib.
}

- (void)getUserInfo
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    
    __weak MeViewController * infoVC = self;
    [[HDNetworking sharedHDNetworking]getDetailInfor:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
            
            [infoVC refreshUIWithDic:dic];
            
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

- (void)refreshUIWithDic:(NSDictionary *)dic
{
    self.iconImageStr = [dic objectForKey:@"PortraitUri"];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"PortraitUri"]] placeholderImage:[UIImage imageNamed:@"camera_icon.png"]];
    self.userNameLabel.text = [dic objectForKey:@"UserName"];
    self.coinCountLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CoinCount"]];
    self.counCountLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CoinCount"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self getUserInfo1];
}

- (void)getUserInfo1
{
    
    __weak MeViewController * infoVC = self;
    [[HDNetworking sharedHDNetworking]getDetailInfor:nil success:^(id  _Nonnull responseObject) {
    
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
            
            if ([infoVC.iconImageStr isEqualToString:[dic objectForKey:@"PortraitUri"]] && [[NSString stringWithFormat:@"%@", [dic objectForKey:@"CoinCount"]] isEqualToString:infoVC.coinCountLB.text]) {
                ;
            }else
            {
                [infoVC refreshUIWithDic:dic];
            }
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - 选择图片
- (void)changeImageAction:(UITapGestureRecognizer *)sender
{
    if ([sender.view isEqual:_infoView]) {
        MeDetailInfomationViewController * meinfoVC = [[MeDetailInfomationViewController alloc]initWithNibName:@"MeDetailInfomationViewController" bundle:nil];
        meinfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:meinfoVC animated:YES];
    }else
    {
        MaterialViewController * processVC = [[MaterialViewController alloc]init];
        processVC.hidesBottomBarWhenPushed = YES;
        
//        [self.navigationController pushViewController:processVC animated:YES];
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@", [info description]);
    
    self.iconImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    [self uploadImageWithUrlString];
}

- (void)equipmentAction:(UITapGestureRecognizer *)sender
{
    EquipmentManagerViewController * equipmentVC = [[EquipmentManagerViewController alloc]initWithNibName:@"EquipmentManagerViewController" bundle:nil];
    
    equipmentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:equipmentVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitAction:(id)sender {
    
    LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.notAutoLogin = YES;
    // [loginVC defaultLogin];
    // RCDLoginViewController* loginVC = [storyboard
    // instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *_navi =
    [[UINavigationController alloc] initWithRootViewController:loginVC];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = _navi;
    
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
