//
//  PublishCircleOfFriendViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PublishCircleOfFriendViewController.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "PublishCollectionViewCell.h"

#import "HDPicModle.h"

#define kPublishCellID @"PublishCellID"

@interface PublishCircleOfFriendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>
{
    MBProgressHUD* hud ;
}

@property (nonatomic, copy)PublishBlock myPublishBlock;

@property (nonatomic, strong)UIScrollView * publishScrollView;

@property (nonatomic, strong)UIView * informationView;
@property (nonatomic, strong)UITextView * ideaTextView;
@property (nonatomic, strong)UICollectionView * phoneCollectionView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray * imageUrlArr;

@property (nonatomic, strong)UIView * permissionView;

@end

@implementation PublishCircleOfFriendViewController

- (NSMutableArray *)imageUrlArr
{
    if (!_imageUrlArr) {
        self.imageUrlArr = [NSMutableArray array];
    }
    return _imageUrlArr;
}

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"发布朋友圈"];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    TeamHitBarButtonItem * rightBarItem = [TeamHitBarButtonItem rightButtonWithImage:[UIImage imageNamed:@"title_right_icon"] title:@"发表"];
    [rightBarItem setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    
    
    [self creatSubViews];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)publishAction:(UIButton *)button
{
    NSLog(@"发表");
    
    if (self.ideaTextView.text.length == 0 && self.imageUrlArr.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"内容与图片不能全部为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self uploadImage];
    }
}
- (void)creatSubViews
{
    self.publishScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.publishScrollView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:self.publishScrollView];
    
    self.informationView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, self.view.hd_width, 240)];
    self.informationView.backgroundColor = [UIColor whiteColor];
    [self.publishScrollView addSubview:self.informationView];
    
    self.ideaTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 12, self.informationView.hd_width, 135)];
    self.ideaTextView.textColor = UIColorFromRGB(0xBBBBBB);
    self.ideaTextView.text = @"这一刻的想法...";
    self.ideaTextView.delegate = self;
    [self.informationView addSubview:self.ideaTextView];
    
    // uicollectionViewFlowLayout继承于 UICollectionViewLayout
    // 是专门用来处理UICollectionView 的布局问题
    // 创建用来布局的flowLayout对象
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    // 设置item大小
    layout.itemSize = CGSizeMake((self.informationView.hd_width - 64) / 4, (self.informationView.hd_width - 64) / 4);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    // item之间最小间距
    layout.minimumInteritemSpacing = 8;
    
    // item最小行间距
    layout.minimumLineSpacing = 10;
    
    // 集合视图滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.phoneCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.informationView.hd_y + self.informationView.hd_height - (self.informationView.hd_width - 64) / 4 - 15, self.informationView.hd_width, (self.informationView.hd_width - 64) / 4 + 30) collectionViewLayout:layout];
    self.phoneCollectionView.delegate = self;
    self.phoneCollectionView.dataSource = self;
    
    self.phoneCollectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册item
    [self.phoneCollectionView registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:kPublishCellID];
    
    [self.informationView addSubview:self.phoneCollectionView];
    
    self.permissionView = [[UIView alloc]initWithFrame:CGRectMake(0, self.informationView.hd_y + self.informationView.hd_height + 30, self.publishScrollView.hd_width, 50)];
    self.permissionView.backgroundColor = [UIColor cyanColor];
    [self.publishScrollView addSubview:self.permissionView];
    
    self.phoneCollectionView.contentSize = CGSizeMake(self.phoneCollectionView.hd_width, self.permissionView.hd_height + self.permissionView.hd_y + 30);
}

