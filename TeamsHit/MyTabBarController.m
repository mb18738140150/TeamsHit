//
//  MyTableViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MyTabBarController.h"

#import "ChatListViewController.h"
#import "FriendListViewController.h"
#import "FindViewController.h"
#import "MeViewController.h"

@interface MyTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong)ChatListViewController *chatListVC;
@property (nonatomic, strong)FriendListViewController *friendListVC;
@property (nonatomic, strong)FindViewController *findVC;
@property (nonatomic, strong)MeViewController *meVC;


@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = UIColorFromRGB(0x12B7F5);
    self.tabBar.translucent = NO;
    
//    self.chatListVC = [[ChatListViewController alloc]initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)] collectionConversationType:@[@(ConversationType_SYSTEM)]];
    self.chatListVC = [[ChatListViewController alloc]init];
    _chatListVC.tabBarItem.title = @"对对碰";
    _chatListVC.tabBarItem.image = [UIImage imageNamed:@"chat-1"] ;
    _chatListVC.tabBarItem.selectedImage = [UIImage imageNamed:@"chat-2"] ;
    UINavigationController * chatListNav = [[UINavigationController alloc] initWithRootViewController:_chatListVC];
    
    self.friendListVC = [[FriendListViewController alloc]init];
    _friendListVC.tabBarItem.title = @"好友";
    _friendListVC.tabBarItem.image = [UIImage imageNamed:@"friend-1"] ;
    _friendListVC.tabBarItem.selectedImage = [UIImage imageNamed:@"friend-2"] ;
    UINavigationController * friendListNav = [[UINavigationController alloc] initWithRootViewController:_friendListVC];
    
    self.findVC = [[FindViewController alloc]init];
    _findVC.tabBarItem.title = @"发现";
    _findVC.tabBarItem.image = [UIImage imageNamed:@"find-1"] ;
    _findVC.tabBarItem.selectedImage = [UIImage imageNamed:@"find-2"] ;
    UINavigationController * findNav = [[UINavigationController alloc] initWithRootViewController:_findVC];
    
    self.meVC = [[MeViewController alloc]init];
    _meVC.tabBarItem.title = @"我的";
    _meVC.tabBarItem.image = [UIImage imageNamed:@"me-1"] ;
    _meVC.tabBarItem.selectedImage = [UIImage imageNamed:@"me-2"] ;
    UINavigationController * meNav = [[UINavigationController alloc] initWithRootViewController:_meVC];
    
    self.viewControllers = @[chatListNav, friendListNav, findNav, meNav];
    
//    for (int i = 0; i < self.viewControllers.count; i++) {
//        UINavigationController * nav = [self.viewControllers objectAtIndex:i];
//        nav.tabBarItem.image = [UIImage imageNamed:@"tabbar_n_0"] ;
//        nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_s_0"] ;
//    }
    self.selectedViewController = [self.viewControllers firstObject];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
