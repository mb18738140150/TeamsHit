//
//  FriendInformationViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FriendInformationViewController.h"
#import "FriendInformationModel.h"
#import "VirifyFriendViewController.h"
#import "FriendDetailDataSettingViewController.h"
#import "ChatViewController.h"
#import "UserFriendCircleViewController.h"
@interface FriendInformationViewController ()
{
    UIView * amplificationbackView;
}


@property (strong, nonatomic) IBOutlet UIView *informationView;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageview;// 头像
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;// 昵称
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;//对对号
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *genderImageView;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLB;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLB;
@property (strong, nonatomic) IBOutlet UIView *assressLine;

@property (strong, nonatomic) IBOutlet UILabel *addresslabel;
@property (strong, nonatomic) IBOutlet UIButton *oparationBT;
@property (strong, nonatomic) IBOutlet UIView *imageview;
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageview2;
@property (strong, nonatomic) IBOutlet UIImageView *imageview3;
@property (strong, nonatomic) IBOutlet UIImageView *imageview4;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;








@property (nonatomic, assign)BOOL ishavePhonenumber;
@property (nonatomic, assign)BOOL haveReload;

@end

@implementation FriendInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"详细资料";
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"点点"]];
    [rightBarItem addTarget:self action:@selector(friendDetailDatSettingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    UITapGestureRecognizer *amplificationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(amplification:)];
    [self.iconImageview addGestureRecognizer:amplificationTap];
    
    if (self.IsPhoneNumber != 1) {
        self.IsPhoneNumber = 2;
    }
    
    self.imageview.tag = 1000;
    self.imageView1.tag = 1001;
    self.imageview2.tag = 1002;
    self.imageview3.tag = 1003;
    self.imageview4.tag = 1004;
    
    if (self.model == nil) {
        [self getfriendInformation];
    }
    [self refreshData];
    
    [self updataDataSource];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    if (self.model.displayName.length == 0) {
        self.nickNameLabel.text = self.model.nickName;
    }else
    {
        self.nickNameLabel.text = self.model.displayName;
    }
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)friendDetailDatSettingAction
{
    FriendDetailDataSettingViewController * fvc = [[FriendDetailDataSettingViewController alloc]initWithNibName:@"FriendDetailDataSettingViewController" bundle:nil];
    fvc.model = self.model;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)refreshData
{
    if (self.model.displayName.length == 0) {
        self.nickNameLabel.text = self.model.nickName;
        self.displayNameLabel.hidden = YES;
    }else
    {
        self.nickNameLabel.text = self.model.displayName;
        self.displayNameLabel.text = [NSString stringWithFormat:@"昵称:%@", self.model.nickName];
        self.displayNameLabel.hidden = NO;
    }
    if ([self.model.gender isEqualToString:@"男"]) {
        self.genderImageView.image = [UIImage imageNamed:@"gender_man"];
        
    }else if ([self.model.gender isEqualToString:@"女"])
    {
        self.genderImageView.image = [UIImage imageNamed:@"gender_woman"];
        
    }else
    {
        self.genderImageView.image = [UIImage imageNamed:@"gender_secret"];
    }
    if (self.model.userId.intValue == 200) {
        self.genderImageView.image = [UIImage imageNamed:@"gender_verify"];
    }
    
    if (self.model.IsPhoneNumber.intValue == 1) {
        self.ishavePhonenumber = YES;
    }else
    {
        self.ishavePhonenumber = NO;
    }
    
    self.accountNumberLabel.text = [NSString stringWithFormat:@"对对号:%@", self.model.UserName];
    [self.iconImageview sd_setImageWithURL:[NSURL URLWithString:self.model.iconUrl] placeholderImage:[UIImage imageNamed:@"logo(1)"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.iconImageview.image = image;
        }
    }];
    
    self.phoneNumberLabel.text = self.model.phone;
    self.addresslabel.text = self.model.address;
    
    if (self.model.isFriend.intValue == 1) {
        [self.oparationBT setTitle:@"发消息" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }else
    {
        [self.oparationBT setTitle:@"添加好友" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }
    
    for (int i = 0; i < self.model.galleriesList.count; i++) {
        if (i<=4) {
            UIImageView * imageView = [self.imageview viewWithTag:1001 + i];
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.galleriesList[i]] placeholderImage:[UIImage imageNamed:@"logo(1)"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    imageView.image = image;
                }
            }];
        }
    }
    
    for (int i = self.model.galleriesList.count; i < 4; i++) {
         UIImageView * imageView = [self.imageview viewWithTag:1001 + i];
        imageView.hidden = YES;
    }
//    if (self.haveReload) {
//        ;
//    }else
//    {
//        [self refreshUI];
//        [self.view setNeedsLayout];
//        [self.view layoutIfNeeded];
//    }
    
    if (self.model == nil) {
    }else
    {
        [self refreshUI];
    }
    
}

