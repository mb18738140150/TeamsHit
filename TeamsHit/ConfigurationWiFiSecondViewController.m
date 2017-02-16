//
//  ConfigurationWiFiSecondViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ConfigurationWiFiSecondViewController.h"

#define GETNetStatusTime 2
#define GETNETstatus_separatrTime 3

NSString *const kNetChangedNotification = @"kNetChangedNotification";
@interface ConfigurationWiFiSecondViewController ()
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UILabel *WiFiNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *configurationBT;
@property (nonatomic, assign)int  getNetStatustime;
@property (nonatomic, assign)int security;

@end

@implementation ConfigurationWiFiSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"配置WiFi第二步";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:kNetChangedNotification object:nil];
    _security = 4;
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString * str = [NSString SSID];
    NSDictionary * dic = [NSString SSIDInfo];
    
    self.WiFiNameLabel.text = [NSString stringWithFormat:@"当前WLAN:%@", str];
    self.myssid = str;
    NSData * data = [dic objectForKey:@"SSIDDATA"];
    NSLog(@"SSIDInfo = %@", dic);
    NSLog(@"%@  ** SSIDDATA = %@", [[dic objectForKey:@"SSIDDATA"] class], [data description]);
    if ([self.WiFiNameLabel.text containsString:@"Mstching"] || [self.WiFiNameLabel.text containsString:@"YunPrinter"]) {
        [self.configurationBT setTitle:@"开始配置" forState:UIControlStateNormal];
    }
}

- (void)netChange:(NSNotification *)notiInfo
{
    NSLog(@"收到通知，从新获取ssid");
    NSString * str = [NSString SSID];
//    NSDictionary * dic = [NSString SSIDInfo];
    
    self.WiFiNameLabel.text = [NSString stringWithFormat:@"当前WLAN:%@", str];
    if ([self.WiFiNameLabel.text containsString:@"Mstching"] || [self.WiFiNameLabel.text containsString:@"YunPrinter"]) {
        [self.configurationBT setTitle:@"开始配置" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)configurationWiFiAction:(id)sender {
    
    if ([self.configurationBT.titleLabel.text isEqualToString:@"去配置WLAN"]) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
//        NSURL * url = [NSURL URLWithString:@"prefs:root=WIFIINTERNET_TETHERING"];
//        if ([[UIApplication sharedApplication]canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
        
    }else
    {
        NSLog(@"开始配置");
        NSDictionary * dic = @{@"ssid":self.myssid, @"security":@(_security), @"key":self.myPassword, @"ip":@0};
        NSString * jsonStr = [dic JSONString];
        hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"配置中";
        [hud show:YES];
        [self post:@"http://192.168.10.1/sys/network" HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)post:(NSString *)urlString HTTPBody:(NSData *)body
{
    __weak ConfigurationWiFiSecondViewController * weakSelf = self;
    
    NSString * newUrlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:newUrlStr];
    NSLog(@"urlStr = %@", urlString);
    // 创建请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    // 和服务器建立异步联接
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            if (error.code == -1009) {
                ;
            }
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (weakSelf.security == 0) {
                    [hud hide:YES];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
                    [alert show];
                    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                }else
                {
                    NSDictionary * dic = @{@"ssid":weakSelf.myssid, @"security":@(weakSelf.security), @"key":weakSelf.myPassword, @"ip":@0};
                    NSString * jsonStr = [dic JSONString];
                    [weakSelf post:@"http://192.168.10.1/sys/network" HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
            });
            NSLog(@"++++++=%@", error);
        }else
        {
            NSLog(@"data = %@", data);
            NSError *errpr = nil;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errpr];
            //            NSLog(@"*****%@", [dic description]);
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                
                if (dic != nil) {
                    NSLog(@"dic = %@", dic);
                    
                    if ([[dic objectForKey:@"success"] intValue] == 0) {
                        
                        NSLog(@"weakSelf.security = %d", weakSelf.security);
                        
//                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
//                        [alert show];
//                        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
//                        [weakSelf performSelector:@selector(popToEquipmentViewcontroller) withObject:nil afterDelay:.8];
                        [weakSelf getnetStatus];
                    }else
                    {
                        if (weakSelf.security == 0) {
                            [hud hide:YES];
                            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
                            [alert show];
                            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                            [weakSelf performSelector:@selector(popToEquipmentViewcontroller) withObject:nil afterDelay:.8];
                        }else
                        {
                            NSDictionary * dic = @{@"ssid":weakSelf.myssid, @"security":@(weakSelf.security), @"key":weakSelf.myPassword, @"ip":@0};
                            NSString * jsonStr = [dic JSONString];
                            [weakSelf post:@"http://192.168.10.1/sys/network" HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
                        }
                    }
                    
                }else
                {
                    if (weakSelf.security == 0) {
                        [hud hide:YES];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
                        [alert show];
                        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                    }else
                    {
                        NSDictionary * dic = @{@"ssid":weakSelf.myssid, @"security":@(weakSelf.security), @"key":weakSelf.myPassword, @"ip":@0};
                        NSString * jsonStr = [dic JSONString];
                        [weakSelf post:@"http://192.168.10.1/sys/network" HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                }
                
            });
        }
        
    }];
    
    [task resume];
}

