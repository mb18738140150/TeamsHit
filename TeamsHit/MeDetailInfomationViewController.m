//
//  MeDetailInfomationViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/15.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MeDetailInfomationViewController.h"
#import "AppDelegate.h"
#import "TWSelectCityView.h"
#import "ChangeEquipmentNameView.h"
#import "HDPicModle.h"

@interface MeDetailInfomationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *completeBT;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (nonatomic, copy)NSString * birth;
// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (nonatomic, copy)NSString * iconImageUrl;// 头像地址连接
// 性别选择弹框
@property (nonatomic, strong)UIView * genderChooseView;
@property (nonatomic, strong)UISegmentedControl * genderSegment;
// 修改昵称
@property (nonatomic, strong)ChangeEquipmentNameView  * changeNameView;
@end

@implementation MeDetailInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.title = @"个人资料";
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    _iconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeinfo:)];
    [self.iconImageView addGestureRecognizer:imageTap];
    
    UITapGestureRecognizer * nickTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeinfo:)];
    [self.nickNameLabel addGestureRecognizer:nickTap];
    
    UITapGestureRecognizer * genderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeinfo:)];
    [self.genderLabel addGestureRecognizer:genderTap];
    
    UITapGestureRecognizer * cityTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeinfo:)];
    [self.addressLabel addGestureRecognizer:cityTap];
    
    [self getUserInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
}
- (void)getUserInfo
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    
    __weak MeDetailInfomationViewController * infoVC = self;
    [[HDNetworking sharedHDNetworking]getDetailInfor:nil success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
            
            [infoVC.iconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"PortraitUri"]] placeholderImage:[UIImage imageNamed:@"camera_icon.png"]];
            infoVC.userNameLabel.text = [dic objectForKey:@"UserName"];
            infoVC.genderLabel.text = [dic objectForKey:@"Gender"];
            infoVC.addressLabel.text = [dic objectForKey:@"City"];
            infoVC.nickNameLabel.text = [dic objectForKey:@"NickName"];
            infoVC.birth = [dic objectForKey:@"BirthDate"];
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
    
    
//    NSString * url = [NSString stringWithFormat:@"%@userinfo/getDetailInfor?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
//    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:nil progress:^(NSProgress * _Nullable progress) {
//        ;
//    } success:^(id  _Nonnull responseObject) {
//        [hud hide:YES];
//        NSLog(@"responseObject = %@", responseObject);
//        int code = [[responseObject objectForKey:@"Code"] intValue];
//        if (code == 200) {
//            NSDictionary * dic = [responseObject objectForKey:@"DetailInfor"];
//            
//            [infoVC.iconImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"PortraitUri"]] placeholderImage:[UIImage imageNamed:@"camera_icon.png"]];
//            infoVC.userNameLabel.text = [dic objectForKey:@"UserName"];
//            infoVC.genderLabel.text = [dic objectForKey:@"Gender"];
//            infoVC.addressLabel.text = [dic objectForKey:@"City"];
//            infoVC.nickNameLabel.text = [dic objectForKey:@"NickName"];
//            infoVC.birth = [dic objectForKey:@"BirthDate"];
//        }else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
//        }
//        
//    } failure:^(NSError * _Nonnull error) {
//        [hud hide:YES];
//        NSLog(@"%@", error);
//    }];
}


#pragma mark - 修改信息
- (void)changeinfo:(UITapGestureRecognizer *)sender
{
    if ([sender.view isEqual:_nickNameLabel]) {
        [self changeNickName];
    }else if ([sender.view isEqual:_genderLabel])
    {
        [self genderAction];
    }else if ([sender.view isEqual:_addressLabel])
    {
        [self cityAction];
    }else if ([sender.view isEqual:_iconImageView])
    {
        [self changeImageAction];
    }
}

