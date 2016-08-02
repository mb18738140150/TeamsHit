//
//  ConfigurationWiFiViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ConfigurationWiFiViewController.h"
#include <mach/mach.h>
#include "autoconf.h"


status = configget(storePrivate->server,
                   myKeyRef,
                   myKeyLen,
                   &xmlDataRef,
                   (int *)&xmlDataLen,
                   &newInstance,
                   (int *)&sc_status);

routine configget	(	server		: mach_port_t;
                     key		: xmlData;
                     out	data		: xmlDataOut, dealloc;
                     out	newInstance	: int;
                     out	status		: int);

NSString *const kNetChangedNotification = @"kNetChangedNotification";

@interface ConfigurationWiFiViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *wifiNameLb;
@property (strong, nonatomic) IBOutlet UITextField *wifiPasswordTF;
@property (strong, nonatomic) IBOutlet UIButton *matchBT;

@property (nonatomic, copy)NSString * myssid;
@property (nonatomic, copy)NSString * myPassword;

@end

@implementation ConfigurationWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"配置WiFi"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.matchBT.layer.cornerRadius = 2;
    self.matchBT.layer.masksToBounds = YES;
    
//    [self.matchBT setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.matchBT.enabled = NO;
    self.matchBT.backgroundColor = [UIColor grayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:kNetChangedNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString * str = [NSString SSID];
    NSDictionary * dic = [NSString SSIDInfo];
    
    self.wifiNameLb.text = [NSString stringWithFormat:@"%@", str];
    self.myssid = str;
    NSData * data = [dic objectForKey:@"SSIDDATA"];
    NSLog(@"%@  ** SSIDDATA = %@", [[dic objectForKey:@"SSIDDATA"] class], [data description]);
    if ([self.wifiNameLb.text containsString:@"memobird"]) {
        [self.matchBT setTitle:@"开始配置" forState:UIControlStateNormal];
    }
    
    NSDictionary * ssiddic = [self getSCdata:str];
    NSLog(@"ssiddic = %@", ssiddic);

}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)netChange:(NSNotification *)notiInfo
{
    NSLog(@"收到通知，从新获取ssid");
    NSString * str = [NSString SSID];
    NSDictionary * dic = [NSString SSIDInfo];
    
    self.wifiNameLb.text = [NSString stringWithFormat:@"%@", str];
    if ([self.wifiNameLb.text containsString:@"memobird"]) {
        [self.matchBT setTitle:@"开始配置" forState:UIControlStateNormal];
    }
    
}

- (IBAction)configurationWLAN:(id)sender {
    
    if (!self.myPassword || self.myPassword.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else
    {
        
        if ([self.matchBT.titleLabel.text isEqualToString:@"去配置WLAN"]) {
            NSURL * url = [NSURL URLWithString:@"prefs:root=WIFI"];
            
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }else
        {
            NSLog(@"开始配置");
            NSDictionary * dic = @{@"ssid":self.myssid, @"security":@4, @"key":self.myPassword, @"ip":@0};
            NSString * jsonStr = [dic JSONString];
            
            [self post:@"http://192.168.10.1/sys/network" HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
            
            //        [[HDNetworking sharedHDNetworking]POSTwithWiFi:@"http://192.168.10.1/sys/network" parameters:jsonStr progress:nil success:^(id  _Nonnull responseObject) {
            //            NSLog(@"responseObject = %@", responseObject);
            //        } failure:^(NSError * _Nonnull error) {
            //             NSLog(@"error = %@", error);
            //        }];
        }
    }
    
}


- (void)post:(NSString *)urlString HTTPBody:(NSData *)body
{

    /*
     stringByAddingPercentEscapesUsingEncoding(只对 `#%^{}[]|\"<> 加空格共14个字符编码，不包括”&?”等符号), ios9将淘汰，建议用stringByAddingPercentEncodingWithAllowedCharacters方法
     
     URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
     
     URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
     
     URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
     
     URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
     
     URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
     
     URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
     */
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

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"界面消失了");
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"界面出现了");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"结束编辑");
    self.myPassword = textField.text;
    if (self.myPassword.length != 0) {
        self.matchBT.enabled = YES;
        self.matchBT.backgroundColor = UIColorFromRGB(0x12B7F5);
    }else
    {
        self.matchBT.enabled = NO;
        self.matchBT.backgroundColor = [UIColor grayColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNetChangedNotification object:nil];
}


#define kMachPortConfigd "com.apple.SystemConfiguration.configd"
//@«Setup:/Network/Interface/en0/AirPort»
-(NSDictionary *)getSCdata:(NSString *)key
{
    
    struct send_body {mach_msg_header_t header; int count; UInt8 *addr; CFIndex size0; int flags; NDR_record_t ndr; CFIndex size; int retB; int rcB; int f24; int f28;};
    
    mach_port_t bootstrapport = MACH_PORT_NULL;
    mach_port_t configport = MACH_PORT_NULL;
    mach_msg_header_t *msg;
    mach_msg_return_t msg_return;
    struct send_body send_msg;
    // Make request
    CFDataRef  extRepr;
    extRepr = CFStringCreateExternalRepresentation(NULL, (__bridge CFStringRef)(key), kCFStringEncodingUTF8, 0);
    
    // Connect to Mach MIG port of configd
    task_get_bootstrap_port(mach_task_self(), &bootstrapport);
    bootstrap_look_up2(bootstrapport, kMachPortConfigd, &configport, 0, 8LL);
    // Make request
    
    send_msg.count = 1;
    send_msg.addr = (UInt8*)CFDataGetBytePtr(extRepr);
    send_msg.size0 = CFDataGetLength(extRepr);
    send_msg.size = CFDataGetLength(extRepr);
    send_msg.flags = 0x1000100u;
    send_msg.ndr = NDR_record;
    
    // Make message header
    
    msg = &(send_msg.header);
    msg->msgh_bits = 0x80001513u;
    msg->msgh_remote_port = configport;
    msg->msgh_local_port = mig_get_reply_port();
    msg->msgh_id = 20010;
    // Request server
    msg_return = mach_msg(msg, 3, 0x34u, 0x44u, msg->msgh_local_port, 0, 0);
    if(msg_return)
    {
        if (msg_return - 0x10000002u >= 2 && msg_return != 0x10000010 )
        {
            mig_dealloc_reply_port(msg->msgh_local_port);
        }
        else
        {
            mig_put_reply_port(msg->msgh_local_port);
        }
    }
    else if ( msg->msgh_id != 71 && msg->msgh_id == 20110 && msg->msgh_bits <= -1 )
    {
        if ((send_msg.flags & 0xFF000000) == 0x1000000)
        {
            CFDataRef deserializedData = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, send_msg.addr,send_msg.size0, kCFAllocatorNull);
            CFPropertyListRef proplist = CFPropertyListCreateWithData(kCFAllocatorDefault, deserializedData, kCFPropertyListImmutable, NULL, NULL);
            mig_dealloc_reply_port(msg->msgh_local_port);
            mach_port_deallocate(mach_task_self(), bootstrapport);
            mach_port_deallocate(mach_task_self(), configport);
            mach_msg_destroy(msg);
            NSDictionary *property_list = (__bridge NSDictionary*)proplist;
            if(proplist)
                CFRelease(proplist);
            CFRelease(deserializedData);
            CFRelease(extRepr);
            return property_list;
        }
    }
    mig_dealloc_reply_port(msg->msgh_local_port);
    mach_port_deallocate(mach_task_self(), bootstrapport);
    mach_port_deallocate(mach_task_self(), configport);
    mach_msg_destroy(msg);
    CFRelease(extRepr);
    return nil;
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
