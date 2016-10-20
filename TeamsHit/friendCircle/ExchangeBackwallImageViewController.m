//
//  ExchangeBackwallImageViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ExchangeBackwallImageViewController.h"
#import "HDPicModle.h"
@interface ExchangeBackwallImageViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    MBProgressHUD * hud;
}
@property (nonatomic, copy)BackWallImageBlock myblock;

// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (nonatomic, copy)NSString * wallImageUrl;// 头像地址连接
@property (nonatomic, copy)UIImage * wallImage;

@end

@implementation ExchangeBackwallImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"更换背景封面"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectFromLibrary:(id)sender {
    NSLog(@"相册选取");
    self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePic animated:YES completion:nil];
}
- (IBAction)getPhoneFromCamera:(id)sender {
    NSLog(@"拍照");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }else
    {
        UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ;
        }];
        [tipControl addAction:sureAction];
        [self presentViewController:tipControl animated:YES completion:nil];
        
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.wallImage = image;
    HDPicModle * imageModel = [[HDPicModle alloc]init];
    imageModel.pic = self.wallImage;
    imageModel.picName = [self imageName];
    imageModel.picFile = [[self getLibraryCachePath] stringByAppendingPathComponent:imageModel.picName];
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@", POST_IMAGE_URL, @"4"];
    NSString * url = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"上传中...";
    [hud show:YES];
    [[HDNetworking sharedHDNetworking] POST:url parameters:nil andPic:imageModel progress:^(NSProgress * _Nullable progress) {
        NSLog(@"progress = %lf", 1.0 * progress.completedUnitCount / progress.totalUnitCount);
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"上传成功");
        NSLog(@"responseObject = %@", responseObject);
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"dic = %@", dic);
        self.wallImageUrl = [dic objectForKey:@"ImgPath"];
        [self completeInformation1];
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"error = %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"图片上传失败，请重新提交" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        NSLog(@"上传失败");
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (NSString *)imageName
{
    NSDateFormatter * myFormatter = [[NSDateFormatter alloc]init];
    [myFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * strTime = [myFormatter stringFromDate:[NSDate date]];
    NSString * name = [NSString stringWithFormat:@"t%@%lld.png",  strTime, arc4random() % 9000000000 + 1000000000];
    return name;
}

- (NSString *)getLibraryCachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)completeInformation1
{
    
    
    NSDictionary * jsonDic = @{
                               @"CoverUrl":self.wallImageUrl
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@new/changeFriendCircleCover?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            if (self.myblock) {
                _myblock(self.wallImage);
            }
            [self.navigationController popViewControllerAnimated:NO];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器连接失败,请重新操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        NSLog(@"%@", error);
    }];
}

- (void)getBackWallImage:(BackWallImageBlock)block
{
    self.myblock = [block copy];
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
