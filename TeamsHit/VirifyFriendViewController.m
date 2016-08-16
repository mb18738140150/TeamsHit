//
//  VirifyFriendViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "VirifyFriendViewController.h"

@interface VirifyFriendViewController ()<UITextFieldDelegate>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UITextField *verifyTF;
@property (strong, nonatomic) IBOutlet UIButton *deleteVerifydetailBT;
@property (strong, nonatomic) IBOutlet UIButton *forbidFriendCircle;

@end

@implementation VirifyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"朋友验证"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"title_right_icon"] title:@"发送"];
    [rightBarItem addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    self.deleteVerifydetailBT.hidden = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_verifyTF];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction
{
    NSLog(@"发送");
    NSString * str = nil;
    if (self.verifyTF.text && self.verifyTF.text.length != 0) {
        str = self.verifyTF.text;
    }else
    {
        str = @"";
    }
    
    NSDictionary * jsonDic = @{
                               @"TargetId":self.userId,
                               @"LeaveMsg":str,
                               @"ApplyId":@0,
                               @"Type":@1
                               };
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发送请求中...";
    [hud show:YES];
    NSString * url = [NSString stringWithFormat:@"%@userinfo/operationFriend?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    __weak VirifyFriendViewController * verifyVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送请求成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            [verifyVC.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
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
}

- (void)textFieldChanged:(id)sender
{
    if (_verifyTF.text.length > 0) {
        self.deleteVerifydetailBT.hidden = NO;
    }else
    {
        self.deleteVerifydetailBT.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)forbidFriendCircle:(id)sender {
    UIButton * button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        NSLog(@"禁止看朋友圈");
        [button setImage:[[UIImage imageNamed:@"forbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else
    {
        NSLog(@"可以看朋友圈");
        [button setImage:[[UIImage imageNamed:@"noForbid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
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
