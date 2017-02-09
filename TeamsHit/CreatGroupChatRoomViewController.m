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

#import "CreatGroupViewController.h"

@interface CreatGroupChatRoomViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    MBProgressHUD* hud ;
}
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
@property (nonatomic, strong)NSArray * groupMumberIDsArr; // 添加群成员是存储原群成员id
@property (nonatomic, strong)SearchBarView * searchBarView;

@property (nonatomic, assign)BOOL isCreatGroupVC;

@end

@implementation CreatGroupChatRoomViewController
{
    BOOL isSyncFriends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.title = @"选择联系人";
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithTitle:@"确定" backgroundcolor:UIColorFromRGB(0x12B7F5) cornerRadio:3];
    [rightBarItem addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    self.groupMumberIDsArr = [self.targetId componentsSeparatedByString:@","];
    
    [self prepareUI];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareUI
{
    self.searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake( 15, 5, self.view.hd_width - 30, 40)];
    self.searchBarView.searchTextView.returnKeyType = UIReturnKeyDone;
    self.searchBarView.searchTextView.delegate = self;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)addgroupMumberAction:(AddGroupMumberBlock)block
{
    self.myBlock = [block copy];
}

#pragma mark - 确认创建
- (void)sureAction:(UIButton *)button
{
    if (self.addGroupMember) {
         RCDGroupInfo * rcGroupInfo = [[RCDataBaseManager shareInstance]getGroupByGroupId:self.groupID];
        
        NSString * userIdStr = @"";
        for (int i = 0; i < self.seleteUsers.count; i++) {
            RCDUserInfo * userInfo = [self.seleteUsers objectAtIndex:i];
            if (i == 0) {
                userIdStr = userInfo.userId;
            }else
            {
                userIdStr = [userIdStr stringByAppendingFormat:@",%@", userInfo.userId];
            }
        }
        
        if (userIdStr.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择好友" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        
        hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"发送请求中...";
        [hud show:YES];
        NSString * url = [NSString stringWithFormat:@"%@groups/inviteFriendIntoGroup?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
        NSDictionary * jsonDic = @{
                                   @"GroupId":@(self.groupID.intValue),
                                   @"GroupName":rcGroupInfo.groupName,
                                   @"MembersId":userIdStr
                                   };
        
        __weak CreatGroupChatRoomViewController * verifyVC = self;
        [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
            ;
        } success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"responseObject = %@", responseObject);
            int code = [[responseObject objectForKey:@"Code"] intValue];
            if (code == 200) {
                
                if (self.myBlock) {
                    _myBlock();
                }
                [verifyVC.navigationController popViewControllerAnimated:YES];
                
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
        
    }else
    {
        
        NSString * userIdStr = @"";
        for (int i = 0; i < self.seleteUsers.count; i++) {
            RCDUserInfo * userInfo = [self.seleteUsers objectAtIndex:i];
            if (i == 0) {
                userIdStr = [[RCIM sharedRCIM].currentUserInfo.userId stringByAppendingFormat:@",%@", userInfo.userId];
            }else
            {
                userIdStr = [userIdStr stringByAppendingFormat:@",%@", userInfo.userId];
            }
        }
        if (userIdStr.length == 0) {
            userIdStr = [RCIM sharedRCIM].currentUserInfo.userId;
        }
        CreatGroupViewController * crearVC = [[CreatGroupViewController alloc]init];
        crearVC.userIdArrayStr = userIdStr;
        self.isCreatGroupVC = YES;
        [self.navigationController pushViewController:crearVC animated:YES];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    [_friendsArr removeAllObjects];
    if (!self.isCreatGroupVC) {
        [self getAllData];
    }
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
    
    
    BOOL isHave = NO;
    for (NSString * mumberID in self.groupMumberIDsArr) {
        if ( [user.userId isEqualToString:mumberID]) {
            isHave = YES;
        }
    }
    
        if (isHave) {
            cell.selectStateBT.userInteractionEnabled = NO;
        }else
        {
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
        }
    
    
//    if (self.targetId && [self.targetId isEqualToString:user.userId]) {
//        cell.selectStateBT.userInteractionEnabled = NO;
//    }else
//    {
//        [cell getSelectState:^(BOOL isSelect) {
//            if (!isSelect) {
//                user.isSelect = NO;
//                for (int i = 0; i < self.seleteUsers.count; i++) {
//                    RCDUserInfo *selectUser = _seleteUsers[i];
//                    if ([selectUser.userId isEqualToString:user.userId]) {
//                        [_seleteUsers removeObject:selectUser];
//                        break;
//                    }
//                }
//            }else
//            {
//                user.isSelect = YES;
//                [self.seleteUsers addObject:user];
//            }
//            [self.friendsTabelView reloadData];
//            [self refreshRihgtBaritem];
//        }];
//    }
    
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
    
    
    BOOL isHave = NO;
    for (NSString * mumberID in self.groupMumberIDsArr) {
        if ( [user.userId isEqualToString:mumberID]) {
            isHave = YES;
        }
    }
    
            if ( isHave) {
                ;
            }else
            {
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
    
    barButtonItem.frame = CGRectMake(barButtonItem.hd_x - (buttontitleSize.width - barButtonItem.hd_width), barButtonItem.hd_y, buttontitleSize.width + 10, 33);
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
                if (self.targetId) {
                    if ([user.userId isEqualToString:self.targetId]) {
                        user.isSelect = YES;
                        [_seleteUsers addObject:user];
                        [self refreshRihgtBaritem];
                    }else
                    {
                        for (NSString * userID in self.groupMumberIDsArr) {
                            if ([user.userId isEqualToString:userID]) {
                                user.isSelect = YES;
                            }
                        }
                    }
                }
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
