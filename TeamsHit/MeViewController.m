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

@interface MeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;
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
    
//    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self presentViewController:self.imagePic animated:YES completion:nil];
//        }else
//        {
//            UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                ;
//            }];
//            [tipControl addAction:sureAction];
//            [self presentViewController:tipControl animated:YES completion:nil];
//            
//        }
//    }];
//    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:self.imagePic animated:YES completion:nil];
//    }];
//    
//    [alertcontroller addAction:cancleAction];
//    [alertcontroller addAction:cameraAction];
//    [alertcontroller addAction:libraryAction];
    
//    [self presentViewController:alertcontroller animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@", [info description]);
    
    self.iconImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    [self uploadImageWithUrlString];
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
