//
//  MeViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MeViewController.h"
#import "ProcessingImagesViewController.h"
#import "MaterialViewController.h"
#import "EquipmentManagerViewController.h"

@interface MeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;


@property (strong, nonatomic) IBOutlet UIView *equipmentmanagerView;
@property (strong, nonatomic) IBOutlet UIImageView *equipmentImage;
@property (strong, nonatomic) IBOutlet UILabel *equipmentLB;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"navigationlogo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    _iconImageView.userInteractionEnabled = YES;
    [_iconImageView addGestureRecognizer:imageTap];
    
    self.imagePic = [[UIImagePickerController alloc] init];
//    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    self.equipmentImage.userInteractionEnabled = YES;
    self.equipmentLB.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * equipmentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(equipmentAction:)];
    [self.equipmentmanagerView addGestureRecognizer:equipmentTap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark - 选择图片
- (void)changeImageAction:(UITapGestureRecognizer *)sender
{
    
    MaterialViewController * processVC = [[MaterialViewController alloc]init];
    processVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:processVC animated:YES];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@", [info description]);
    
    self.iconImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    [self uploadImageWithUrlString];
}

- (void)equipmentAction:(UITapGestureRecognizer *)sender
{
    EquipmentManagerViewController * equipmentVC = [[EquipmentManagerViewController alloc]initWithNibName:@"EquipmentManagerViewController" bundle:nil];
    
    equipmentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:equipmentVC animated:YES];
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