#pragma mark - 选择图片
- (void)changeImageAction
{
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertcontroller addAction:cancleAction];
    [alertcontroller addAction:cameraAction];
    [alertcontroller addAction:libraryAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.iconImageView.image = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"**** %u", [imageData length] / 1024);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (UIImagePNGRepresentation(image) != nil) {
        NSLog(@" *** png");
    }else if (UIImageJPEGRepresentation(image, 1.0) != nil )
    {
        NSLog(@" *** jpeg");
    }
    
    //    [self uploadImageWithUrlString];
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - nickname

- (void)changeNickName
{
    if (self.changeNameView) {
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:self.changeNameView];
        self.changeNameView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.changeNameView.alpha = 1;
        }];
    }else
    {
        NSArray * nibarr = [[NSBundle mainBundle]loadNibNamed:@"ChangeEquipmentNameView" owner:self options:nil];
        self.changeNameView = [nibarr objectAtIndex:0];
        CGRect tmpFrame = [[UIScreen mainScreen] bounds];
        self.changeNameView.frame = tmpFrame;
        self.changeNameView.equipmentNameTF.delegate = self.changeNameView;
        self.changeNameView.title = @"昵称";
        self.changeNameView.titleLabel.text = @"修改昵称";
        self.changeNameView.equipmentNameTF.placeholder = @"请输入昵称";
        self.changeNameView.equipmentNameTF.text = self.nickNameLabel.text;
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        [delegate.window addSubview:self.changeNameView];
        self.changeNameView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.changeNameView.alpha = 1;
        }];
        __weak MeDetailInfomationViewController * meVC = self;
        [self.changeNameView getEquipmentOption:^(NSString *name) {
            NSLog(@"name = %@", name);
            [meVC.changeNameView removeFromSuperview];
            meVC.nickNameLabel.text = name;
        }];
    }
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
- (void)cityAction
{
        TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择地区"];
        __weak typeof(self)blockself = self;
        [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
            blockself.addressLabel.text = [NSString stringWithFormat:@"%@,%@,%@",proviceStr,cityStr, distr];
        }];
}

#pragma mark - 性别弹框
- (void)genderAction {
    NSLog(@"选择性别");
    
    if (self.genderChooseView) {
        
        if ([self.genderLabel.text isEqualToString:@"男"]) {
            self.genderSegment.selectedSegmentIndex = 0;
        }else if ([self.genderLabel.text isEqualToString:@"女"])
        {
            self.genderSegment.selectedSegmentIndex = 1;
        }else if ([self.genderLabel.text isEqualToString:@"保密"])
        {
            self.genderSegment.selectedSegmentIndex = 2;
        }
        
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        
        [delegate.window addSubview:self.genderChooseView];
        
        self.genderChooseView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.genderChooseView.alpha = 1;
        }];
        
    }else
    {
        [self creatGenderChooseView];
    }
    
}

- (void)creatGenderChooseView
{
    self.genderChooseView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.genderChooseView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.4];
    
