//
//  ChatListViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ChatListViewController.h"
#import "KxMenu.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"navigationlogo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"addicon"]];
    [rightBarItem addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    // Do any additional setup after loading the view.
}

- (void)showMenu:(UIBarButtonItem *)button
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"发起聊天"
                     image:[UIImage imageNamed:@"startchat_icon"]
                    target:self
                    action:@selector(pushChat:)]
      
//      [KxMenuItem menuItem:@"创建群组"
//                     image:[UIImage imageNamed:@"creategroup_icon"]
//                    target:self
//                    action:@selector(pushContactSelected:)],
//      
//      [KxMenuItem menuItem:@"添加好友"
//                     image:[UIImage imageNamed:@"addfriend_icon"]
//                    target:self
//                    action:@selector(pushAddFriend:)],
      
      //      [KxMenuItem menuItem:@"新朋友"
      //                     image:[UIImage imageNamed:@"contact_icon"]
      //                    target:self
      //                    action:@selector(pushAddressBook:)],
      //
      //      [KxMenuItem menuItem:@"公众账号"
      //                     image:[UIImage imageNamed:@"public_account"]
      //                    target:self
      //                    action:@selector(pushPublicService:)],
      //
      //      [KxMenuItem menuItem:@"添加公众号"
      //                     image:[UIImage imageNamed:@"add_public_account"]
      //                    target:self
      //                    action:@selector(pushAddPublicService:)],
      ];
    
    CGRect targetFrame = self.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 7;
    [KxMenu setTintColor:HEXCOLOR(0x000000)];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:17]];
    NSLog(@"class = %@, classtow = %@, **%@", [self.tabBarController class], [self.navigationItem.rightBarButtonItem.customView class], [self.navigationItem.rightBarButtonItem.customView.superview.superview class]);
    
    [KxMenu showMenuInView:self.navigationItem.rightBarButtonItem.customView.superview.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
}

- (void)pushChat:(id)sender
{
    NSLog(@"好友列表哇哇哇");
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
