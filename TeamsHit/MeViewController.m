//
//  MeViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MeViewController.h"
#import "ProcessingImagesViewController.h"
#import "MaterialViewController.h"
#import "MeDetailInfomationViewController.h"

#import "StoreViewController.h"
#import "CoindetailViewController.h"
#import "EquipmentManagerViewController.h"

#import "SetUpViewController.h"
#import "AppDelegate.h"

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "TelephoneRechargeViewController.h"

#import "BusinessServeViewController.h"
#import "SigninViewController.h"
#import "PanTestViewController.h"
static NSString *kLinkURL = @"http://download.www.mstching.com";
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
static NSString *kLinkTitle = @"当下最火的游戏娱乐APP";
static NSString *kLinkDescription = @"快来跟我一起玩史上最好玩的轻游戏，等你哦。";

@interface MeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, WXApiManagerDelegate>
{
    MBProgressHUD* hud ;
    UIView * backView;
}
@property (strong, nonatomic) IBOutlet UILabel *shareGetCoinLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *coinCountLB;
@property (strong, nonatomic) IBOutlet UILabel *counCountLabel;
@property (nonatomic) enum WXScene currentScene;

@property (strong, nonatomic) IBOutlet UIView *equipmentmanagerView;
@property (strong, nonatomic) IBOutlet UIImageView *equipmentImage;
@property (strong, nonatomic) IBOutlet UILabel *equipmentLB;

@property (nonatomic, copy)NSString * iconImageStr;

@property (nonatomic, strong)UIImageView * loadingImageView;

@end

@implementation MeViewController

@synthesize currentScene = _currentScene;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"navigationlogo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    _iconImageView.userInteractionEnabled = YES;
    [_iconImageView addGestureRecognizer:imageTap];
    
    UITapGestureRecognizer * infoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    _infoView.userInteractionEnabled = YES;
    [_infoView addGestureRecognizer:infoTap];
    
    self.imagePic = [[UIImagePickerController alloc] init];
//    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    self.equipmentImage.userInteractionEnabled = YES;
    self.equipmentLB.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * equipmentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(equipmentAction:)];
    [self.equipmentmanagerView addGestureRecognizer:equipmentTap];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getUserInfo];
        });
    });
    
    [WXApiManager sharedManager].delegate = self;
    
//    NSArray * rr = @[@"hhh"];
//    NSLog(@"%@", rr[1]);
    
//    UIImage * image = [UIImage imageNamed:@"bbb.jpg"];
//    NSLog(@"width =  %f ** height = %f", image.size.width, image.size.height);
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)getUserInfo
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    
    __weak MeViewController * infoVC = self;
    [[HDNetworking sharedHDNetworking]getDetailInfor:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
            
            [infoVC refreshUIWithDic:dic];
            
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

- (void)refreshUIWithDic:(NSDictionary *)dic
{
    self.iconImageStr = [dic objectForKey:@"PortraitUri"];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"PortraitUri"]] placeholderImage:[UIImage imageNamed:@"camera_icon.png"]];
    self.userNameLabel.text = [dic objectForKey:@"NickName"];
    self.coinCountLB.text = [NSString stringWithFormat:@"对对号:%@", [dic objectForKey:@"UserName"]];
    self.counCountLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CoinCount"]];
    if([[dic objectForKey:@"IsShare"] boolValue])
    {
        self.shareGetCoinLabel.hidden = YES;
    }else
    {
        self.shareGetCoinLabel.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self getUserInfo1];
}