//    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderChooseViewDismiss)];
//    [self.genderChooseView addGestureRecognizer:dismissTap];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.genderChooseView.hd_width - 30, 191)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    backView.center = self.genderChooseView.center;
    [self.genderChooseView addSubview:backView];
    
    UILabel * genderChooseLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 68, 16)];
    genderChooseLB.backgroundColor = [UIColor whiteColor];
    genderChooseLB.text = @"选择性别";
    genderChooseLB.font = [UIFont systemFontOfSize:16];
    genderChooseLB.textColor = UIColorFromRGB(0x323232);
    [backView addSubview:genderChooseLB];
    
    self.genderSegment = [[UISegmentedControl alloc]initWithItems:@[@"男", @"女", @"保密"]];
    self.genderSegment.frame = CGRectMake(20, genderChooseLB.hd_y + genderChooseLB.hd_height + 30, backView.hd_width - 40, 40);
    
    
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: UIColorFromRGB(0x323232)};
    [self.genderSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.genderSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    self.genderSegment.tintColor = UIColorFromRGB(0x0A96CD);
    [backView addSubview:self.genderSegment];
    
    UIButton * doneBT = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBT.frame = CGRectMake(backView.hd_x + backView.hd_width - 70, self.genderSegment.hd_y + self.genderSegment.hd_height + 43, 40, 30);
    [doneBT setTitle:@"确定" forState:UIControlStateNormal];
    doneBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBT setTitleColor:UIColorFromRGB(0x0A96CD) forState:UIControlStateNormal];
    [doneBT addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:doneBT];
    
    UIButton * calcleBT = [UIButton buttonWithType:UIButtonTypeCustom];
    calcleBT.frame = CGRectMake(doneBT.hd_x  - 74, self.genderSegment.hd_y + self.genderSegment.hd_height + 43, 40, 30);
    [calcleBT setTitle:@"取消" forState:UIControlStateNormal];
    [calcleBT setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [backView addSubview:calcleBT];
    calcleBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [calcleBT addTarget:self action:@selector(genderChooseViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.genderLabel.text isEqualToString:@"男"]) {
        self.genderSegment.selectedSegmentIndex = 0;
    }else if ([self.genderLabel.text isEqualToString:@"女"])
    {
        self.genderSegment.selectedSegmentIndex = 1;
    }else if ([self.genderLabel.text isEqualToString:@"保密"])
    {
        self.genderSegment.selectedSegmentIndex = 2;
    }
    
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:self.genderChooseView];
    self.genderChooseView.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.genderChooseView.alpha = 1;
    }];
}

- (void)doneAction:(UIButton *)button
{
    if(self.genderSegment.selectedSegmentIndex == 0)
    {
        self.genderLabel.text = @"男";
    }else if (self.genderSegment.selectedSegmentIndex == 1)
    {
        self.genderLabel.text = @"女";
    }else
    {
        self.genderLabel.text = @"保密";
    }
    [self.genderChooseView removeFromSuperview];
}

- (void)genderChooseViewDismiss
{
    [self.genderChooseView removeFromSuperview];
}

#pragma mark - 完成
- (IBAction)completeAction:(id)sender {
    [self uploadImage];
}

- (void)uploadImage
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"修改中...";
    [hud show:YES];
    
    HDPicModle * imageModel = [[HDPicModle alloc]init];
    imageModel.pic = self.iconImageView.image;
    imageModel.picName = [self imageName];
    imageModel.picFile = [[self getLibraryCachePath] stringByAppendingPathComponent:imageModel.picName];
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@", POST_IMAGE_URL, @"1"];
    NSString * url = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[HDNetworking sharedHDNetworking] POST:url parameters:nil andPic:imageModel progress:^(NSProgress * _Nullable progress) {
        NSLog(@"progress = %lf", 1.0 * progress.completedUnitCount / progress.totalUnitCount);
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"上传成功");
        NSLog(@"responseObject = %@", responseObject);
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"dic = %@", dic);
        self.iconImageUrl = [dic objectForKey:@"ImgPath"];
        [self completeInformation1];
    } failure:^(NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"error = %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"图片上传失败，请重新提交" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
        NSLog(@"上传失败");
    }];
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
    //    self.iconImageUrl = @"hhhh";
    
    NSArray * cityArr = [self.addressLabel.text componentsSeparatedByString:@","];
    NSString * Province = nil;
    NSString * city = nil;
    if (cityArr.count > 1) {
        Province = cityArr[0];
        city = cityArr[1];
    }else
    {
        Province = @"";
        city = @"请选择";
    }
    
    NSDictionary * jsonDic = @{
                               @"IconUrl":self.iconImageUrl,
                               @"NickName":self.nickNameLabel.text,
                               @"UserName":self.userNameLabel.text,
                               @"Province":Province,
                               @"Gender":self.genderLabel.text,
                               @"City":city,
                               @"BirthDate":@""
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/completeInformation?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            [RCDHTTPTOOL refreshUserInfoByUserID:[RCIM sharedRCIM].currentUserInfo.userId];
            
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
