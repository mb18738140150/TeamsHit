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
#import "DragCellTableView.h"
#import "AppDelegate.h"
#import "QRCode.h"
#import "MaterialDataModel.h"
#import "MaterialTableViewCell.h"
#import "materiaCollectionView.h"
#import "ExpressionView.h"
#import "MaterialDetailViewController.h"
#define CELL_IDENTIFIER @"MaterialTableViewCell"

#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define TOOLBAR_HEIGHT 45
#define MateriaCollectionView_height 100
@interface MaterialViewController ()<DragCellTableViewDataSource, RTDragCellTableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

{
    UIBarButtonItem * _textEditItem;
    UIBarButtonItem * _pictureItem;
    UIBarButtonItem * _expressionItem;
    UIBarButtonItem * _materiaItem;
    UIBarButtonItem * _qrCodeItem;
    UIBarButtonItem * _graffitiItem;
    UIBarButtonItem * _historyItem;
}

@property (nonatomic, strong)ExpressionView * expressionView;//表情view
@property (nonatomic, strong)materiaCollectionView * materiaView;// 素材view
@property (nonatomic, strong)DragCellTableView * tableView;
@property (nonatomic, strong)UIToolbar * toolBar;

// 图片选择器
@property (nonatomic, strong)UIImagePickerController * imagePic;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * iconImageView;

@property (nonatomic, strong)NSMutableArray * dataArr;

// 二维码弹框
@property (nonatomic, strong)UIView * qrCodeView;
@property (nonatomic, strong)UIView * qrCodeEditlView;
@property (nonatomic, strong)UITextView * qrTextView;
@property (nonatomic, strong)UILabel * titleLabel;// 二维码字数控制框

@end

