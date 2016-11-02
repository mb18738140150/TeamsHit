//
//  SearchFriendViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "SearchTypeView.h"
#import "SearchBarView.h"
#import "FriendInformationViewController.h"
#import "FriendInformationModel.h"

#import "SearchGrouplistViewController.h"
#import "SearchGroupListModel.h"

#define TEXTFONT [UIFont systemFontOfSize:14]
#define TEXTCOLOR UIColorFromRGB(0xB3B3B3)
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

@interface SearchFriendViewController ()<UITextFieldDelegate>
{
    MBProgressHUD* hud ;
}
@property (nonatomic, strong)SearchBarView * searchBarView;
@property (nonatomic, strong)SearchTypeView * searchTypeView;
@property (nonatomic, strong)UIView * imageView;

@property (nonatomic, strong)NSMutableArray * groupInfoArr;
@property (nonatomic, assign)int IsPhoneNumber;

@end

@implementation SearchFriendViewController

- (NSMutableArray *)groupInfoArr
{
    if (!_groupInfoArr) {
        self.groupInfoArr = [NSMutableArray array];
    }
    return _groupInfoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareNavigationItem];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height)];
    backView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:backView];
    
    [self prepareUI];
    
}

- (void)prepareNavigationItem
{
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake(self.navigationItem.leftBarButtonItem.customView.hd_width + 10, 0, self.view.hd_width - self.navigationItem.leftBarButtonItem.customView.hd_width - 20, 40)];
    self.searchBarView.searchTextView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_searchBarView.searchTextView];
    
    self.navigationItem.titleView = _searchBarView;
    
}

