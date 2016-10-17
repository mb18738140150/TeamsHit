//
//  ConfigurationWiFiViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/30.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ConfigurationWiFiViewController.h"
#include <mach/mach.h>
#import "ConfigurationWiFiSecondViewController.h"
#import "EquipmentTanChuView.h"
#import "AppDelegate.h"


@interface ConfigurationWiFiViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *wifiNameLb;
@property (strong, nonatomic) IBOutlet UITextField *wifiPasswordTF;
@property (strong, nonatomic) IBOutlet UIButton *matchBT;

@property (nonatomic, strong)EquipmentTanChuView * tanchuView;
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
    
//    NSDictionary * ssiddic = [self getSCdata:str];
//    NSLog(@"ssiddic = %@", ssiddic);
    
    NSMutableArray * imageArr = [NSMutableArray array];
    for (int i = 1; i < 14; i++) {
        NSString * imageStr = nil;
        if (i < 10) {
            imageStr = [NSString stringWithFormat:@"wifi_paring_0%d", i];
        }else
        {
            imageStr = [NSString stringWithFormat:@"wifi_paring_%d", i];
        }
        [imageArr addObject:imageStr];
    }
    if (self.isEquipmentManagerVc) {
        self.tanchuView = [[EquipmentTanChuView alloc]initWithFrame:[UIScreen mainScreen].bounds andImages:imageArr];
        [self.tanchuView.removeButton addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
        self.tanchuView.detailLabel.text = @"长按按键6s\n进入WiFi智能配置模式";
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:self.tanchuView];
    }
}

- (void)removeAction
{
    [self.tanchuView removeFromSuperview];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)configurationWLAN:(id)sender {
    
    if (!self.myPassword || self.myPassword.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else
    {
        
        ConfigurationWiFiSecondViewController * secondVC = [[ConfigurationWiFiSecondViewController alloc]initWithNibName:@"ConfigurationWiFiSecondViewController" bundle:nil];
        secondVC.myssid = self.myssid;
        secondVC.myPassword = self.myPassword;
        [self.navigationController pushViewController:secondVC animated:YES];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"界面消失了");
    self.isEquipmentManagerVc = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"界面出现了");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"结束编辑");
    self.myPassword = textField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define kMachPortConfigd "com.apple.SystemConfiguration.configd"
//@«Setup:/Network/Interface/en0/AirPort»
//-(NSDictionary *)getSCdata:(NSString *)key
//{
//    key = @"State:/Network/Global/DNS";// ServerAddresses
//    key = @"Setup:/Network/Interface/en0/AirPort"; // JoinModel
//    key = @"State:/Network/Interface/en0/CaptiveNetwork";
//    key = @"State:/IOKit/PowerManagement/CurrentSettings";
//    key = @"State:/IOKit/PowerManagement/SystemLoad/Detailed";/*{
//                                                               BatteryLevel = 3,
//                                                               UserLevel = 3,
//                                                               ThermalLevel = 3,
//                                                               CombinedLevel = 3
//                                                               }*/
//    key = @"State:/Network/Global/Proxies";/*{
//                                            __SCOPED__ = {
//                                            en0 = {
//                                            FTPPassive = 1,
//                                            ExceptionsList = [
//                                            *.local,
//                                            169.254/16
//                                            ]
//                                            }
//                                            },
//                                            FTPPassive = 1,
//                                            ExceptionsList = [
//                                            *.local,
//                                            169.254/16
//                                            ]
//                                            }*/
//    key = @"Setup:/Network/Interface/en0/AirPort";
//    
//    struct send_body {mach_msg_header_t header; int count; UInt8 *addr; CFIndex size0; int flags; NDR_record_t ndr; CFIndex size; int retB; int rcB; int f24; int f28;};
//    
//    mach_port_t bootstrapport = MACH_PORT_NULL;
//    mach_port_t configport = MACH_PORT_NULL;
//    mach_msg_header_t *msg;
//    mach_msg_return_t msg_return;
//    struct send_body send_msg;
//    // Make request
//    CFDataRef  extRepr;
//    extRepr = CFStringCreateExternalRepresentation(NULL, (__bridge CFStringRef)(key), kCFStringEncodingUTF8, 0);
//    
//    // Connect to Mach MIG port of configd
//    task_get_bootstrap_port(mach_task_self(), &bootstrapport);
//    bootstrap_look_up2(bootstrapport, kMachPortConfigd, &configport, 0, 8LL);
//    // Make request
//    
//    send_msg.count = 1;
//    send_msg.addr = (UInt8*)CFDataGetBytePtr(extRepr);
//    send_msg.size0 = CFDataGetLength(extRepr);
//    send_msg.size = CFDataGetLength(extRepr);
//    send_msg.flags = 0x1000100u;
//    send_msg.ndr = NDR_record;
//    
//    // Make message header
//    
//    msg = &(send_msg.header);
//    msg->msgh_bits = 0x80001513u;
//    msg->msgh_remote_port = configport;
//    msg->msgh_local_port = mig_get_reply_port();
//    msg->msgh_id = 20010;
//    // Request server
//    msg_return = mach_msg(msg, 3, 0x34u, 0x44u, msg->msgh_local_port, 0, 0);
//    if(msg_return)
//    {
//        if (msg_return - 0x10000002u >= 2 && msg_return != 0x10000010 )
//        {
//            mig_dealloc_reply_port(msg->msgh_local_port);
//        }
//        else
//        {
//            mig_put_reply_port(msg->msgh_local_port);
//        }
//    }
//    else if ( msg->msgh_id != 71 && msg->msgh_id == 20110 && msg->msgh_bits <= -1 )
//    {
//        if ((send_msg.flags & 0xFF000000) == 0x1000000)
//        {
//            CFDataRef deserializedData = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, send_msg.addr,send_msg.size0, kCFAllocatorNull);
//            CFPropertyListRef proplist = CFPropertyListCreateWithData(kCFAllocatorDefault, deserializedData, kCFPropertyListImmutable, NULL, NULL);
//            mig_dealloc_reply_port(msg->msgh_local_port);
//            mach_port_deallocate(mach_task_self(), bootstrapport);
//            mach_port_deallocate(mach_task_self(), configport);
//            mach_msg_destroy(msg);
//            NSDictionary *property_list = (__bridge NSDictionary*)proplist;
//            if(proplist)
//                CFRelease(proplist);
//            CFRelease(deserializedData);
//            CFRelease(extRepr);
//            return property_list;
//        }
//    }
//    mig_dealloc_reply_port(msg->msgh_local_port);
//    mach_port_deallocate(mach_task_self(), bootstrapport);
//    mach_port_deallocate(mach_task_self(), configport);
//    mach_msg_destroy(msg);
//    CFRelease(extRepr);
//    return nil;
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