#pragma mark - UIcollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.assets.count >= 9) {
        return self.assets.count;
    }else
    {
        return self.assets.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接重用cell，不用创建，因为仓库里没有cell的话，collectionView会自己创建该wifeCell,不用我们管（更深层次的原因是，我们已经把wifeCell注册给collectionView了，所以collectionView会自己完成cell的创建工作）
    PublishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPublishCellID forIndexPath:indexPath];
    if (self.assets.count == 0 || (self.assets.count < 9 && indexPath.row == self.assets.count)) {
        cell.photoImageView.image = [UIImage imageNamed:@"upload"];
    }else
    {
        MLSelectPhotoAssets *asset = self.assets[indexPath.row];
        cell.photoImageView.image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
    }
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.assets.count == 0 || (self.assets.count < 9 && indexPath.row == self.assets.count)) {
        // 创建控制器
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.maxCount = kPhotoShowMaxCount - self.assets.count;
        [pickerVc showPickerVc:self];
        __weak typeof(self) weakSelf = self;
        pickerVc.callBack = ^(NSArray *assets){
            [weakSelf.assets addObjectsFromArray:assets];
            
            if (weakSelf.assets.count > 3 && weakSelf.assets.count < 8) {
                weakSelf.phoneCollectionView.hd_height = (self.informationView.hd_width - 64) / 4 * 2 + 30;
                weakSelf.informationView.hd_height = weakSelf.phoneCollectionView.hd_height + weakSelf.phoneCollectionView.hd_y;
                
                weakSelf.permissionView.hd_y = weakSelf.informationView.hd_y + weakSelf.informationView.hd_height + 30;
                
            }else if (weakSelf.assets.count >= 8)
            {
                weakSelf.phoneCollectionView.hd_height = (self.informationView.hd_width - 64) / 4 * 3 + 40;
                weakSelf.informationView.hd_height = weakSelf.phoneCollectionView.hd_height + weakSelf.phoneCollectionView.hd_y;
                weakSelf.permissionView.hd_y = weakSelf.informationView.hd_y + weakSelf.informationView.hd_height + 30;
            }
            weakSelf.phoneCollectionView.contentSize = CGSizeMake(weakSelf.phoneCollectionView.hd_width, self.permissionView.hd_height + weakSelf.permissionView.hd_y + 30);
            [weakSelf.phoneCollectionView reloadData];
        };
    }else
    {
        MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
        browserVc.currentPage = indexPath.row;
        browserVc.photos = self.assets;
        [self.navigationController pushViewController:browserVc animated:YES];
    }
}

#pragma mark - uitextviewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"这一刻的想法..."]) {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"内容改变了");
    if ([textView.text containsString:@"这一刻的想法..."]) {
        NSMutableString * str = [[NSMutableString alloc]initWithString:textView.text];
        NSRange range = [str rangeOfString:@"这一刻的想法..."];
        [str deleteCharactersInRange:range];
        textView.text = str;
        textView.textColor = UIColorFromRGB(0x323232);
    }else if (textView.text.length == 0)
    {
        textView.text = @"这一刻的想法...";
        textView.textColor = UIColorFromRGB(0xBBBBBB);
    }
    
}

#pragma mark - 上传图片
- (void)uploadImage
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"图片上传中...";
    NSLog(@"***** 上传图片");
    [hud show:YES];
    
    if (self.assets.count > 1) {
        
        NSMutableArray * imageArr = [NSMutableArray array];
        
        
        for (int i = 0; i < self.assets.count; i++) {
            MLSelectPhotoAssets *asset = self.assets[i];
            
            HDPicModle * imageModel = [[HDPicModle alloc]init];
            imageModel.pic = asset.originImage;
            imageModel.picName = [self imageName];
            imageModel.picFile = [[self getLibraryCachePath] stringByAppendingPathComponent:imageModel.picName];
            
            [imageArr addObject:imageModel];
            
            
        }
        NSString * imageUrl = [NSString stringWithFormat:@"%@%@", POST_IMAGE_URL, @"2"];
        NSString * url = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [[HDNetworking sharedHDNetworking] POST:url parameters:nil andPicArray:imageArr progress:^(NSProgress * _Nullable progress) {
            NSLog(@"progress = %lf", 1.0 * progress.completedUnitCount / progress.totalUnitCount);
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"上传成功");
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSString * strImage = [dic objectForKey:@"ImgPath"];
            NSArray * imageurlArr = [strImage componentsSeparatedByString:@","];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (NSString * imageUrlStr in imageurlArr) {
                    [self.imageUrlArr addObject:imageUrlStr];
                }
                NSLog(@"dic = %@", dic);
                [self publishShuoshuo];
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error = %@", error);
            NSLog(@"上传失败");
            
        }];
        
        
        // 以下方式为并发上传多张图片，但是不能保证图片上传结束顺序
