//
//  SetUpViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SetUpViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"
#import "ModifyPasswordViewController.h"
@interface SetUpViewController ()
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UIButton *voiceBT;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"设置";
    [self.voiceBT setImage:[[UIImage imageNamed:@"forbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.voiceBT setImage:[[UIImage imageNamed:@"noForbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
   
    [[RCIMClient sharedRCIMClient] getNotificationQuietHours:^(NSString *startTime, int spansMin) {
        
        NSLog(@"开始时间 %@, %d", startTime, spansMin);
        if (spansMin != 0) {
            NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
            
            fomatter.dateFormat = @"HH:MM:SS";
            
            NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
            NSString * currentStr = [fomatter stringFromDate:currentDate];
            NSDate * currentDate1 = [fomatter dateFromString:currentStr];
            
            NSDate * startDate = [fomatter dateFromString:startTime];
            NSTimeInterval time = [currentDate1 timeIntervalSinceDate:startDate];
            
            if (time / 60 > spansMin) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _voiceBT.selected = NO;
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _voiceBT.selected = YES;
                });
            }
        }else
        {
            _voiceBT.selected = NO;
        }
        
    } error:^(RCErrorCode status) {
        ;
    }];
    
    
    
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}
- (IBAction)voiceAction:(id)sender {
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSData * data1 = UIImagePNGRepresentation(_voiceBT.currentImage);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"noForbid"]);
    if (!_voiceBT.selected) {
       
       
        
        NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
        fomatter.dateFormat = @"HH:MM:SS";
        
        NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSString * timeStr = [fomatter stringFromDate:currentDate];
        timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"00"];
        
        [[RCIMClient sharedRCIMClient] setNotificationQuietHours:timeStr spanMins:1439 success:^{
            NSLog(@"开启");
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                _voiceBT.selected = !_voiceBT.selected;
            });
        } error:^(RCErrorCode status) {
            NSLog(@"开启错误");
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"设置失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
            });
        }];
    }else
    {
       [[RCIMClient sharedRCIMClient] removeNotificationQuietHours:^{
           NSLog(@"关闭");
           dispatch_async(dispatch_get_main_queue(), ^{
               [hud hide:YES];
               _voiceBT.selected = !_voiceBT.selected;
           });
       } error:^(RCErrorCode status) {
           NSLog(@"关闭错误");
           dispatch_async(dispatch_get_main_queue(), ^{
               [hud hide:YES];
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"设置失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
               [alert show];
           });
       }];
        
    }
    
}

- (IBAction)loginOutAction:(id)sender {
    LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];

    UINavigationController *_navi =
    [[UINavigationController alloc] initWithRootViewController:loginVC];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = _navi;
    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
}
- (IBAction)aboutUsAction:(id)sender {
    AboutUsViewController * aboutVc = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
    
    [self.navigationController pushViewController:aboutVc animated:YES];
}
- (IBAction)modifyPassword:(id)sender {
    
    ModifyPasswordViewController * modifyVC = [[ModifyPasswordViewController alloc]initWithNibName:@"ModifyPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:modifyVC animated:YES];
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
