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

#define kPublishCellID @"PublishCellID"

@interface PublishCircleOfFriendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@property (nonatomic, strong)UIScrollView * publishScrollView;

@property (nonatomic, strong)UIView * informationView;
@property (nonatomic, strong)UITextView * ideaTextView;
@property (nonatomic, strong)UICollectionView * phoneCollectionView;
@property (nonatomic , strong) NSMutableArray *assets;

@property (nonatomic, strong)UIView * permissionView;

@end

@implementation PublishCircleOfFriendViewController
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
    
    
    [self creatSubViews];
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