- (void)getUserInfo1
{
    
    __weak MeViewController * infoVC = self;
    [[HDNetworking sharedHDNetworking]getDetailInfor:nil success:^(id  _Nonnull responseObject) {
    
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
            
            if ([infoVC.iconImageStr isEqualToString:[dic objectForKey:@"PortraitUri"]] && [[NSString stringWithFormat:@"%@", [dic objectForKey:@"CoinCount"]] isEqualToString:infoVC.coinCountLB.text]) {
                ;
            }else
            {
                [infoVC refreshUIWithDic:dic];
            }
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - 选择图片
- (void)changeImageAction:(UITapGestureRecognizer *)sender
{
    if ([sender.view isEqual:_infoView]) {
        MeDetailInfomationViewController * meinfoVC = [[MeDetailInfomationViewController alloc]initWithNibName:@"MeDetailInfomationViewController" bundle:nil];
        meinfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:meinfoVC animated:YES];
    }else
    {
        MaterialViewController * processVC = [[MaterialViewController alloc]init];
        processVC.hidesBottomBarWhenPushed = YES;
        
//        [self.navigationController pushViewController:processVC animated:YES];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@", [info description]);
    
    self.iconImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    [self uploadImageWithUrlString];
}

- (void)equipmentAction:(UITapGestureRecognizer *)sender
{
    EquipmentManagerViewController * equipmentVC = [[EquipmentManagerViewController alloc]initWithNibName:@"EquipmentManagerViewController" bundle:nil];
    
    equipmentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:equipmentVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 购买碰碰币
- (IBAction)buyCoinAction:(id)sender {
    CoindetailViewController * coinVC = [[CoindetailViewController alloc]initWithNibName:@"CoindetailViewController" bundle:nil];
    coinVC.cointCount = self.counCountLabel.text;
    coinVC.hidesBottomBarWhenPushed = YES;
    [coinVC BuyCoins:^(NSString *coinCount) {
        if (coinCount.length != 0) {
            self.coinCountLB.text = coinCount;
            self.counCountLabel.text = coinCount;
        }
    }];
    [self.navigationController pushViewController:coinVC animated:YES];
    
}
- (IBAction)storeAction:(id)sender {
    StoreViewController * storeVC = [[StoreViewController alloc]init];
    
    storeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeVC animated:YES];
    
}

#pragma mark - 分享
- (IBAction)share:(id)sender {
    
    backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.hd_height - 224, backView.hd_width, 224)];
    whiteView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [backView addSubview:whiteView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 12, 90, 18)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = UIColorFromRGB(0x010101);
    titleLabel.text = @"分享好友";
    [whiteView addSubview:titleLabel];
    
    UIButton * closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBT.frame = CGRectMake(whiteView.hd_width - 34, 14, 20, 20);
    [closeBT setImage:[[UIImage imageNamed:@"share_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [whiteView addSubview:closeBT];
    [closeBT addTarget:self action:@selector(closeShare) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * friendBT = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBT.frame = CGRectMake(132, 53, 38, 38);
    [friendBT setImage:[[UIImage imageNamed:@"share_friend"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [whiteView addSubview:friendBT];
    [friendBT addTarget:self action:@selector(shareFriend) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * circleBT = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBT.frame = CGRectMake(49, 53, 38, 38);
    [circleBT setImage:[[UIImage imageNamed:@"share_circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [whiteView addSubview:circleBT];
    [circleBT addTarget:self action:@selector(shareCircle) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * friendLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 105, 80, 15)];
    friendLabel.hd_centerX = friendBT.hd_centerX;
    friendLabel.font = [UIFont systemFontOfSize:15];
    friendLabel.textColor = UIColorFromRGB(0x010101);
    friendLabel.textAlignment = 1;
    friendLabel.text = @"微信好友";
    [whiteView addSubview:friendLabel];
    
    UILabel * circleLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 105, 80, 15)];
    circleLabel.hd_centerX = circleBT.hd_centerX;
    circleLabel.font = [UIFont systemFontOfSize:15];
    circleLabel.textColor = UIColorFromRGB(0x010101);
    circleLabel.textAlignment = 1;
    circleLabel.text = @"朋友圈";
    [whiteView addSubview:circleLabel];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:backView];
    
}

- (void)closeShare
{
    [backView removeFromSuperview];
}

- (void)shareFriend
{
    if (![self ishaveWechat]) {
        return;
    }
    NSLog(@"分享给好友");
    _currentScene = WXSceneSession;
    UIImage *thumbImage = [UIImage imageNamed:@"logo(1)"];
    [WXApiRequestHandler sendLinkURL:kLinkURL
                             TagName:kLinkTagName
                               Title:kLinkTitle
                         Description:kLinkDescription
                          ThumbImage:thumbImage
                             InScene:_currentScene];
}

- (void)shareCircle
{
    if (![self ishaveWechat]) {
        return;
    }
    
    NSLog(@"分享朋友圈");
    _currentScene = WXSceneTimeline;
    UIImage *thumbImage = [UIImage imageNamed:@"logo(1)"];
    [WXApiRequestHandler sendLinkURL:kLinkURL
                             TagName:kLinkTagName
                               Title:kLinkDescription
                         Description:kLinkDescription
                          ThumbImage:thumbImage
                             InScene:_currentScene];
}

- (BOOL)ishaveWechat
{
    if ([WXApi isWXAppInstalled]) {
        if ([WXApi isWXAppSupportApi]) {
            return YES;
        }else
        {
            [backView removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的微信版本不支持"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }else
    {
        [backView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您尚未安装微信"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
}

- (IBAction)setup:(id)sender {
    SetUpViewController * setVc = [[SetUpViewController alloc]initWithNibName:@"SetUpViewController" bundle:nil];
    setVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVc animated:YES];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    
    [backView removeFromSuperview];
    
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    
    
    if (response.errCode == 0) {
        self.shareGetCoinLabel.hidden = YES;
        __weak MeViewController * infoVC = self;
        NSString * url = [NSString stringWithFormat:@"%@userinfo/shareSuccess?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        [[HDNetworking sharedHDNetworking]POSTwithToken:url parameters:nil progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                [infoVC getUserInfo];
                
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
}

- (IBAction)telePhoneCheck:(id)sender {
    
    TelephoneRechargeViewController * rechargeVC = [[TelephoneRechargeViewController alloc]init];
    
    rechargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
}
- (IBAction)businessserve:(id)sender {
    
    BusinessServeViewController * businessserveVC = [[BusinessServeViewController alloc]init];
    businessserveVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:businessserveVC animated:YES];
}



- (IBAction)signinAction:(id)sender {
    NSLog(@"签到");
    
    SigninViewController * signinVC = [[SigninViewController alloc]initWithNibName:@"SigninViewController" bundle:nil];
    signinVC.hidesBottomBarWhenPushed = YES;
    signinVC.iconImage = self.iconImageView.image;
    signinVC.userName = self.userNameLabel.text;
    signinVC.coinCount = self.counCountLabel.text.intValue;
    [self.navigationController pushViewController:signinVC animated:YES];
    
//    PanTestViewController * vc = [[PanTestViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
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
