//
//  FriendListViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FriendListViewController.h"
#import "NewFriendListViewController.h"
#import "FriendInformationViewController.h"
#import "ChatViewController.h"
#import "GroupListViewController.h"

#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import "DefaultPortraitView.h"
#import "pinyin.h"
#import "RCDContactTableViewCell.h"
#import "RCDRCIMDataSource.h"

@interface FriendListViewController ()

@property (nonatomic, strong)NSMutableArray * tempOtherArr;// 首字母不是A~Z的好友列表
@property (nonatomic, strong)NSMutableArray * friends;// 数据库获取的所有好友（包括新朋友）信息列表
@property (nonatomic, strong)NSArray * arrayForKey;// 首字母对应的好友列表
@property (nonatomic, strong)NSMutableArray * searchReasult;
@property (nonatomic, strong)NSMutableArray * friendsArr; // 好友信息
@property (nonatomic, strong)NSArray * defaultCellsTitle;// 默认显示列表： 新朋友、群组
@property (nonatomic, strong)NSArray * defaultCellsPortrait;// 默认显示列表头像

@property (nonatomic, strong)UILabel * noreadLabel;

@property (nonatomic, assign)BOOL lookUserInfo;

@end

@implementation FriendListViewController

{
    BOOL isSyncFriends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"navigationlogo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    _searchReasult = [[NSMutableArray alloc]init];
    _friends = [[NSMutableArray alloc]init];
    self.friendsArr = [NSMutableArray array];
    self.friendsTabelView.tableFooterView = [UIView new];
    float colorFloat = 245.f / 255.f;
    self.friendsTabelView.backgroundColor = [[UIColor alloc] initWithRed:colorFloat green:colorFloat blue:colorFloat alpha:1];
    _defaultCellsTitle      = [NSArray arrayWithObjects:@"新朋友",@"群组", @"对对碰团队", nil];
    _defaultCellsPortrait   = [NSArray arrayWithObjects:@"newFriend",@"defaultGroup", @"logo(1)", nil];
    
    _allFriends = [NSMutableDictionary new];
    _allKeys = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deletefriend:) name:@"deleteFriend" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newfriendRequest:) name:@"newFriendRequestNotification" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.friendSearcgBar resignFirstResponder];
    if ([_searchReasult count] > 0) {
        return;
    }else
    {
        if (!self.lookUserInfo) {
            [_friendsArr removeAllObjects];
            [self getAllData];
        }else
        {
            self.lookUserInfo = NO;
        }
    }
    
    if ([[[RCDataBaseManager shareInstance]getAllNewFriendRequests] count] > 0) {
        self.noreadLabel.hidden = NO;
        self.noreadLabel.text = [NSString stringWithFormat:@"%d", [[[RCDataBaseManager shareInstance]getAllNewFriendRequests] count]];
    }else
    {
        self.noreadLabel.hidden = YES;
        self.noreadLabel.text = [NSString stringWithFormat:@"%d", [[[RCDataBaseManager shareInstance]getAllNewFriendRequests] count]];
    }
}

- (void)deletefriend:(NSNotification *)notification
{
    [self getAllData];
}

- (void)newfriendRequest:(NSNotification *)notification
{
    [self getAllData];
}