@implementation MaterialViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x12B7F5);
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"素材"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打印预览" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.tableView = [[DragCellTableView alloc]init];
    self.tableView.frame = CGRectMake(10, 10, self.view.hd_width - 20, self.view.hd_height - 64 - 45 - 10);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MaterialTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self prepareUI];
        });
    });
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareUI
{
    
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.delegate = self;
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 100, self.view.hd_width - 40, self.view.hd_width - 40)];
    self.scrollView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    //    [self.view addSubview:self.scrollView];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width - 40, self.view.hd_width - 40)];
    self.iconImageView.backgroundColor = [UIColor redColor];
    //    [self.scrollView addSubview:self.iconImageView];
    
    self.qrCodeView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _qrCodeView.backgroundColor = [UIColor clearColor];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.expressionView = [[ExpressionView alloc]initWithFrame:CGRectMake(0, self.view.hd_height - 120, self.view.hd_width, 120)];
    
    self.materiaView = [[materiaCollectionView alloc] initWithFrame:CGRectMake(0, self.view.hd_height - MateriaCollectionView_height, self.view.hd_width, MateriaCollectionView_height)];
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        [self.toolBar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
        [self.toolBar setShadowImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny];
        _toolBar.backgroundColor = UIColorFromRGB(0x12B7F5);
        _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT - 64, SELF_WIDTH, TOOLBAR_HEIGHT);
        
        
         _textEditItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"materia-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(textEdit)];
        
        _pictureItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"materia-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(picture)];
        
        _expressionItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"materia-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(expression)];
        
        _materiaItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"materia-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(materiadetail)];
        
        _qrCodeItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"materia-5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(qrCode)];
        
        _graffitiItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"materia-6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(graffiti)];
        
        _historyItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"materia-7"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(history)];
        
        
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
        _toolBar.items = @[_textEditItem,space,_pictureItem,space,_expressionItem,space, _materiaItem, space,_qrCodeItem,space,_graffitiItem, space, _historyItem];
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell createSubView:tableView.bounds];
    MaterialDataModel * model = self.dataArr[indexPath.row];
    cell.materialmodel = model;
    
    __weak MaterialViewController * materVC = self;
    [cell deleteItem:^{
        [materVC.dataArr removeObjectAtIndex:indexPath.row];
        [materVC.tableView reloadData];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSArray *)originalArrayDataForTableView:(DragCellTableView *)tableView{
    return _dataArr;
}

- (void)tableView:(DragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    _dataArr = [newArray mutableCopy];
}
- (void)cellDidEndMovingInTableView:(DragCellTableView *)tableView;
{
    for (NSString * str in self.dataArr) {
        NSLog(@"str = %@", str);
    }
}
#pragma mark - 文字编辑
- (void)textEdit
{
    NSLog(@"文字编辑");
    TextEditViewController * textVC = [[TextEditViewController alloc]init];
    __weak MaterialViewController * matervc = self;
    [textVC getTextEditImage:^(UIImage *image) {
        matervc.iconImageView.image = image;
//        matervc.iconImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        matervc.scrollView.contentSize = CGSizeMake(matervc.scrollView.hd_width, matervc.iconImageView.hd_height);
        
        MaterialDataModel * model = [[MaterialDataModel alloc]init];
        model.image = image;
        model.imageModel = TextEditImageModel;
        [matervc.dataArr addObject:model];
        NSArray * indexpaths = @[[NSIndexPath indexPathForRow:matervc.dataArr.count - 1 inSection:0]];
        [matervc.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
        [matervc performSelector:@selector(moveToBottom) withObject:nil afterDelay:.3];
    }];
    [self.navigationController pushViewController:textVC animated:YES];
}

#pragma msrk - 图片选择处理
- (void)picture
{
    [self recoverUI];
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
        MaterialDataModel * model = [[MaterialDataModel alloc]init];
        model.image = image;
        model.imageModel = ProcessImageMOdel;
        [meVc.dataArr addObject:model];
        NSArray * indexpaths = @[[NSIndexPath indexPathForRow:meVc.dataArr.count - 1 inSection:0]];
        [meVc.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
        [meVc performSelector:@selector(moveToBottom) withObject:nil afterDelay:.3];
        
    }];
    [self.navigationController pushViewController:processVC animated:YES];
    
}

#pragma mark - 表情
- (void)expression
{
    NSLog(@"表情弹窗");
    
//    NSData * data3 = UIImagePNGRepresentation(_materiaItem.image);
//    NSData * data4 = UIImagePNGRepresentation([UIImage imageNamed:@"materia-4"]);
//    if (![data3 isEqual:data4]) {
//        
//        [self.materiaView removeFromSuperview];
//        [_materiaItem setImage:[[UIImage imageNamed:@"materia-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT, SELF_WIDTH, TOOLBAR_HEIGHT);
//        self.tableView.frame = CGRectMake(10, 10, self.view.hd_width - 20, self.view.hd_height - 45 - 10);
//    }
    
    NSData * data1 = UIImagePNGRepresentation(_expressionItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"materia-3"]);
    if ([data1 isEqual:data2]) {
        [_expressionItem setImage:[[UIImage imageNamed:@"素材-表情-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.view addSubview:_expressionView];
        self.tableView.hd_height = self.tableView.hd_height - 120;
        self.toolBar.hd_y = self.toolBar.hd_y - 120;
        
    }else
    {
        [_expressionItem setImage:[[UIImage imageNamed:@"materia-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_expressionView removeFromSuperview];
        self.tableView.hd_height = self.tableView.hd_height + 120;
        self.toolBar.hd_y = self.toolBar.hd_y + 120;
        
    }
    
    __weak MaterialViewController * matervc = self;
    [_expressionView getExpressionImage:^(UIImage *expressionImage) {
        UIImage * image = expressionImage;
        if (image) {
            matervc.iconImageView.image = image;
            NSLog(@"获取到了");
            MaterialDataModel * model = [[MaterialDataModel alloc]init];
            model.image = image;
            model.imageModel = expressionModel;
            [matervc.dataArr addObject:model];
            
            NSArray * indexpaths = @[[NSIndexPath indexPathForRow:matervc.dataArr.count - 1 inSection:0]];
            [matervc.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
            [matervc performSelector:@selector(moveToBottom) withObject:nil afterDelay:.3];
        }
    }];
}

- (void)materiadetail
{
    
//    NSData * data11 = UIImagePNGRepresentation(_expressionItem.image);
//    NSData * data12 = UIImagePNGRepresentation([UIImage imageNamed:@"materia-3"]);
//    if (![data11 isEqual:data12]) {
//        [self.expressionView removeFromSuperview];
//        [_expressionItem setImage:[[UIImage imageNamed:@"materia-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT, SELF_WIDTH, TOOLBAR_HEIGHT);
//        self.tableView.frame = CGRectMake(10, 10, self.view.hd_width - 20, self.view.hd_height - 45 - 10);
//    }
//    
//    NSData * data1 = UIImagePNGRepresentation(_materiaItem.image);
//    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"materia-4"]);
//    if ([data1 isEqual:data2]) {
//        [_materiaItem setImage:[[UIImage imageNamed:@"素材-素材-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [self.view addSubview:_materiaView];
//        self.tableView.hd_height = self.tableView.hd_height - MateriaCollectionView_height;
//        self.toolBar.hd_y = self.toolBar.hd_y - MateriaCollectionView_height;
//        
//    }else
//    {
//        [_materiaItem setImage:[[UIImage imageNamed:@"materia-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [_materiaView removeFromSuperview];
//        self.tableView.hd_height = self.tableView.hd_height + MateriaCollectionView_height;
//        self.toolBar.hd_y = self.toolBar.hd_y + MateriaCollectionView_height;
//        
//    }
//    
//    __weak MaterialViewController * matervc = self;
//    [_materiaView getMateriaImage:^(NSString * namestring, UIImage * materiaimage) {
//        UIImage * image = materiaimage;
//        if (image) {
//            matervc.iconImageView.image = image;
//            NSLog(@"获取到了");
//            MaterialDataModel * model = [[MaterialDataModel alloc]init];
//            model.image = image;
//            model.imageModel = MateriaModel;
//            [matervc.dataArr addObject:model];
//            
//            NSArray * indexpaths = @[[NSIndexPath indexPathForRow:matervc.dataArr.count - 1 inSection:0]];
//            [matervc.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
//            [matervc performSelector:@selector(moveToBottom) withObject:nil afterDelay:.3];
//        }
//    }];
    
    MaterialDetailViewController * materiadetailVc = [[MaterialDetailViewController alloc]init];
    
    [self.navigationController pushViewController:materiadetailVc animated:YES];
    
    NSLog(@"素材");
}

#pragma mark - 二维码
- (void)qrCode
{
    [self recoverUI];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_qrCodeView];
    
    [_qrCodeView removeAllSubviews];
    
    
    UIView * backView = [[UIView alloc]init];
    backView.frame = _qrCodeView.frame;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = .5;
    [_qrCodeView addSubview:backView];
    
    self.qrCodeEditlView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.hd_width - 20, self.view.hd_height / 2)];
    _qrCodeEditlView.center = _qrCodeView.center;
    _qrCodeEditlView.layer.cornerRadius = 2;
    _qrCodeEditlView.layer.masksToBounds = YES;
    _qrCodeEditlView.backgroundColor = [UIColor whiteColor];
    [_qrCodeView addSubview:_qrCodeEditlView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, _qrCodeEditlView.hd_width, 17)];
    _titleLabel.text = @"您还可以输入140字";
    _titleLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [_qrCodeEditlView addSubview:_titleLabel];
    
    self.qrTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 10, _qrCodeEditlView.hd_width - 40, _qrCodeEditlView.hd_height - 103)];
    _qrTextView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    _qrTextView.layer.cornerRadius = 1;
    _qrTextView.layer.masksToBounds = YES;
    _qrTextView.layer.borderWidth = 1;
    _qrTextView.delegate = self;
    _qrTextView.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
    [_qrCodeEditlView addSubview:_qrTextView];
    
//    UIButton * cancleButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    cancleButton1.frame = CGRectMake(CGRectGetMaxX(changeNamelView.frame) - 50, 15, 20, 20);
//    [cancleButton1 setImage:[[UIImage imageNamed:@"imgErro"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [cancleButton1 setTitleColor:[UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1] forState:UIControlStateNormal];
//    [cancleButton1 addTarget:self action:@selector(cancleChangeAction) forControlEvents:UIControlEventTouchUpInside];
//    [changeNamelView addSubview:cancleButton1];
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(CGRectGetMaxX(self.qrTextView.frame) - 120, CGRectGetMaxY(_qrTextView.frame) + 9, 40, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleChangeAction) forControlEvents:UIControlEventTouchUpInside];
    [_qrCodeEditlView addSubview:cancleButton];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(CGRectGetMaxX(cancleButton.frame) + 30, cancleButton.hd_y, cancleButton.hd_width, cancleButton.hd_height);
    [sureButton setTitle:@"生成" forState:UIControlStateNormal];
    [sureButton setTitleColor:UIColorFromRGB(0x12B7F5) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureChange:) forControlEvents:UIControlEventTouchUpInside];
    [_qrCodeEditlView addSubview:sureButton];
    
    [self animateIn];
    
}
- (void)cancleChangeAction
{
    [self.qrCodeView removeFromSuperview];
}
- (void)sureChange:(UIButton *)button
{
    [self.qrCodeView removeFromSuperview];
    if (self.qrTextView.text.length != 0) {
        UIImage * image = [[QRCode shareQRCode]createQRCodeForString:self.qrTextView.text withWidth:self.view.hd_width * 2 / 5];
        self.iconImageView.image = image;
        
        MaterialDataModel * model = [[MaterialDataModel alloc]init];
        model.image = image;
        model.title = self.qrTextView.text;
        model.imageModel = QRCodeModel;
        [self.dataArr addObject:model];
        NSArray * indexpaths = @[[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0]];
        [self.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
        [self performSelector:@selector(moveToBottom) withObject:nil afterDelay:.3];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"二维码内容不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }
}

- (void)animateIn
{
    self.qrCodeView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.qrCodeView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.qrCodeView.alpha = 1;
        self.qrCodeView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

// 涂鸦板
- (void)graffiti
{
    GraffitiViewController * graffitiVC = [[GraffitiViewController alloc]init];
    
    __weak MaterialViewController * matervc = self;
    [graffitiVC graffitiImage:^(UIImage *image) {
        if (image) {
            matervc.iconImageView.image = image;
            NSLog(@"获取到了");
            MaterialDataModel * model = [[MaterialDataModel alloc]init];
            model.image = image;
            model.imageModel = GraffitiModel;
            [matervc.dataArr addObject:model];
            
            NSArray * indexpaths = @[[NSIndexPath indexPathForRow:matervc.dataArr.count - 1 inSection:0]];
            [matervc.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
            [matervc performSelector:@selector(moveToBottom) withObject:nil afterDelay:.3];
        }
    }];
    
    [self.navigationController pushViewController:graffitiVC animated:YES];
}

// 打印历史
- (void)history
{
    NSLog(@"打印历史");
}

#pragma mark - uitextviewdelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.qrTextView.text.length > 140) {
        NSString * str = [self.qrTextView.text substringToIndex:10];
        self.qrTextView.text = str;
        _titleLabel.text = @"您还可以输入0字";
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您最多可以输入140字" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    }else
    {
        NSInteger count = 140 - self.qrTextView.text.length;
        _titleLabel.text = [NSString stringWithFormat:@"您还可以输入%d字", count];
    }
}


#pragma mark - 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)note
{
    
    CGRect begin = [[[note userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect end = [[[note userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //因为第三方键盘或者是在键盘加个toolbar会导致回调三次，这个判断用来判断是否是第三次回调，原生只有一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        
        //处理逻辑
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];//设置动画时间 秒为单位
        self.qrCodeEditlView.frame = CGRectMake(10, end.origin.y - self.view.hd_height / 2, self.qrCodeEditlView.hd_width, self.qrCodeEditlView.hd_height);//UITextField位置的y坐标移动到offY
        [UIView commitAnimations];//开始动画效果
    }
}
-(void)keyboardWillHide:(NSNotification *)note{
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    _qrCodeEditlView.center = _qrCodeView.center;
    
    [UIView commitAnimations];
}

// 回复状态
- (void)recoverUI
{
    NSData * data1 = UIImagePNGRepresentation(_expressionItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"materia-3"]);
    if (![data1 isEqual:data2]) {
        [self.expressionView removeFromSuperview];
        [_expressionItem setImage:[[UIImage imageNamed:@"materia-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
//    NSData * data3 = UIImagePNGRepresentation(_materiaItem.image);
//    NSData * data4 = UIImagePNGRepresentation([UIImage imageNamed:@"materia-4"]);
//    if (![data3 isEqual:data4]) {
//        
//        [self.materiaView removeFromSuperview];
//        [_materiaItem setImage:[[UIImage imageNamed:@"materia-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    }
//    _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT, SELF_WIDTH, TOOLBAR_HEIGHT);
//    self.tableView.frame = CGRectMake(10, 10, self.view.hd_width - 20, self.view.hd_height - 45 - 10);
}

- (void)moveToBottom
{
    CGFloat tableViewH = self.tableView.frame.size.height;
    CGSize contentSize = self.tableView.contentSize;
    if (contentSize.height > tableViewH) {
        [self.tableView setContentOffset:CGPointMake(0, contentSize.height - tableViewH) animated:YES];
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
