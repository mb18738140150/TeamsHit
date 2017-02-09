//
//  AboutUsViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ChatViewController.h"
#import "NormalProblemViewController.h"

@interface AboutUsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"关于对对碰";
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)nomalProblemAction:(id)sender {
    NSLog(@"常见问题");
    NormalProblemViewController * normalVC = [[NormalProblemViewController alloc]init];
    [self.navigationController pushViewController:normalVC animated:YES];
    
}
- (IBAction)onlineServer:(id)sender {
    NSLog(@"在线客服");
    ChatViewController * chatVc = [[ChatViewController alloc]init];
    chatVc.hidesBottomBarWhenPushed = YES;
    chatVc.conversationType = ConversationType_PRIVATE;
    chatVc.displayUserNameInCell = NO;
    chatVc.targetId = @"200";
    chatVc.title = @"在线客服";
    chatVc.enableNewComingMessageIcon=YES;//开启消息提醒
    chatVc.enableUnreadMessageIcon=YES;
    
    [self.navigationController pushViewController:chatVc animated:YES];
}
- (IBAction)serverPhonenumber:(id)sender {
    NSLog(@"客服电话%@", [NSString stringWithFormat:@"%@", self.phoneNumberLabel.text]);
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneNumberLabel.text]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
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