- (void)prepareUI
{
    self.imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height)];
    self.imageView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.hd_width - 70) / 2, 61, 90, 14)];
    tipLabel.text = @"你可以搜索";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = 1;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = UIColorFromRGB(0xB3B3B3);
    [self.imageView addSubview:tipLabel];
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.hd_width - 210) / 2, 104, 50, 50)];
    accountImageView.image = [UIImage imageNamed:@"icon_serach_account"];
    [self.imageView addSubview:accountImageView];
    
    UILabel * accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 161, 50, 14)];
    accountLabel.textColor = TEXTCOLOR;
    accountLabel.font = TEXTFONT;
    accountLabel.text = @"账号";
    accountLabel.textAlignment = 1;
    accountLabel.hd_centerX = accountImageView.center.x;
    [self.imageView addSubview:accountLabel];
    
    UIImageView * nickImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.hd_width - 210) / 2 + 80, 104, 50, 50)];
    nickImageView.image = [UIImage imageNamed:@"icon_search_nickname"];
    [self.imageView addSubview:nickImageView];
    
    UILabel * nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 161, 50, 14)];
    nickLabel.textColor = TEXTCOLOR;
    nickLabel.font = TEXTFONT;
    nickLabel.textAlignment = 1;
    nickLabel.text = @"对对号";
    nickLabel.hd_centerX = nickImageView.center.x;
    [self.imageView addSubview:nickLabel];
    
    UIImageView * groupImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.hd_width - 210) / 2 + 160, 104, 50, 50)];
    groupImageView.image = [UIImage imageNamed:@"icon_search_group"];
    [self.imageView addSubview:groupImageView];
    
    UILabel * groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 161, 50, 14)];
    groupLabel.textColor = TEXTCOLOR;
    groupLabel.font = TEXTFONT;
    groupLabel.text = @"房间";
    groupLabel.textAlignment = 1;
    groupLabel.hd_centerX = groupImageView.center.x;
    [self.imageView addSubview:groupLabel];
    
    [self.view addSubview:self.imageView];
    
    NSArray * array = [[NSBundle mainBundle]loadNibNamed:@"SearchTypeView" owner:self options:nil];
    
    self.searchTypeView = [array objectAtIndex:0];
    self.searchTypeView.frame = CGRectMake(0, 20, self.view.hd_width, self.view.hd_height);
    [self.view addSubview:self.searchTypeView];
    self.searchTypeView.hidden = YES;
    self.searchTypeView.clipsToBounds = YES;
    
    NSLog(@"frame = %f **** bounds = %f", _searchTypeView.frame.size.height, _searchTypeView.bounds.size.height);
    
    self.searchTypeView.accountLabel.userInteractionEnabled =YES;
    self.searchTypeView.groupLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * accountTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountAction)];
    [self.searchTypeView.accountView addGestureRecognizer:accountTap];
    
    [self.searchTypeView.gropBT addTarget:self action:@selector(groupAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backAction:(UIButton *)button
{
    [self.searchBarView.searchTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textView监听事件
- (void)textFieldChanged:(id)sender
{
    if (_searchBarView.searchTextView.text.length == 0) {
        _searchBarView.placeholdLabel.hidden = NO;
        self.searchTypeView.hidden = YES;
        self.imageView.hidden = NO;
    }else
    {
        _searchBarView.placeholdLabel.hidden = YES;
        self.searchTypeView.hidden = NO;
        self.imageView.hidden = YES;
        self.searchTypeView.accountLabel.text = _searchBarView.searchTextView.text;
        self.searchTypeView.groupLabel.text = _searchBarView.searchTextView.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)accountAction
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"搜索中...";
    [hud show:YES];
    
    [self.searchBarView.searchTextView resignFirstResponder];
    NSLog(@"搜索账号");
    
    if ([self.searchBarView.searchTextView.text hd_isValidPhoneNum]) {
        self.IsPhoneNumber = 1;
    }else
    {
        self.IsPhoneNumber = 2;
    }
    
    NSDictionary * jsonDic = @{
                               @"Account":self.searchBarView.searchTextView.text
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/SearchFriend?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak SearchFriendViewController * searchVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            
            FriendInformationModel * model = [[FriendInformationModel alloc]initWithDictionery:responseObject];
            if (model.userId.intValue == 0) {
                NSLog(@"搜索结果为空");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"搜索结果为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
            }else
            {
                FriendInformationViewController * friend = [[FriendInformationViewController alloc]initWithNibName:@"FriendInformationViewController" bundle:nil];
                friend.IsPhoneNumber = self.IsPhoneNumber;
                friend.model = model;
                [searchVC.navigationController pushViewController:friend animated:YES];
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            self.searchTypeView.hidden = YES;
            self.imageView.hidden = NO;
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"%@", error);
        self.searchTypeView.hidden = YES;
        self.imageView.hidden = NO;
    }];
    
}

- (void)groupAction
{
//    SearchGrouplistViewController * groupListVc = [[SearchGrouplistViewController alloc]init];
//    [self.navigationController pushViewController:groupListVc animated:YES];
    
    [self.searchBarView.searchTextView resignFirstResponder];
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"搜索中...";
    [hud show:YES];
    
    NSDictionary * jsonDic = @{
                               @"GroupAccount":self.searchBarView.searchTextView.text
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/SearchGroup?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak SearchFriendViewController * searchVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (self.groupInfoArr.count > 0) {
                [self.groupInfoArr removeAllObjects];
            }
            NSArray * groupListArr = [responseObject objectForKey:@"GroupList"];
            if (groupListArr.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"搜索结果为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
            }
            
            for (NSDictionary * dic in groupListArr) {
                SearchGroupListModel * groupInfoModel = [[SearchGroupListModel alloc]initWithDictionary:dic];
                [self.groupInfoArr addObject:groupInfoModel];
            }
            if (self.groupInfoArr.count >= 1) {
                SearchGrouplistViewController * groupListVc = [[SearchGrouplistViewController alloc]init];
                groupListVc.groupInfoArr = self.groupInfoArr;
            [searchVC.navigationController pushViewController:groupListVc animated:YES];
            }
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            self.searchTypeView.hidden = YES;
            self.imageView.hidden = NO;
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"%@", error);
        self.searchTypeView.hidden = YES;
        self.imageView.hidden = NO;
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.searchBarView.searchTextView]) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }else
    {
        return YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