//        dispatch_group_t group = dispatch_group_create();
//        dispatch_queue_t queue = dispatch_queue_create("cn.gcd-group.www", DISPATCH_QUEUE_CONCURRENT);
//        
//        for (int i = 0; i < self.assets.count; i++) {
//            MLSelectPhotoAssets *asset = self.assets[i];
//            
//            HDPicModle * imageModel = [[HDPicModle alloc]init];
//            imageModel.pic = asset.originImage;
//            imageModel.picName = [self imageName];
//            imageModel.picFile = [[self getLibraryCachePath] stringByAppendingPathComponent:imageModel.picName];
//            NSString * imageUrl = [NSString stringWithFormat:@"%@%@", POST_IMAGE_URL, @"2"];
//            NSString * url = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//            
//            
//            dispatch_group_enter(group);
//            dispatch_async(queue, ^{
//                [[HDNetworking sharedHDNetworking] POST:url parameters:nil andPic:imageModel progress:^(NSProgress * _Nullable progress) {
//                    NSLog(@"progress = %lf", 1.0 * progress.completedUnitCount / progress.totalUnitCount);
//                } success:^(id  _Nonnull responseObject) {
//                    NSLog(@"上传成功");
//                    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//                    NSLog(@"dic = %@", dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.imageUrlArr addObject:[dic objectForKey:@"ImgPath"]];
//                        dispatch_group_leave(group);
//                    });
//                } failure:^(NSError * _Nonnull error) {
//                    NSLog(@"error = %@", error);
//                    NSLog(@"上传失败");
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        dispatch_group_leave(group);
//                    });
//                }];
//            });
//            
//        }
//        
//        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self publishShuoshuo];
//                [hud hide:YES];
//            });
//        });
        
        
    }else if(self.assets.count == 1)
    {
        HDPicModle * imageModel = [[HDPicModle alloc]init];
        imageModel.pic = [[self.assets firstObject] originImage];
        imageModel.picName = [self imageName];
        imageModel.picFile = [[self getLibraryCachePath] stringByAppendingPathComponent:imageModel.picName];
        NSString * imageUrl = [NSString stringWithFormat:@"%@%@", POST_IMAGE_URL, @"2"];
        NSString * url = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [[HDNetworking sharedHDNetworking] POST:url parameters:nil andPic:imageModel progress:^(NSProgress * _Nullable progress) {
            NSLog(@"progress = %lf", 1.0 * progress.completedUnitCount / progress.totalUnitCount);
        } success:^(id  _Nonnull responseObject) {
            [hud hide:YES];
            NSLog(@"上传成功");
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"dic = %@", dic);
            [self.imageUrlArr addObject:[dic objectForKey:@"ImgPath"]];
            [self publishShuoshuo];
        } failure:^(NSError * _Nonnull error) {
            [hud hide:YES];
            NSLog(@"error = %@", error);
            NSLog(@"上传失败");
        }];
    }else
    {
        [self publishShuoshuo];
    }
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

