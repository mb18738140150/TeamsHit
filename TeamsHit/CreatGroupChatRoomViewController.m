//
//  CreatGroupChatRoomViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/24.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CreatGroupChatRoomViewController.h"

#import "SearchBarView.h"
#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import "DefaultPortraitView.h"
#import "pinyin.h"
#import "RCDContactTableViewCell.h"
#import "RCDRCIMDataSource.h"

@interface CreatGroupChatRoomViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray * tempOtherArr;// 首字母不是A~Z的好友列表
@property (nonatomic, strong)NSMutableArray * friends;// 数据库获取的所有好友信息列表
@property (nonatomic, strong)NSArray * arrayForKey;// 首字母对应的好友列表
@property (nonatomic, strong)NSMutableArray * searchReasult;
@property (nonatomic, strong)NSMutableArray * friendsArr; // 好友信息

@property (strong, nonatomic) UITableView *friendsTabelView;

@property (nonatomic, strong)NSArray * keys;
@property (nonatomic, strong)NSMutableDictionary * allFriends;// 按照字母分配的好友字典信息
@property (nonatomic, strong)NSArray * allKeys;// 好友列表首字母数组
@property (nonatomic, strong)NSMutableArray * seleteUsers;// 选中的好友数组

@property (nonatomic, strong)SearchBarView * searchBarView;

@end

@implementation CreatGroupChatRoomViewController
{
    BOOL isSyncFriends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"选择联系人"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithTitle:@"确定" backgroundcolor:UIColorFromRGB(0x12B7F5) cornerRadio:3];
//    rightBarItem.enabled = NO;
    [rightBarItem addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    [self prepareUI];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareUI
{
    self.searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake( 15, 5, self.view.hd_width - 30, 40)];
    [self.view addSubview:self.searchBarView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_searchBarView.searchTextView];
    
    _searchReasult = [[NSMutableArray alloc]init];
    _friends = [[NSMutableArray alloc]init];
    self.friendsArr = [NSMutableArray array];
    self.seleteUsers = [NSMutableArray array];
    
    self.friendsTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, self.view.hd_width, self.view.hd_height - 64 - 70)];
    self.friendsTabelView.delegate = self;
    self.friendsTabelView.dataSource = self;
    float colorFloat = 245.f / 255.f;
    self.friendsTabelView.backgroundColor = [[UIColor alloc] initWithRed:colorFloat green:colorFloat blue:colorFloat alpha:1];
    
    [self.view addSubview:self.friendsTabelView];
}

#pragma mark - 确认创建
- (void)sureAction:(UIButton *)button
{
    
    if (self.seleteUsers.count > 1) {
        for (RCDUserInfo * user in _seleteUsers) {
            NSLog(@"添加的群组成员%@", user.displayName);
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"至少添加两个好友才能创建群组" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    [_friendsArr removeAllObjects];
    [self getAllData];
}

- (void)textFieldChanged:(id)sender
{
    NSString * searchText = self.searchBarView.searchTextView.text;
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

#pragma mark - uitableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
        NSString * key = [_allKeys objectAtIndex:section];
        NSArray * arr = [_allFriends objectForKey:key];
        rows = [arr count];
    return rows;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_allKeys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title;
    
        title = [_allKeys objectAtIndex:section];
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reusableCellWithIdentifier = @"RCDContactTableViewCell";
    RCDContactTableViewCell * cell = [self.friendsTabelView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDContactTableViewCell alloc] init];
        cell.selectStateBT.hidden = NO;
    }
    
    
    NSString *key = [_allKeys objectAtIndex:indexPath.section];
    _arrayForKey = [_allFriends objectForKey:key];
    
    RCDUserInfo *user = _arrayForKey[indexPath.row];
    if(user){
        if (user.displayName.length == 0) {
            cell.nicknameLabel.text = user.name;
        }else
        {
            cell.nicknameLabel.text = user.displayName;
        }
        
        [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
    }
    
    if (user.isSelect) {
        cell.selectStateBT.layer.borderColor = UIColorFromRGB(0x12B7F5).CGColor;
        cell.selectStateBT.selected = YES;
    }else
    {
        cell.selectStateBT.selected = NO;
        cell.selectStateBT.layer.borderColor = UIColorFromRGB(0xA6A6A6).CGColor;
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
    
    [cell getSelectState:^(BOOL isSelect) {
        if (!isSelect) {
            user.isSelect = NO;
            for (int i = 0; i < self.seleteUsers.count; i++) {
                RCDUserInfo *selectUser = _seleteUsers[i];
                if ([selectUser.userId isEqualToString:user.userId]) {
                    [_seleteUsers removeObject:selectUser];
                    break;
                }
            }
        }else
        {
            user.isSelect = YES;
            [self.seleteUsers addObject:user];
        }
        [self.friendsTabelView reloadData];
        [self refreshRihgtBaritem];
    }];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key = [_allKeys objectAtIndex:indexPath.section];
    _arrayForKey = [_allFriends objectForKey:key];
    
    RCDUserInfo *user = _arrayForKey[indexPath.row];
    
    RCUserInfo *userInfo = [RCUserInfo new];
    userInfo.userId = user.userId;
    userInfo.portraitUri = user.portraitUri;
    userInfo.name = user.displayName;
    if (user.isSelect) {
        user.isSelect = NO;
        for (int i = 0; i < self.seleteUsers.count; i++) {
            RCDUserInfo *selectUser = _seleteUsers[i];
            if ([selectUser.userId isEqualToString:user.userId]) {
                [_seleteUsers removeObject:selectUser];
                break;
            }
        }
    }else
    {
        user.isSelect = YES;
        [self.seleteUsers addObject:user];
    }
    
    [self.friendsTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self refreshRihgtBaritem];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _allKeys;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBarView.searchTextView resignFirstResponder];
}

- (void)refreshRihgtBaritem
{
    TeamHitBarButtonItem * barButtonItem = self.navigationItem.rightBarButtonItem.customView;
    NSString *numberStr = @"确定";
    if (self.seleteUsers.count > 0) {
       numberStr = [NSString stringWithFormat:@"确定(%d)", self.seleteUsers.count];
    }
    CGSize buttontitleSize = [numberStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    barButtonItem.frame = CGRectMake(0, 0, buttontitleSize.width + 10, 33);
    barButtonItem.layer.masksToBounds = YES;
    [barButtonItem setTitle:numberStr forState:UIControlStateNormal];
}

#pragma mark - 获取好友并排序
- (void)getAllData
{
    _keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    _allFriends = [NSMutableDictionary new];
    _allKeys = [NSMutableArray new];
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
    NSMutableDictionary * returnDic = [NSMutableDictionary new];
    _tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    for (NSString * key in _keys) {
        if ([_tempOtherArr count]) {
            isReturn = YES;
        }
        NSMutableArray * tempArr = [NSMutableArray new];
        for (RCDUserInfo * user in friends) {
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