#pragma mark - 添加好友
- (IBAction)addfriendAction:(id)sender {
    
    if ([self.oparationBT.titleLabel.text isEqualToString:@"发消息"]) {
        NSLog(@"发消息");
        ChatViewController * chatVc = [[ChatViewController alloc]init];
        chatVc.hidesBottomBarWhenPushed = YES;
        chatVc.conversationType = ConversationType_PRIVATE;
        chatVc.displayUserNameInCell = NO;
        if (self.model) {
            chatVc.targetId = [NSString stringWithFormat:@"%@", self.model.userId];
        }else
        {
            chatVc.targetId = self.targetId;
        }
        chatVc.title = self.model.displayName;
        chatVc.needPopToRootView = YES;
        [self.navigationController pushViewController:chatVc animated:YES];
    }else
    {
        VirifyFriendViewController * verifyVc = [[VirifyFriendViewController alloc]initWithNibName:@"VirifyFriendViewController" bundle:nil];
        verifyVc.IsPhoneNumber = self.IsPhoneNumber;
        verifyVc.userId = self.model.userId;
        [self.navigationController pushViewController:verifyVc animated:YES];
    }
}

- (void)updataDataSource
{
    RCDUserInfo * userinfo = [[RCDataBaseManager shareInstance]getFriendInfo:[NSString stringWithFormat:@"%@", self.model.userId]];
    userinfo.name = self.model.nickName;
    userinfo.portraitUri = self.model.iconUrl;
    userinfo.displayName = self.model.displayName;
    [[RCDataBaseManager shareInstance]insertFriendToDB:userinfo];
    
    RCUserInfo * user = [[RCDataBaseManager shareInstance]getUserByUserId:[NSString stringWithFormat:@"%@", self.model.userId]];
    user.portraitUri = self.model.iconUrl;
    if (self.model.displayName.length != 0) {
        user.name = self.model.displayName;
    }else
    {
        user.name = self.model.nickName;
    }
    [[RCDataBaseManager shareInstance]insertUserToDB:user];

    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
    
}

- (void)refreshUI
{
    if (self.ishavePhonenumber) {
        self.phoneNumberLB.hidden = NO;
        self.phoneNumberLabel.hidden = NO;
        self.assressLine.hidden = NO;
    }else
    {
        UIView * view2 = [[UIView alloc]init];
        view2.frame = self.informationView.frame;
        view2.hd_height = view2.hd_height - 45;
        
        NSLayoutConstraint * buttomLeftContraint = [NSLayoutConstraint constraintWithItem:self.informationView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:90];
        
        [self.informationView addConstraint:buttomLeftContraint];
        
        self.phoneNumberLB.hidden = YES;
        self.phoneNumberLabel.hidden = YES;
        self.assressLine.hidden = YES;
    }
    
}

- (void)getfriendInformation
{
    NSDictionary * jsonDic = @{
                               @"Account":self.targetId
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/SearchFriend?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak FriendInformationViewController * chatVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            self.haveReload = YES;
            self.model = [[FriendInformationModel alloc]initWithDictionery:responseObject];
            
            RCDUserInfo * userinfo = [[RCDataBaseManager shareInstance]getFriendInfo:[NSString stringWithFormat:@"%@", self.model.userId]];
            userinfo.name = self.model.nickName;
            userinfo.portraitUri = self.model.iconUrl;
            userinfo.displayName = self.model.displayName;
            [[RCDataBaseManager shareInstance]insertFriendToDB:userinfo];
            
            RCUserInfo * user = [[RCDataBaseManager shareInstance]getUserByUserId:[NSString stringWithFormat:@"%@", self.model.userId]];
            user.portraitUri = self.model.iconUrl;
            if (self.model.displayName.length != 0) {
                user.name = self.model.displayName;
            }else
            {
                user.name = self.model.nickName;
            }
            [[RCDataBaseManager shareInstance]insertUserToDB:user];
            
            [self refreshData];
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

- (IBAction)lookUserFriendCircle:(id)sender {
    
    UserFriendCircleViewController * vc = [[UserFriendCircleViewController alloc]init];
    vc.userId = self.model.userId;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)amplification:(UITapGestureRecognizer *)sender
{
    UIImageView * iconImageView = (UIImageView *)sender.view;
    
    amplificationbackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    amplificationbackView.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissamplification)];
    [amplificationbackView addGestureRecognizer:dismissTap];
    
    [[ShareApplicationDelegate window]addSubview:amplificationbackView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, amplificationbackView.hd_width, amplificationbackView.hd_height)];
    imageView.image = iconImageView.image;
    imageView.hd_height = imageView.hd_width * iconImageView.image.size.height / iconImageView.image.size.width;
    imageView.hd_centerY = amplificationbackView.hd_centerY;
    CGRect rect = imageView.frame;
    
    imageView.userInteractionEnabled = YES;
    [amplificationbackView addSubview:imageView];
    
    imageView.frame = iconImageView.frame;
    [UIView animateWithDuration:.3 delay:0 options:nil animations:^{
        
        imageView.frame = rect;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)dismissamplification
{
    [amplificationbackView removeFromSuperview];
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
