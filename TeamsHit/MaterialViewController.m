//
//  MaterialViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MaterialViewController.h"
#import "ProcessingImagesViewController.h"
#import "GraffitiViewController.h"
#import "TextEditViewController.h"


#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define TOOLBAR_HEIGHT 45

@interface MaterialViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    UIBarButtonItem * _textEditItem;
    UIBarButtonItem * _pictureItem;
    UIBarButtonItem * _expressionItem;
    UIBarButtonItem * _qrCodeItem;
    UIBarButtonItem * _graffitiItem;
    UIBarButtonItem * _historyItem;
}

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UIToolbar * toolBar;

// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;

@property (nonatomic, strong)UIImageView * iconImageView;


@end

@implementation MaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x12B7F5);
    
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"素材"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打印预览" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, self.view.hd_width - 20, self.view.hd_height - 64 - 45 - 10) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    [self.view addSubview:self.tableView];
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.delegate = self;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.iconImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.iconImageView];
    
    [self.view addSubview:self.toolBar];
    // Do any additional setup after loading the view.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        [self.toolBar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
        [self.toolBar setShadowImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny];
        _toolBar.backgroundColor = UIColorFromRGB(0x12B7F5);
        _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT - 64, SELF_WIDTH, TOOLBAR_HEIGHT);
        
        
         _textEditItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(textEdit)];
        
        _pictureItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(picture)];
        
        _expressionItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(expression)];
        
        _qrCodeItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(qrCode)];
        
        _graffitiItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(graffiti)];
        
        _historyItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(history)];
        
        
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
        _toolBar.items = @[_textEditItem,space,_pictureItem,space,_expressionItem,space,_qrCodeItem,space,_graffitiItem, space, _historyItem];
    }
    return _toolBar;
}


#pragma mark - tableViewDelegate/Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"好好说";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - 文字编辑
- (void)textEdit
{
    NSLog(@"文字编辑");
    TextEditViewController * textVC = [[TextEditViewController alloc]init];
    
    [self.navigationController pushViewController:textVC animated:YES];
    
}

#pragma msrk - 图片选择处理
- (void)picture
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
    NSLog(@"%@", [info description]);
    
    self.iconImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ProcessingImagesViewController * processVC = [[ProcessingImagesViewController alloc]init];
    processVC.image = self.iconImageView.image;
    processVC.hidesBottomBarWhenPushed = YES;
    
    __weak MaterialViewController * meVc = self;
    [processVC processImage:^(UIImage *image) {
        meVc.iconImageView.image = image;
    }];
    [self.navigationController pushViewController:processVC animated:YES];
    
}

#pragma mark - 表情
- (void)expression
{
    NSLog(@"表情弹窗");
}

#pragma mark - 二维码
- (void)qrCode
{
    NSLog(@"生成二维码");
}

// 涂鸦板
- (void)graffiti
{
    GraffitiViewController * graffitiVC = [[GraffitiViewController alloc]init];
    
    [graffitiVC graffitiImage:^(UIImage *image) {
        if (image) {
            self.iconImageView.image = image;
            NSLog(@"获取到了");
        }
    }];
    
    [self.navigationController pushViewController:graffitiVC animated:YES];
}

// 打印历史
- (void)history
{
    NSLog(@"打印历史");
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