- (void)publishShuoshuo
{
    NSString * imageUrlStr = @"";
    for (int i = 0; i < self.imageUrlArr.count; i++) {
        if (i == 0) {
            imageUrlStr = self.imageUrlArr.firstObject;
        }else
        {
            imageUrlStr = [imageUrlStr stringByAppendingString:[NSString stringWithFormat:@",%@", self.imageUrlArr[i]]];
        }
        
    }
    [hud hide:YES];
    hud = nil;
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发布中...";
    [hud show:YES];
    NSDictionary * jsonDic = @{
                               @"TakeContent":self.ideaTextView.text,
                               @"PhotoLists":imageUrlStr
                               };
    
    NSLog(@"imageUrlStr = %@", imageUrlStr);
    
    NSString * url = [NSString stringWithFormat:@"%@news/publishTake?token=%@", POST_URL, [UserInfo shareUserInfo].userToken];
    
    __weak PublishCircleOfFriendViewController * addVC = self;
    [[HDNetworking sharedHDNetworking] POSTwithToken:url parameters:jsonDic progress:^(NSProgress * _Nullable progress) {
        ;
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [hud hide:YES];
        int command = [[responseObject objectForKey:@"Command"] intValue];
        int code = [[responseObject objectForKey:@"Code"] intValue];
        if (command == 10029) {
            if (code == 200) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发布成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                
                if (self.myPublishBlock) {
                    
                    WFMessageBody * messageBody = [[WFMessageBody alloc]init];
                    messageBody.posterContent = self.ideaTextView.text;
                    messageBody.posterId = [responseObject objectForKey:@"TakeId"];
                    messageBody.publishTime = [self getTimeStr:[responseObject objectForKey:@"CreateTime"]];
                    
                    NSString * photoLists = imageUrlStr;
                    if (![photoLists isEqual:[NSNull null]]) {
//                        if ([photoLists containsString:@","]) {
//                            messageBody.posterPostImage = [photoLists componentsSeparatedByString:@","];
//                        }else
//                        {
//                            messageBody.posterPostImage = @[imageUrlStr];
//                        }
                        
                        if ([photoLists containsString:@","]) {
                            NSArray * imageArr = [photoLists componentsSeparatedByString:@","];
                            NSMutableArray * thumbnailImageArr = [NSMutableArray array];
                            if (imageArr.count > 1) {
                                messageBody.posterPostImage = imageArr;
                                for (NSString * imageUrl in imageArr) {
                                    NSString * newImageAtr = [imageUrl stringByAppendingString:@".w150.png"];
                                    [thumbnailImageArr addObject:newImageAtr];
                                }
                                
                            }else
                            {
                                messageBody.posterPostImage = @[imageArr.firstObject];
                                for (NSString * imageUrl in imageArr) {
                                    NSString * newImageAtr = [imageUrl stringByAppendingString:@".w375.png"];
                                    [thumbnailImageArr addObject:newImageAtr];
                                }
                            }
                            
                            messageBody.thumbnailPosterImage = [thumbnailImageArr copy];
                            //                messageBody.posterPostImage = [[friendCircleDic objectForKey:@"PhotoLists"] componentsSeparatedByString:@","];
                        }else
                        {
                            messageBody.posterPostImage = @[photoLists];
                            messageBody.thumbnailPosterImage = @[[NSString stringWithFormat:@"%@%@", photoLists,@".w375.png" ]];
                        }
                        
                    }
                    messageBody.posterReplies = [NSMutableArray array];
                    messageBody.posterImgstr = [RCIM sharedRCIM].currentUserInfo.portraitUri;
                    messageBody.posterName = [RCIM sharedRCIM].currentUserInfo.name;
                    messageBody.posterUserId = [RCIM sharedRCIM].currentUserInfo.userId;
                    messageBody.posterFavour = [NSMutableArray array];
                    messageBody.posterFavourUserArr = [NSMutableArray array];
                    messageBody.isFavour = NO;
                    
                    _myPublishBlock(messageBody);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }else
        {
            ;
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [hud hide:YES];
    }];
}
- (NSString *)getTimeStr:(NSNumber *)number
{
    double lastactivityInterval = [number doubleValue];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
    
    NSLog(@"time = %.0f", time);
    
    if (time < 60 && time >= 0) {
        return @"刚刚";
    } else if (time >= 60 && time < 3600) {
        return [NSString stringWithFormat:@"%.0f分钟前", time / 60];
    } else if (time >= 3600 && time < 3600 * 24) {
        return [NSString stringWithFormat:@"%.0f小时前", time / 3600];
    } else if (time >= 3600 * 24 && time < 3600 * 24 * 2) {
        return @"昨天";
    } else if (time >= 3600 * 24 * 2 && time < 3600 * 24 * 30) {
        return [NSString stringWithFormat:@"%.0f天前", time / 3600 / 24];
    } else if (time >= 3600 * 24 * 30 && time < 3600 * 24 * 30 * 12) {
        return [NSString stringWithFormat:@"%.0f月前", time / 3600 / 24 / 30];
    } else if (time >= 3600 * 24 * 30 * 12) {
        return [NSString stringWithFormat:@"%.0f年前", time / 3600 / 24 / 30 / 12];
    } else {
        return @"刚刚";
    }
    
    NSString * dateString = [fomatter stringFromDate:date];
    
    return dateString;
    
}
- (void)publishShuoShuoSuccess:(PublishBlock)publishBlock
{
    self.myPublishBlock = [publishBlock copy];
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
