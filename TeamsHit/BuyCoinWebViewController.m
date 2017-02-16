//
//  BuyCoinWebViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BuyCoinWebViewController.h"
#import <WebKit/WebKit.h>
#import "WXApi.h"
#import "WXApiManager.h"

@interface BuyCoinWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, WXApiManagerDelegate>
{
    MBProgressHUD* hud ;
    WKWebView *webView;
}
@property (nonatomic, strong)UIProgressView * progressView;
@property (nonatomic, copy)NSString * orderId;

@end

@implementation BuyCoinWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"购买碰碰币";
    
    [WXApiManager sharedManager].delegate = self;
    
    // 创建配置类
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    config.preferences = [[WKPreferences alloc]init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    //配置web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc]init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
    
    // 1.创建webview，并设置大小，"20"为状态栏高度
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) configuration:config];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://www.wap.mstching.com/account/applogin?username=%@&password=%@&backurl=/usercenter/buycoin?from=app",[[NSUserDefaults standardUserDefaults] objectForKey:@"AccountNumber"], [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]];
    
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    // 3.加载网页
    [webView loadRequest:request];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;

    // 最后将webView添加到界面
    [self.view addSubview:webView];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, 1)];
    self.progressView.tintColor = MAIN_COLOR;
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
    
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [hud hide:YES];
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - WKScriptMessageHandler
// 当JS通过AppModel发送数据到iOS端时，会在代理中收到：
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"AppModel"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSString * orderId = [message.body objectForKey:@"body"];
        self.orderId = orderId;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestOrderInformation:orderId];
        });
        
    }
}

- (void)requestOrderInformation:(NSString *)orderId
{
    NSLog(@"orderId = %@", orderId);
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    NSDictionary *requestContents = @{
                                      @"OrderId":orderId
                                      };
    NSLog(@" jsonDic = %@", requestContents);
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/WeChatPay?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:requestContents progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [responseObject objectForKey:@"AppId"];
            req.partnerId           = [responseObject objectForKey:@"PartnerId"];
            req.prepayId            = [responseObject objectForKey:@"PrepayId"];
            req.nonceStr            = [responseObject objectForKey:@"NonceStr"];
            req.timeStamp           = [[responseObject objectForKey:@"TimeStamp"] intValue];
            req.package             = [responseObject objectForKey:@"Package"];
            req.sign                = [responseObject objectForKey:@"Sign"];
            [WXApi sendReq:req];
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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"****%f", webView.estimatedProgress);;
    if (object == webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        [hud hide:YES];
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidPaySuccess:(PayResp *)response
{
    switch (response.errCode) {
        case WXSuccess:
        {
            NSString * urlStr = [NSString stringWithFormat:@"http://www.wap.mstching.com/paycallback/returnurl?out_trade_no=%@&trade_status=%@",self.orderId, @"TRADE_SUCCESS"];
            NSLog(@"success urlStr = %@", urlStr);
            
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [webView loadRequest:request];
        }
            break;
            
        default:
        {
            NSString * urlStr = [NSString stringWithFormat:@"http://www.wap.mstching.com/paycallback/returnurl?out_trade_no=%@&trade_status=%@",self.orderId, @"TRADE_FAIL"];
            NSLog(@"success urlStr = %@", urlStr);
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [webView loadRequest:request];
        }
            break;
    }
}

- (void)dealloc {
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
