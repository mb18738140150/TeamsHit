//
//  FriendListViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *friendSearcgBar;
@property (strong, nonatomic) IBOutlet UITableView *friendsTabelView;

@property (nonatomic, strong)NSArray * keys;
@property (nonatomic, strong)NSMutableDictionary * allFriends;
@property (nonatomic, strong)NSArray * allKeys;
@property (nonatomic, strong)NSArray * seleteUsers;

@end
