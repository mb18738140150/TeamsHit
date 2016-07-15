//
//  CompleteInformationViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CompleteInformationViewController.h"
#import "AppDelegate.h"
#import "TWSelectCityView.h"
#import "TimeSelectView.h"
#import "HDPicModle.h"
#import "HDNetworking.h"
#import "PublishCircleOfFriendViewController.h"

#import "AFNetworking.h"

@interface CompleteInformationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UITextField *nickNameTF;
@property (strong, nonatomic) IBOutlet UITextField *accountNameTF;
@property (strong, nonatomic) IBOutlet UIButton *genderBT;
@property (strong, nonatomic) IBOutlet UILabel *cityBT;
@property (strong, nonatomic) IBOutlet UILabel *birthBt;

@property (strong, nonatomic) IBOutlet UIButton *completeBT;

// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (nonatomic, copy)NSString * iconImageUrl;// 头像地址连接

@property (nonatomic, strong)UIView * genderChooseView;
@property (nonatomic, strong)UISegmentedControl * genderSegment;

@end

@implementation CompleteInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.completeBT.layer.cornerRadius = 3;
    self.completeBT.layer.masksToBounds = YES;
    
    self.cityBT.userInteractionEnabled = YES;
    UITapGestureRecognizer * cityTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityAction:)];
    [self.cityBT addGestureRecognizer:cityTap];
    
    self.birthBt.userInteractionEnabled = YES;
    UITapGestureRecognizer * birthTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityAction:)];
    [self.birthBt addGestureRecognizer:birthTap];
    
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    [_iconImageView addGestureRecognizer:imageTap];
    
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"完善信息"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择图片
- (void)changeImageAction:(UITapGestureRecognizer *)sender
{
    [self.nickNameTF resignFirstResponder];
    [self.accountNameTF resignFirstResponder];
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
    self.iconImageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self uploadImageWithUrlString];
}


- (IBAction)genderAction:(id)sender {
    NSLog(@"选择性别");
    [self.nickNameTF resignFirstResponder];
    [self.accountNameTF resignFirstResponder];
    
    if (self.genderChooseView) {
        
        if ([self.genderBT.titleLabel.text isEqualToString:@"男"]) {
            self.genderSegment.selectedSegmentIndex = 0;
        }else if ([self.genderBT.titleLabel.text isEqualToString:@"女"])
        {
            self.genderSegment.selectedSegmentIndex = 1;
        }else if ([self.genderBT.titleLabel.text isEqualToString:@"保密"])
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

- (void)cityAction:(UITapGestureRecognizer *)sender
{
    [self.nickNameTF resignFirstResponder];
    [self.accountNameTF resignFirstResponder];
    
    if ([sender.view isEqual:self.cityBT]) {
        TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择地区"];
        __weak typeof(self)blockself = self;
        [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
            blockself.cityBT.text = [NSString stringWithFormat:@"%@,%@,%@",proviceStr,cityStr, distr];
        }];
    }else
    {
        TimeSelectView * time = [[TimeSelectView alloc]initWithFrame:self.view.bounds];
        __weak typeof(self)blockself = self;
        [time showTimeSelectView:^(NSString *yearStr, NSString *monthStr, NSString *dayStr) {
             blockself.birthBt.text = [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
        }];
    }
}

- (IBAction)completeAction:(id)sender {
    NSLog(@"完成");
    
    [self completeInformation];
}

- (void)uploadImage
{
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
        self.iconImageUrl = [responseObject objectForKey:@"ImgPath"];
//        [self completeInformation1];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择性别弹框

- (void)creatGenderChooseView
{
    self.genderChooseView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.genderChooseView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.4];
    
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderChooseViewDismiss)];
    [self.genderChooseView addGestureRecognizer:dismissTap];
    
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
    doneBT.frame = CGRectMake(backView.hd_x + backView.hd_width - 60, self.genderSegment.hd_y + self.genderSegment.hd_height + 43, 30, 30);
    [doneBT setTitle:@"确定" forState:UIControlStateNormal];
    doneBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBT setTitleColor:UIColorFromRGB(0x0A96CD) forState:UIControlStateNormal];
    [doneBT addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:doneBT];
    
    UIButton * calcleBT = [UIButton buttonWithType:UIButtonTypeCustom];
    calcleBT.frame = CGRectMake(doneBT.hd_x  - 64, self.genderSegment.hd_y + self.genderSegment.hd_height + 43, 30, 30);
    [calcleBT setTitle:@"取消" forState:UIControlStateNormal];
    [calcleBT setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [backView addSubview:calcleBT];
    calcleBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [calcleBT addTarget:self action:@selector(genderChooseViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.genderBT.titleLabel.text isEqualToString:@"男"]) {
        self.genderSegment.selectedSegmentIndex = 0;
    }else if ([self.genderBT.titleLabel.text isEqualToString:@"女"])
    {
        self.genderSegment.selectedSegmentIndex = 1;
    }else if ([self.genderBT.titleLabel.text isEqualToString:@"保密"])
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
        [self.genderBT setTitle:@"男" forState:UIControlStateNormal];
    }else if (self.genderSegment.selectedSegmentIndex == 1)
    {
        [self.genderBT setTitle:@"女" forState:UIControlStateNormal];
    }else
    {
        [self.genderBT setTitle:@"保密" forState:UIControlStateNormal];
    }
    [self.genderChooseView removeFromSuperview];
}

- (void)genderChooseViewDismiss
{
    [self.genderChooseView removeFromSuperview];
}

#pragma mark - 完善资料请求
- (void)completeInformation
{
    
     [self uploadImage];
    
    PublishCircleOfFriendViewController * pVC = [[PublishCircleOfFriendViewController alloc]init];
    
//    [self.navigationController pushViewController:pVC animated:YES];

    
    self.iconImageUrl = @"isdbfj";
    
    if (self.nickNameTF.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入昵称" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.accountNameTF.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if ([self.genderBT.titleLabel.text isEqualToString:@"请选择"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择性别" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.cityBT.text.length == 0 || [self.cityBT.text isEqualToString:@"请选择"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择所在城市" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.birthBt.text.length == 0 || [self.birthBt.text isEqualToString:@"请选择"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择出生日期" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else
    {
        [self uploadImage];
    }
}

- (void)completeInformation1
{
    self.iconImageUrl = @"hhhh";
    
    NSArray * cityArr = [self.cityBT.text componentsSeparatedByString:@","];
    
    NSDictionary * jsonDic = @{
                               @"IconUrl":self.iconImageUrl,
                               @"NickName":self.nickNameTF.text,
                               @"UserName":self.accountNameTF.text,
                               @"Province":cityArr[0],
                               @"Gender":self.genderBT.titleLabel.text,
                               @"City":cityArr[1],
                               @"BirthDate":self.birthBt.text
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@userinfo/completeInformation?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
         NSLog(@"responseObject = %@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
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
