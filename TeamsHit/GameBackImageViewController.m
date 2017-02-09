//
//  GameBackImageViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/2/6.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "GameBackImageViewController.h"
#import "GameBackImageCollectionViewCell.h"

#define GAMEBACKIMAGECELLID @"GameBackImageCollectionViewCellid"

@interface GameBackImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * backImagecollectionview;
@property (nonatomic, strong)NSMutableArray * backImagedata;

@end

@implementation GameBackImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    self.title = @"游戏背景";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.backImagedata = [NSMutableArray array];
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, .7)];
    topline.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
    [self.view addSubview:topline];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 14;
    layout.itemSize = CGSizeMake((self.view.hd_width - 32 - 15 * 2) / 3, (self.view.hd_width - 32 - 15 * 2) / 3 * 2.2);
    layout.minimumLineSpacing = 1;
    
    self.backImagecollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 10, self.view.hd_width - 32, self.view.hd_height - 20) collectionViewLayout:layout];
    [self.backImagecollectionview registerClass:[GameBackImageCollectionViewCell class] forCellWithReuseIdentifier:GAMEBACKIMAGECELLID];
    self.backImagecollectionview.delegate = self;
    self.backImagecollectionview.dataSource = self;
    self.backImagecollectionview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backImagecollectionview];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"GamebackImage" ofType :@"bundle"];
    
    for (int i = 0; i < 5; i++) {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent :[NSString stringWithFormat:@"gamebackimagename%d.png", i]];
        [self.backImagedata addObject:[UIImage imageWithContentsOfFile:imgPath]];
    }
    
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.backImagedata.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameBackImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:GAMEBACKIMAGECELLID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.backImage.image = [self.backImagedata objectAtIndex:indexPath.item];
    __weak GameBackImageViewController * weakself = self;
    [cell selectgamebackImage:^{
        [weakself selectBackImage:indexPath.item];
    }];
    
    return cell;
}

- (void)selectBackImage:(int)number
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeGamebackImage" object:nil userInfo:@{@"displayName":[NSString stringWithFormat:@"%d", number]}];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"设置成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
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
