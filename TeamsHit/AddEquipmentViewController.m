//
//  AddEquipmentViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "AddEquipmentViewController.h"
#import "Scanner.h"
#import "ScannerBorder.h"
#import "ScannerMaskView.h"
#import "AppDelegate.h"
#import "EquipmentTanChuView.h"

/// 控件间距
#define kControlMargin  32.0

@interface AddEquipmentViewController ()
@property (nonatomic, copy) RefreshDeviceList refreshDeviceList;
@property (nonatomic, strong)EquipmentTanChuView * tanchuView;
@end

@implementation AddEquipmentViewController{
    ScannerBorder *scannerBorder;
    Scanner *scanner;
    /// 提示标签
    UILabel *tipLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"添加设备";
    [leftBarItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    [self prepareUI];
    
    // 实例化扫描器
    __weak typeof(self) weakSelf = self;
    scanner = [Scanner scanerWithView:self.view scanFrame:scannerBorder.frame completion:^(NSString *stringValue) {
        
        NSLog(@"扫描结果:%@", stringValue);
        
        // 关闭
        [weakSelf bindEquipmentWithuuid:stringValue];
    }];
    
    
    // Do any additional setup after loading the view.
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)bindEquipmentWithuuid:(NSString *)string
{
    NSArray * uuidArr = [string componentsSeparatedByString:@"?"];
    if (uuidArr.count <= 1) {
        [scanner startScan];
        return;
    }
    
    NSDictionary * jsonDic = @{
                               @"Uuid":uuidArr[1],
                               @"UserFor":@1
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/binddevice?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak AddEquipmentViewController * addVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (command == 10008) {
            if (code == 200) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"绑定成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                addVC.refreshDeviceList();
                [addVC backAction];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                [scanner startScan];
            }
        }else
        {
            ;
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tanchuView = [[EquipmentTanChuView alloc]initWithFrame:[UIScreen mainScreen].bounds andImages:@[@"scan_qr"]];
    [self.tanchuView.removeButton addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    self.tanchuView.detailLabel.text = @"双击按钮\n通过扫描二维码绑定";
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.tanchuView];
    
}
- (void)removeAction
{
    [self.tanchuView removeFromSuperview];
    [scannerBorder startScannerAnimating];
    [scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [scannerBorder stopScannerAnimating];
    [scanner stopScan];
}

#pragma mark - 设置界面
- (void)prepareUI {
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self prepareScanerBorder];
    [self prepareOtherControls];
}
/// 准备提示标签和名片按钮
- (void)prepareOtherControls {
    
    // 1> 提示标签
    tipLabel = [[UILabel alloc] init];
    
    tipLabel.text = @"将二维码/条码放入框中，即可自动扫描";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(scannerBorder.center.x, CGRectGetMaxY(scannerBorder.frame) + kControlMargin);
    
    [self.view addSubview:tipLabel];
    
}

/// 准备扫描框
- (void)prepareScanerBorder {
    
    CGFloat width = self.view.bounds.size.width - 80;
    scannerBorder = [[ScannerBorder alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    
    scannerBorder.center = self.view.center;
    scannerBorder.hd_centerY = self.view.center.y - 64;
    scannerBorder.tintColor = self.navigationController.navigationBar.tintColor;
    
    [self.view addSubview:scannerBorder];
    
    ScannerMaskView *maskView = [ScannerMaskView maskViewWithFrame:self.view.bounds cropRect:scannerBorder.frame];
    [self.view insertSubview:maskView atIndex:0];
}
- (void)refreshDeviceData:(RefreshDeviceList)refreshDeviceData
{
    self.refreshDeviceList = [refreshDeviceData copy];
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