#pragma mark - uitableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) {
        rows = 3;
    }else
    {
        NSString * key = [_allKeys objectAtIndex:section - 1];
        NSArray * arr = [_allFriends objectForKey:key];
        rows = [arr count];
    }
    return rows;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_allKeys count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title;
    if (section == 0) {
        title = @"";
    }else
    {
        title = [_allKeys objectAtIndex:section - 1];
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reusableCellWithIdentifier = @"RCDContactTableViewCell";
    RCDContactTableViewCell * cell = [self.friendsTabelView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDContactTableViewCell alloc] init];
    }
    
    if (indexPath.section == 0) {
        cell.nicknameLabel.text = [_defaultCellsTitle objectAtIndex:indexPath.row];
        [cell.portraitView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[_defaultCellsPortrait objectAtIndex:indexPath.row]]]];
        if (indexPath.row == 0) {
            self.noreadLabel = cell.noreadlabel;
            if ([[[RCDataBaseManager shareInstance]getAllNewFriendRequests] count] > 0) {
//                self.noreadLabel.hidden = NO;
//                self.noreadLabel.text = [NSString stringWithFormat:@"%d", [[[RCDataBaseManager shareInstance]getAllNewFriendRequests] count]];
                cell.noreadlabel.hidden = NO;
                cell.noreadlabel.text = [NSString stringWithFormat:@"%d", [[[RCDataBaseManager shareInstance]getAllNewFriendRequests] count]];
            }
        }
    }else
    {
        NSString *key = [_allKeys objectAtIndex:indexPath.section - 1];
        _arrayForKey = [_allFriends objectForKey:key];
        
        RCDUserInfo *user = _arrayForKey[indexPath.row];
        if(user){
            if (user.displayName.length == 0) {
                cell.nicknameLabel.text = user.name;
            }else
            {
                cell.nicknameLabel.text = user.displayName;
            }
            if ([user.portraitUri isEqualToString:@""]) {
                DefaultPortraitView *defaultPortrait = [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [defaultPortrait setColorAndLabel:user.userId Nickname:user.name];
                UIImage *portrait = [defaultPortrait imageFromView];
                cell.portraitView.image = portrait;
            }
            else
            {
                [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
            }
        }
    }
    
    if ([RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE && [RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE) {
        cell.portraitView.layer.masksToBounds = YES;
        cell.portraitView.layer.cornerRadius = 20.f;
    }
    else
    {
        cell.portraitView.layer.masksToBounds = YES;
        cell.portraitView.layer.cornerRadius = 6.f;
    }
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
    cell.nicknameLabel.font = [UIFont systemFontOfSize:15.f];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        [[RCDataBaseManager shareInstance] clearNewFriendUserInfo];
        self.noreadLabel.hidden = YES;
        self.noreadLabel.text = self.noreadLabel.text = [NSString stringWithFormat:@"%d", [[[RCDataBaseManager shareInstance]getAllNewFriendRequests] count]];
        
        NewFriendListViewController * newfriendVC = [[NewFriendListViewController alloc]initWithNibName:@"NewFriendListViewController" bundle:nil];
        newfriendVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:newfriendVC animated:YES];
    }else if (indexPath.section != 0)
    {
        
        NSString *key = [_allKeys objectAtIndex:indexPath.section - 1];
        _arrayForKey = [_allFriends objectForKey:key];
        
        RCDUserInfo *user = _arrayForKey[indexPath.row];
        
        RCUserInfo *userInfo = [RCUserInfo new];
        userInfo.userId = user.userId;
        userInfo.portraitUri = user.portraitUri;
        userInfo.name = user.displayName;
        
        FriendInformationViewController * vc = [[FriendInformationViewController alloc]init];
        vc.targetId = userInfo.userId;
        vc.hidesBottomBarWhenPushed = YES;
        self.lookUserInfo = YES;
//        ChatViewController * chatVc = [[ChatViewController alloc]init];
//        chatVc.hidesBottomBarWhenPushed = YES;
//        chatVc.conversationType = ConversationType_PRIVATE;
//        chatVc.displayUserNameInCell = NO;
//        chatVc.targetId = userInfo.userId;
//        chatVc.title = userInfo.name;
//        chatVc.needPopToRootView = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1 && indexPath.section == 0)
    {
        GroupListViewController * groupListVC = [[GroupListViewController alloc]init];
        groupListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupListVC animated:YES];
    }else if (indexPath.row == 2 && indexPath.section == 0)
    {
        ChatViewController * chatVc = [[ChatViewController alloc]init];
        chatVc.hidesBottomBarWhenPushed = YES;
        chatVc.conversationType = ConversationType_PRIVATE;
        chatVc.displayUserNameInCell = NO;
        chatVc.targetId = @"200";
        chatVc.title = @"手机对对碰团队";
        chatVc.needPopToRootView = YES;
        [self.navigationController pushViewController:chatVc animated:YES];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _allKeys;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.friendSearcgBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_searchReasult removeAllObjects];
    if ([searchText length]) {
        for (RCDUserInfo * user in _friends) {
            if ([user.status isEqualToString:@"1"] || [user.name rangeOfString:searchText].location == NSNotFound) {
                // 忽略大小写去判断是否包含
                if ([user.displayName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [_searchReasult addObject:user];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _allFriends = [self sortedArrayWithPinYinDic:_searchReasult];
            [self.friendsTabelView reloadData];
        });
    }
    if ([searchText length] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _allFriends = [self sortedArrayWithPinYinDic:_friends];
            [self.friendsTabelView reloadData];
        });
    }
}

#pragma mark - 获取好友并排序
- (void)getAllData
{
    _keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    
    _friends = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
    
    [_friendsArr removeAllObjects];
    
    if (_friends.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (RCDUserInfo *user in _friends) {
                if ([user.status isEqualToString:@"1"]) {
                    [_friendsArr addObject:user];
                }
            }
            _allFriends = [self sortedArrayWithPinYinDic:_friendsArr];
            [self.friendsTabelView reloadData];
        });
    }else
    {
        [self.friendsTabelView reloadData];
    }
    if ([_friends count] == 0 && isSyncFriends == NO) {
        NSString * url = [NSString stringWithFormat:@"%@userinfo/getFriendList?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        [RCDDataSource syncFriendList:url complete:^(NSMutableArray * result) {
            isSyncFriends = YES;
            [self getAllData];
        }];
    }
}
#pragma mark - 拼音排序

/**
 *  汉字转拼音
 *pinyinFirstLetter
 *  @param hanZi 汉字
 *
 *  @return 转换后的拼音
 */
- (NSString *)hanZiToPinYinWithString:(NSString *)hanzi
{
    if (!hanzi) {
        return nil;
    }
    NSString * pinYinResult = [NSString string];
    for (int j = 0; j < hanzi.length; j++) {
        NSString * singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([hanzi characterAtIndex:j])] uppercaseString];
        pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    
    return pinYinResult;
}
/**
 *  根据转换拼音后的字典排序
 *
 *  @param pinyinDic 转换后的字典
 *
 *  @return 对应排序的字典
 */
- (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)friends
{
    if (!friends) {
        return nil;
    }
    
    NSMutableDictionary *returnDic = [NSMutableDictionary new];
    _tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    for (NSString * key in _keys) {
        if ([_tempOtherArr count]) {
            isReturn = YES;
        }
        
        NSMutableArray *tempArr = [NSMutableArray new];
        for (RCDUserInfo *user in friends) {
            NSString * pyResult = [self hanZiToPinYinWithString:user.displayName];
            NSString * firstLetter = [pyResult substringToIndex:1];
            if ([firstLetter isEqualToString:key]) {
                [tempArr addObject:user];
            }
            if (isReturn) {
                continue;
            }
            char c = [pyResult characterAtIndex:0];
            if (isalpha(c) == 0) {
                [_tempOtherArr addObject:user];
            }
        }
        if (![tempArr count]) {
            continue;
        }
        [returnDic setObject:tempArr forKey:key];
        
    }
    
    if ([_tempOtherArr count]) {
        [returnDic setObject:_tempOtherArr forKey:@"#"];
    }
    
    _allKeys = [[returnDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return returnDic;
    
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
