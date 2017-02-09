//
//  GraffitiViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GraffitiViewController.h"
#import "GraffitiView.h"


@interface GraffitiViewController ()<PrintGraffitiDelegate>
@property (nonatomic, copy)GraffitiImageBlock graffitiImage;
@property (nonatomic, strong)GraffitiView * graffitiView;

@end

@implementation GraffitiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"涂鸦板";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.graffitiView = [[GraffitiView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height) image:self.sourceimage];
    _graffitiView.delegate = self;
    [self.view addSubview:_graffitiView];
    
    // Do any additional setup after loading the view.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)done
{
    if (self.graffitiImage) {
        _graffitiImage([self.graffitiView getGraffitiImage]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)graffitiImage:(GraffitiImageBlock)processImage
{
    self.graffitiImage = [processImage copy];
}
- (void)printGraffitiImage
{
    [[Print sharePrint] printImage:[self.graffitiView getGraffitiImage] taskType:@0 toUserId:self.userId];
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
