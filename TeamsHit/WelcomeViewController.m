//
//  WelcomeViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootView = [[WelcomeView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = self.rootView;
    [self.rootView.experiencebutton addTarget:self action:@selector(experienceAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)experienceAction
{
    LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    UINavigationController *_navi =
    [[UINavigationController alloc] initWithRootViewController:loginVC];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = _navi;
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
