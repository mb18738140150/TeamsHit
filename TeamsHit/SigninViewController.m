//
//  SigninViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/1.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "SigninViewController.h"

#import "SigninView.h"
#import "SigninModel.h"

@interface SigninViewController ()
{
    MBProgressHUD *hud;
}
@property (strong, nonatomic) IBOutlet SigninView *signinDateView;
@property (nonatomic, strong) UIColor * color;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLB;
@property (strong, nonatomic) IBOutlet UILabel *coinCountLB;
@property (strong, nonatomic) IBOutlet UIButton *signinBT;

@property (nonatomic, strong)NSMutableArray * dataArr;

@end

@implementation SigninViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"签到" titleColor:[UIColor whiteColor]];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
//    self.title = @"签到";
    
    [self.signinDateView prepareUI];
    
    self.iconImageView.image = self.iconImage;
    self.userNameLB.text = self.userName;
    self.coinCountLB.attributedText = [self getCoinCount:[NSString stringWithFormat:@"%d碰碰币", self.coinCount]];
    
    [self getSigninRecord];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x12B7F5)];
}

- (NSMutableAttributedString *)getCoinCount:(NSString *)str
{
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0xF8B551)};
    [mStr setAttributes:attribute range:NSMakeRange(0, str.length - 3)];
    return mStr;
}

- (void)getSigninRecord
{
    __weak SigninViewController * weakSelf = self;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/SignRecord?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking]GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [hud hide:YES];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            NSArray * arr = [responseObject objectForKey:@"SignList"];
            
            for (NSDictionary * dic in arr) {
                SigninModel * model = [[SigninModel alloc]initWithDic:dic];
                
                if (model.MonthToDay == [[self getNowDate] intValue]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.signinBT setTitle:[NSString stringWithFormat:@"已连续签到%d天", model.conSignDay] forState:UIControlStateNormal];
                        weakSelf.signinBT.enabled = NO;
                    });
                }
                
                [weakSelf.dataArr addObject:model];
            }
            weakSelf.signinDateView.dataArr = weakSelf.dataArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.signinDateView.dateCollectionView reloadData];
            });
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }];

}

#pragma mark - signin

- (IBAction)signinAction:(id)sender {
    
//    UIButton * button = (UIButton *)sender;
//    if (![button.titleLabel.text isEqualToString:@"立即签到"]) {
//        return;
//    }
    
    __weak SigninViewController * weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@userinfo/Sign?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:nil progress:nil success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [hud hide:YES];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            int coinCount = [[responseObject objectForKey:@"CoinCount"] intValue];
            weakSelf.coinCount += coinCount;
            
            
            weakSelf.coinCountLB.attributedText = [weakSelf getCoinCount:[NSString stringWithFormat:@"%d碰碰币", weakSelf.coinCount]];
            
            NSString * dateStr = [self getNowDate];
            
            SigninModel * model = [self.dataArr lastObject];
            SigninModel * nModel = [[SigninModel alloc]init];
            nModel.MonthToDay = dateStr.intValue;
            if (nModel.MonthToDay - model.MonthToDay > 1) {
                nModel.conSignDay = 1;
            }else
            {
                if (model.conSignDay == 7) {
                    nModel.conSignDay = 1;
                }else
                {
                    nModel.conSignDay = model.conSignDay + 1;
                }
            }
            [weakSelf.dataArr addObject:nModel];
            weakSelf.signinDateView.dataArr = self.dataArr;
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"恭喜您获得%d碰碰币", coinCount] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.signinBT setTitle:[NSString stringWithFormat:@"已连续签到%d天", nModel.conSignDay] forState:UIControlStateNormal];
                weakSelf.signinBT.enabled = NO;
                
                [weakSelf.signinDateView.dateCollectionView reloadData];
            });
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }];
    
}

- (NSString *)getNowDate
{
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"dd";
    NSString * dateStr = [fomatter stringFromDate:date];
    return dateStr;
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
