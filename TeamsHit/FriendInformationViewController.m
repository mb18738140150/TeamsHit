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
@interface FriendInformationViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *iconImageview;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *addresslabel;
@property (strong, nonatomic) IBOutlet UIButton *oparationBT;
@property (strong, nonatomic) IBOutlet UIView *imageview;
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageview2;
@property (strong, nonatomic) IBOutlet UIImageView *imageview3;
@property (strong, nonatomic) IBOutlet UIImageView *imageview4;

@end

@implementation FriendInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"详细资料"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.imageview.tag = 1000;
    self.imageView1.tag = 1001;
    self.imageview2.tag = 1002;
    self.imageview3.tag = 1003;
    self.imageview4.tag = 1004;
    
    [self refreshData];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData
{
    self.nickNameLabel.text = self.model.nickName;
    self.accountNumberLabel.text = [NSString stringWithFormat:@"%@", self.model.userId];
    [self.iconImageview sd_setImageWithURL:[NSURL URLWithString:self.model.iconUrl] placeholderImage:[UIImage imageNamed:@"logo(1)"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.iconImageview.image = image;
        }
    }];
    
    self.phoneNumberLabel.text = self.model.phone;
    self.addresslabel.text = self.model.address;
    
    if (self.model.isFriend.intValue == 1) {
        [self.oparationBT setTitle:@"发消息" forState:UIControlStateNormal];
    }else
    {
        [self.oparationBT setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < self.model.galleryList.count; i++) {
        if (i<=4) {
            UIImageView * imageView = [self.imageview viewWithTag:1001 + i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.galleryList[i]] placeholderImage:[UIImage imageNamed:@"logo(1)"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    imageView.image = image;
                }
            }];
        }
    }
    
}
- (IBAction)addfriendAction:(id)sender {
    
    if ([self.oparationBT.titleLabel.text isEqualToString:@"发消息"]) {
        NSLog(@"发消息");
    }else
    {
        VirifyFriendViewController * verifyVc = [[VirifyFriendViewController alloc]initWithNibName:@"VirifyFriendViewController" bundle:nil];
        verifyVc.userId = self.model.userId;
        [self.navigationController pushViewController:verifyVc animated:YES];
    }
    
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
