//
//  CreatGroupViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CreatGroupViewController.h"
#import "GroupDetailSetTipView.h"
#import "HDPicModle.h"
#import "ChatViewController.h"

@interface CreatGroupViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    MBProgressHUD* hud ;
}
@property (strong, nonatomic) IBOutlet UIImageView *groupIconimageview;
@property (strong, nonatomic) IBOutlet UITextField *groupNameTF;
@property (strong, nonatomic) IBOutlet UIView *gameTypeView;
@property (strong, nonatomic) IBOutlet UILabel *gameTypeLabel;
@property (strong, nonatomic) IBOutlet UIView *groupVerifyView;
@property (strong, nonatomic) IBOutlet UILabel *groupVerifyLabel;
@property (strong, nonatomic) IBOutlet UITextField *groupIntroduceTF;

@property (strong, nonatomic) IBOutlet UIButton *creatGroupBT;
// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;

@property (nonatomic, copy)NSString * iconImageStr;
@property (nonatomic, assign)int GroupType;
@property (nonatomic, assign)int VerificationType;

@end

@implementation CreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.GroupType = 1;
    self.VerificationType = 1;
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"创建群组"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@", self.userIdArrayStr);
}

- (IBAction)changegroupIconAction:(id)sender {
    NSLog(@"选择图片");
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
//    self.groupIconimageview.image = [self imageCompressForWidth:image targetWidth:150.0];
    self.groupIconimageview.image = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"**** %u", [imageData length] / 1024);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)gameTypeAction:(id)sender {
    NSLog(@"选择游戏类型");
    NSArray * typeArr = @[@"吹牛", @"21点"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"游戏模式" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        if ([string isEqualToString:@"21点"]) {
            self.GroupType = 2;
        }else
        {
            self.GroupType = 1;
        }
    }];
    
}
- (IBAction)groupVerifyAction:(id)sender {
    NSLog(@"群组验证");
    NSArray * typeArr = @[@"允许任何人加入", @"不允许任何人加入"];
    GroupDetailSetTipView * setTipView = [[GroupDetailSetTipView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"群组验证" content:typeArr];
    [setTipView show];
    [setTipView getPickerData:^(NSString *string) {
        NSLog(@"%@", string);
        if ([string isEqualToString:@"允许任何人加入"]) {
            self.GroupType = 1;
        }else if([string isEqualToString:@"不允许任何人加入"])
        {
            self.GroupType = 2;
        }
    }];
}
- (IBAction)completeAction:(id)sender {
    
    if (self.groupNameTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"群组名称不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self uploadImage];
    }
    
}

- (void)uploadImage
{
    
    HDPicModle * imageModel = [[HDPicModle alloc]init];
    imageModel.pic = self.groupIconimageview.image;
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
        self.iconImageStr = [dic objectForKey:@"ImgPath"];
        [self completeInformation1];
    } failure:^(NSError * _Nonnull error) {
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
    
    NSString *groupIntroduceStr = @"";
    if (self.groupIntroduceTF.text.length == 0) {
        NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
        fomatter.dateFormat = @"yyyy年MM月dd HH:mm:ss";
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSString *timeStr = [fomatter stringFromDate:date];
        groupIntroduceStr = [NSString stringWithFormat:@"本群创建于%@", timeStr];
    }else
    {
        groupIntroduceStr = self.groupIntroduceTF.text;
    }
    
    NSDictionary * jsonDic = @{
                               @"PortraitUri":self.iconImageStr,
                               @"GroupName":self.groupNameTF.text,
                               @"GroupType":@(self.GroupType),
                               @"VerificationType":@(self.VerificationType),
                               @"MembersId":self.userIdArrayStr,
                               @"Introduce":groupIntroduceStr
                               };
    
    NSString * url = [NSString stringWithFormat:@"%@groups/createGroup?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"responseObject = %@", responseObject);
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (code == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"创建成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            
            [RCDDataSource syncGroups];
            
            RCGroup * groupInfo = [[RCGroup alloc]init];
            groupInfo.groupId = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"GroupId"]];
            groupInfo.groupName = self.groupNameTF.text;
            groupInfo.portraitUri = self.iconImageStr;
            [[RCIM sharedRCIM]refreshGroupInfoCache:groupInfo withGroupId:groupInfo.groupId];
            
            
            ChatViewController * chatVc = [[ChatViewController alloc]init];
            chatVc.hidesBottomBarWhenPushed = YES;
            chatVc.conversationType = ConversationType_GROUP;
            chatVc.displayUserNameInCell = NO;
            chatVc.targetId = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"GroupId"]];
            chatVc.title = self.groupNameTF.text;
            chatVc.needPopToRootView = YES;
            [self.navigationController pushViewController:chatVc animated:YES];
            
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