- (void)getnetStatus
{
    __weak ConfigurationWiFiSecondViewController * weakSelf = self;
    NSString *urlString = @"http://192.168.10.1/sys";
    NSString * newUrlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:newUrlStr];
    NSLog(@"urlStr = %@", urlString);
    // 创建请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    // 和服务器建立异步联接
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        weakSelf.getNetStatustime++;
        if (error) {
            
            if (error.code == -1009) {
                ;
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (weakSelf.getNetStatustime == GETNetStatusTime) {
                    [hud hide:YES];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
                    [alert show];
                    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                    [weakSelf performSelector:@selector(popToEquipmentViewcontroller) withObject:nil afterDelay:.8];
                }else if (weakSelf.getNetStatustime < GETNetStatusTime)
                {
                    [weakSelf performSelector:@selector(getnetStatus) withObject:nil afterDelay:GETNETstatus_separatrTime];
                }
            });
            NSLog(@"++++++=%@", error);
        }else
        {
            NSLog(@"data = %@", data);
            NSError *errpr = nil;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errpr];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (dic != nil) {
                    NSLog(@"dic = %@", dic);
                    
                    if ([[[[dic objectForKey:@"connection"] objectForKey:@"station"] objectForKey:@"status"] intValue] == 2) {
                        [hud hide:YES];
                        
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
                        [alert show];
                        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                        [weakSelf performSelector:@selector(popToEquipmentViewcontroller) withObject:nil afterDelay:.8];
                        // 配置成功，将当前的WiFi名称及密码保存到本地；
                        [[NSUserDefaults standardUserDefaults]setObject:self.myPassword forKey:self.myssid];
                        
                    }else
                    {
                        if (weakSelf.getNetStatustime == GETNetStatusTime) {
                            NSLog(@"weakSelf.getNetStatustime = %d", weakSelf.getNetStatustime);
                            
                            weakSelf.getNetStatustime = 0;
                            if (weakSelf.security == 0) {
                                [hud hide:YES];
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
                                [alert show];
                                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                                [weakSelf performSelector:@selector(popToEquipmentViewcontroller) withObject:nil afterDelay:.8];
                            }else
                            {
                                NSDictionary * dic = @{@"ssid":weakSelf.myssid, @"security":@(weakSelf.security--), @"key":weakSelf.myPassword, @"ip":@0};
                                NSString * jsonStr = [dic JSONString];
                                [weakSelf post:@"http://192.168.10.1/sys/network" HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
                            }
                            
                        }else if (weakSelf.getNetStatustime < GETNetStatusTime)
                        {
                            [weakSelf performSelector:@selector(getnetStatus) withObject:nil afterDelay:GETNETstatus_separatrTime];
                        }
                    }
                    
                }else
                {
                    NSLog(@"***error = %@", errpr);
                    if (weakSelf.getNetStatustime == GETNetStatusTime) {
                        [hud hide:YES];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"配置失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
                        [alert show];
                        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                        [weakSelf performSelector:@selector(popToEquipmentViewcontroller) withObject:nil afterDelay:.8];
                    }else if (weakSelf.getNetStatustime < GETNetStatusTime)
                    {
                        [weakSelf performSelector:@selector(getnetStatus) withObject:nil afterDelay:GETNETstatus_separatrTime];
                    }
                }
            });
        }
    }];
    
    [task resume];
}

- (void)popToEquipmentViewcontroller
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNetChangedNotification object:nil];
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
