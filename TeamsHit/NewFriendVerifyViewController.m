//
//  NewFriendVerifyViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "NewFriendVerifyViewController.h"

@interface NewFriendVerifyViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UILabel *detaileLabel;
@property (strong, nonatomic) IBOutlet UIButton *refuseBT;
@property (strong, nonatomic) IBOutlet UIButton *acceptBT;

@end

@implementation NewFriendVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"新的朋友";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.refuseBT.layer.cornerRadius = 2;
    self.refuseBT.layer.borderWidth = .7;
    self.refuseBT.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
    self.refuseBT.layer.masksToBounds = YES;
    
    self.acceptBT.layer.cornerRadius = 2;
    self.acceptBT.layer.masksToBounds = YES;
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
