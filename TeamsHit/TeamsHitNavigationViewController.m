//
//  TeamsHitNavigationViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TeamsHitNavigationViewController.h"

@interface TeamsHitNavigationViewController ()
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UIView * backView;
@end

@implementation TeamsHitNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController * rootVC = (UINavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    
//    if ([rootVC isKindOfClass:[UINavigationController class]]) {
    
        self.backBT = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBT.frame = CGRectMake(0, 0, 40, 40);
        [self.backBT setImage:[UIImage imageNamed:@"password_hide"] forState:UIControlStateNormal];
        
        self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 20, 40)];
        self.titleLB.textAlignment = 1;
        
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        [self.backView addSubview:self.backBT];
        [self.backView addSubview:self.titleLB];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backView];
//    }
    
    
    // Do any additional setup after loading the view.
}

- (void)setTitletext:(NSString *)titletext
{
    CGSize lableSize = [titletext hd_sizeWithFont:[UIFont systemFontOfSize:16] andMaxSize:CGSizeMake(CGFLOAT_MAX, self.titleLB.hd_height)];
    self.titleLB.hd_width = lableSize.width;
    self.backView.hd_width = lableSize.width + 40;
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
