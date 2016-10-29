//
//  ConfigurationWiFiSecondViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ConfigurationWiFiSecondViewController.h"
NSString *const kNetChangedNotification = @"kNetChangedNotification";
@interface ConfigurationWiFiSecondViewController ()
@property (strong, nonatomic) IBOutlet UILabel *WiFiNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *configurationBT;

@end

@implementation ConfigurationWiFiSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"配置WiFi第二步";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:kNetChangedNotification object:nil];
    
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
    NSLog(@"%@  ** SSIDDATA = %@", [[dic objectForKey:@"SSIDDATA"] class], [data description]);
    if ([self.WiFiNameLabel.text containsString:@"YunPrinter"]) {
        [self.configurationBT setTitle:@"开始配置" forState:UIControlStateNormal];
    }
}

- (void)netChange:(NSNotification *)notiInfo
{
    NSLog(@"收到通知，从新获取ssid");
    NSString * str = [NSString SSID];
//    NSDictionary * dic = [NSString SSIDInfo];
    
    self.WiFiNameLabel.text = [NSString stringWithFormat:@"当前WLAN:%@", str];
    if ([self.WiFiNameLabel.text containsString:@"YunPrinter"]) {
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
        NSDictionary * dic = @{@"ssid":self.myssid, @"security":@4, @"key":self.myPassword, @"ip":@0};
        NSString * jsonStr = [dic JSONString];
        
        [self post:@"http://192.168.10.1/sys/network" HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)post:(NSString *)urlString HTTPBody:(NSData *)body
{
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
                }else
                {
                    NSLog(@"***error = %@", errpr);
                }
            });
        }
    }];
    
    [task resume];
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
