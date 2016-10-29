//
//  CoindetailViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CoindetailViewController.h"
#import "BuyCoinsViewController.h"
#import "PayHistoryViewController.h"
#import "TradedetailViewController.h"

@interface CoindetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *coinCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyCoinBT;
@property (nonatomic, copy)BuyCoinsBlock myBlock;


@end

@implementation CoindetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"碰碰币";
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"点点"]];
    [rightBarItem addTarget:self action:@selector(buyCoinhistoryAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    self.coinCountLabel.text = [NSString stringWithFormat:@"￥%@", self.cointCount];
}
- (void)backAction:(UIButton *)button
{
    if (self.myBlock) {
        _myBlock(self.coinCountLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
//    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)buyCoinhistoryAction:(UIButton *)button
{
    NSLog(@"充值记录");
    
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * payhistoryaction = [UIAlertAction actionWithTitle:@"购买记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"购买记录");
        PayHistoryViewController * payVc = [[PayHistoryViewController alloc]init];
        
        [self.navigationController pushViewController:payVc animated:YES];
    }];
    
    UIAlertAction * coindetailAction = [UIAlertAction actionWithTitle:@"交易明细" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"交易明细");
        TradedetailViewController * payVc = [[TradedetailViewController alloc]init];
        
        [self.navigationController pushViewController:payVc animated:YES];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    
    [alertcontroller addAction:payhistoryaction];
    [alertcontroller addAction:coindetailAction];
    [alertcontroller addAction:cancelAction];
    
    [self presentViewController:alertcontroller animated:YES completion:^{
        ;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buycoinAction:(id)sender {
    NSLog(@"充值");
    BuyCoinsViewController * buyVC = [[BuyCoinsViewController alloc]initWithNibName:@"BuyCoinsViewController" bundle:nil];
    __weak CoindetailViewController * weakSelf = self;
    [buyVC haveBuyCoins:^(BOOL haveBuy) {
        if (haveBuy) {
            [weakSelf reloadData];
        }
    }];
    [self.navigationController pushViewController:buyVC animated:YES];
}

- (void)reloadData
{
        
        __weak CoindetailViewController * weakSelf = self;
        [[HDNetworking sharedHDNetworking]getDetailInfor:nil success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
                
                 weakSelf.coinCountLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CoinCount"]];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}

- (void)BuyCoins:(BuyCoinsBlock)block
{
    self.myBlock = [block copy];
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
