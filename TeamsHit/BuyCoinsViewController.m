//
//  BuyCoinsViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BuyCoinsViewController.h"
#import <StoreKit/StoreKit.h>
#import "BuyCoinWebViewController.h"

//在内购项目中创的商品单号
#define ProductID_IAP0p6 @"com.xianlin.TeamsHit.6"
#define ProductID_IAP1p18 @"com.xianlin.TeamsHit.18"
#define ProductID_IAP4p30 @"com.xianlin.TeamsHit.30"
#define ProductID_IAP9p88 @"com.xianlin.TeamsHit.88"
#define ProductID_IAP24p388 @"com.xianlin.TeamsHit.388"
#define ProductID_IAP24p588 @"com.xianlin.TeamsHit.588"
enum{IAP0p6=6,
    IAP1p18,
    IAP4p30,
    IAP9p88,
    IAP24p388,
    IAP24p588,
}
buyCoinsTag;

@interface BuyCoinsViewController ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    int buyType;
    MBProgressHUD * hud;
}
@property (strong, nonatomic) IBOutlet UIButton *otherBuyTypeBT;

@end

@implementation BuyCoinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if ([[RCIM sharedRCIM].currentUserInfo.userId isEqualToString:@"160540"]) {
//        self.otherBuyTypeBT.hidden = YES;
//    }
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"碰碰币"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.title = @"购买碰碰币";
    buyType = 0;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSLog(@"IosChecked = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"IosChecked"]);
    
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sixyuanAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IosChecked"] intValue] == 1) {
        [self pushOtherPaytype];
    }else
    {
        
        NSLog(@"6");
        buyType = IAP0p6;
        [self productFunc:ProductID_IAP0p6];
    }
    
}
- (IBAction)eightheenyuanAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IosChecked"] intValue] == 1) {
        [self pushOtherPaytype];
    }else
    {
        
        NSLog(@"18");
        buyType = IAP1p18;
        [self productFunc:ProductID_IAP1p18];
    }
}
- (IBAction)thirtyyuanAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IosChecked"] intValue] == 1) {
        [self pushOtherPaytype];
    }else
    {
        
        NSLog(@"30");
        buyType = IAP4p30;
        [self productFunc:ProductID_IAP4p30];
    }
}
- (IBAction)doubleEightyuanAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IosChecked"] intValue] == 1) {
        [self pushOtherPaytype];
    }else
    {
        
        NSLog(@"88");
        buyType = IAP9p88;
        [self productFunc:ProductID_IAP9p88];
    }
}
- (IBAction)threedoubleeightyuanAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IosChecked"] intValue] == 1) {
        [self pushOtherPaytype];
    }else
    {
        
        NSLog(@"388");
        buyType = IAP24p388;
        [self productFunc:ProductID_IAP24p388];
    }
}
- (IBAction)fivedoubleeightAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IosChecked"] intValue] == 1) {
        [self pushOtherPaytype];
    }else
    {
        
        NSLog(@"588");
        buyType = IAP24p588;
        [self productFunc:ProductID_IAP24p588];
    }
}

- (void)productFunc:(NSString * )productId
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:productId];
    }else
    {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不允许程序内付费购买" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%d",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        switch (buyType) {
                
            case IAP0p6:
                //支付6
                if ([pro.productIdentifier isEqualToString:ProductID_IAP0p6]) {
                    p = pro;
                }
                break;
            case
            IAP1p18:
                if ([pro.productIdentifier isEqualToString:ProductID_IAP1p18]) {
                    p = pro;
                }
                //支付18
                break;
            case
                
            IAP4p30:
                if ([pro.productIdentifier isEqualToString:ProductID_IAP4p30]) {
                    p = pro;
                }
                //支付30
                break;
            case
            IAP9p88:
                if ([pro.productIdentifier isEqualToString:ProductID_IAP9p88]) {
                    p = pro;
                }
                //支付88
                break;
                
            case IAP24p388:
                if ([pro.productIdentifier isEqualToString:ProductID_IAP24p388]) {
                    p = pro;
                }
                //支付388
                break;
            case IAP24p588:
                if ([pro.productIdentifier isEqualToString:ProductID_IAP24p588]) {
                    p = pro;
                }
                //支付388
                break;
            default:
                break;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
     [hud hide:YES];
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
     [hud hide:YES];
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
//                [self completeTransaction:tran];
                NSLog(@"交易完成");
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"交易失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                
            }
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    //交易验证
    // 从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        
    }
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { /* ... Handle error ... */ }
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // Make a connection to the iTunes Store on a background queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   /* ... Handle error ... */
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (jsonResponse) { /* ... Handle error ...*/
                                       NSLog(@"%@", [jsonResponse description]);
                                       if([jsonResponse[@"status"] intValue]==0){
                                           
                                           
                                           NSLog(@"购买成功！");
                                           NSDictionary *dicReceipt= jsonResponse[@"receipt"];
                                           NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
                                           NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
                                           //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
                                           NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                                           if ([productIdentifier isEqualToString:@"123"]) {
//                                               int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
//                                               [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
//                                           }else{
//                                               [defaults setBool:YES forKey:productIdentifier];
//                                           }
                                           //在此处对购买记录进行存储，可以存储到开发商的服务器端
                                       }else{
                                           NSLog(@"购买失败，未通过验证！");
                                       }
                                   
                                   }
                                   /* ... Send a response back to the device ... */
                                   //Parse the Response
                               }
                           }];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
#pragma mark - 其他支付方式
- (IBAction)otherBuytypeAction:(id)sender {
    NSLog(@"其他支付方式");
    BuyCoinWebViewController * buywebVC = [[BuyCoinWebViewController alloc]init];
    
    [self.navigationController pushViewController:buywebVC animated:NO];
}

- (void)pushOtherPaytype
{
    NSLog(@"其他支付方式");
    BuyCoinWebViewController * buywebVC = [[BuyCoinWebViewController alloc]init];
    
    [self.navigationController pushViewController:buywebVC animated:NO];
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
