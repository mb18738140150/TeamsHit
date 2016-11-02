//
//  ProcessingImagesViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ProcessingImagesViewController.h"

#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define TOOLBAR_HEIGHT 40
#import "ImageUtil.h"
#import "ProcessImageTypeView.h"
#import "TailorImageViewController.h"
#import "GraffitiViewController.h"
#import "UIImage+HDExtension.h"

@interface ProcessingImagesViewController ()

{
    UIBarButtonItem * _imageType;
    UIBarButtonItem * _tailor;
    UIBarButtonItem * _print;
    UIBarButtonItem * _graffiti;
    UIBarButtonItem * _rotate;
    MBProgressHUD* hud ;
}

@property (nonatomic, copy)ProcessImage processImage;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UIToolbar * toolBar;

@property (nonatomic, strong)ProcessImageTypeView * processImageTypeView;
@property (nonatomic, strong)UIImage * defaultImage;
@property (nonatomic, strong)UIImage * finalImage;

@property (nonatomic, strong)UIImage * contraryImage;
@property (nonatomic, strong)UIImage * inkjetImage;


@property (nonatomic, assign)int rotateNumber;//记录旋转方向

@property (nonatomic, assign)CGRect initailRect;// imageView初始rect

@end

@implementation ProcessingImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"图片处理";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.image = [UIImage imageNamed:@"888.JPG"];
    
    self.image = [ImageUtil imageByScalingAndCroppingForSize:self.image];
    
    NSData * imageData = UIImageJPEGRepresentation(self.image, 1.0);
    if (UIImagePNGRepresentation(self.image) == nil)
    {
        imageData = UIImageJPEGRepresentation(_image, 1.0);
        NSLog(@" **** jpeg");
    }else{
        
        imageData = UIImagePNGRepresentation(self.image);
        NSLog(@" *** png");
    }
    
    NSLog(@"imageData = %@", imageData);
    
    self.image = [UIImage imageWithData:imageData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.rotateNumber = 1;
    [self creatSubviews];
    
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dealImage];
            [self refreshUI];
        });
    });
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)done
{
    if (self.processImage) {
        _processImage([self tailorborderImage:self.finalImage]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatSubviews
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.processImageTypeView];
    
    __weak ProcessingImagesViewController * processVC = self;
    [self.processImageTypeView getProcessImageType:^(int type) {
        [processVC processImageWithType:type];
    }];
    
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        
//        _toolBar = [[UIToolbar alloc] init];
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT - 64, SELF_WIDTH, TOOLBAR_HEIGHT)];
        [self.toolBar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
        [self.toolBar setShadowImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny];
        _toolBar.backgroundColor = UIColorFromRGB(0x12B7F5);
//        _toolBar.frame = CGRectMake(0, 164, SELF_WIDTH, TOOLBAR_HEIGHT);
        
        // 图片样式
        _imageType = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_effects_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(changeType)];
        // 剪裁
        _tailor = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"imageTailor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(tailor)];
        // 打印
        _print = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_print_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(print)];
        // 涂鸦
        _graffiti = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_scrawl_02_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(graffiti)];
        // 旋转
        _rotate = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_imagerotato_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rotate)];
        
        UIBarButtonItem * space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        _toolBar.items = @[_imageType, space, _tailor, space, _print, space, _graffiti, space, _rotate];
        
    }
    return _toolBar;
}
- (ProcessImageTypeView *)processImageTypeView
{
    if (!_processImageTypeView) {
        _processImageTypeView = [[ProcessImageTypeView alloc]initWithFrame:CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT - 64 - 60, SELF_WIDTH, 60)];
    }
    return _processImageTypeView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SELF_WIDTH, SELF_HEIGHT - TOOLBAR_HEIGHT - 64)];
        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SELF_WIDTH, SELF_WIDTH)];
    }
    return _imageView;
}

- (void)dealImage
{
    
    UIImage * newImage = [self zoomImageScale:self.image];
    _imageView.image = [ImageUtil ditherImage:newImage];
    self.defaultImage = _imageView.image;
    self.finalImage = _imageView.image;
    self.contraryImage = [ImageUtil imageBlackToTransparent:self.defaultImage];
    self.inkjetImage = [ImageUtil splashInk:newImage];
    _imageView.hd_height = SELF_WIDTH *_imageView.image.size.height / _imageView.image.size.width;
    [hud hide:YES];
}

- (UIImage *)zoomImageScale:(UIImage *)image
{
    CGSize size = image.size;
    
    // 创建一个基于位图的图形上下文，使得其成为当前上下文
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * size.height / size.width));
    [image drawInRect:CGRectMake(0, 0, SELF_WIDTH, SELF_WIDTH *size.height / size.width)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (UIImage *)tailorborderImage:(UIImage *)image
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(-1, -1, size.width + 1, size.height + 1)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)refreshUI
{
    self.scrollView.contentSize = CGSizeMake(_scrollView.hd_width, _imageView.hd_height );
    
    self.initailRect = self.imageView.frame;
    
    if (_imageView.hd_height < _scrollView.hd_height) {
        _imageView.center = _scrollView.center;
    }
}

#pragma mark - toolBar点击事件
- (void)changeType
{
    
    NSData * data1 = UIImagePNGRepresentation(_imageType.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_effects_unchecked"]);
    if ([data1 isEqual:data2]) {
        [_imageType setImage:[[UIImage imageNamed:@"ico_effects_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.processImageTypeView.hidden = NO;
    }else
    {
        [_imageType setImage:[[UIImage imageNamed:@"ico_effects_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        self.processImageTypeView.hidden = YES;
    }
    
//    self.processImageTypeView.hidden = !(self.processImageTypeView.hidden);
}
- (void)tailor
{
    TailorImageViewController * tailorVC = [[TailorImageViewController alloc]initWithImage:self.imageView.image];
    __weak ProcessingImagesViewController * processVC = self;
    [tailorVC done:^(NSDictionary * imageDic) {
        [processVC tailorImage:imageDic];
    }];
    [self.navigationController pushViewController:tailorVC animated:NO];
}

- (void)print
{
    NSLog(@"打印功能");
    
    [[Print sharePrint] printImage:self.finalImage taskType:@1 toUserId:self.userId];
    
}
- (void)graffiti
{
    GraffitiViewController * graffitiVC = [[GraffitiViewController alloc]init];
    graffitiVC.sourceimage = self.finalImage;
    graffitiVC.userId = self.userId;
    [graffitiVC graffitiImage:^(UIImage *image) {
        if (image) {
            self.imageView.image = image;
            self.finalImage = image;
            NSLog(@"获取到了");
        }
    }];
    [self.navigationController pushViewController:graffitiVC animated:YES];
}
- (void)rotate
{
    _rotateNumber++;
    if (_rotateNumber == 5) {
        _rotateNumber = 1;
    }
    [UIView animateWithDuration:.1 animations:^{

//        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI/2);
        
        self.imageView.image = [UIImage image:self.imageView.image rotation:UIImageOrientationRight];
        switch (_rotateNumber) {
            case 1:
            {
                self.imageView.frame = CGRectMake(0, 0, self.defaultImage.size.width, self.defaultImage.size.height);
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = self.initailRect;
                }
            }
                break;
            case 2:
            {
                self.imageView.frame = CGRectMake(0, 0, self.defaultImage.size.height, self.defaultImage.size.width);
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = CGRectMake(0, 0, _scrollView.hd_width, _scrollView.hd_width * self.imageView.hd_height / self.imageView.hd_width);
                }
            }
                break;
            case 3:
            {
                self.imageView.frame = CGRectMake(0, 0, self.defaultImage.size.width, self.defaultImage.size.height);
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = self.initailRect;
                }
            }
                break;
            case 4:
            {
                self.imageView.frame = CGRectMake(0, 0, self.defaultImage.size.height, self.defaultImage.size.width);
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = CGRectMake(0, 0, _scrollView.hd_width, _scrollView.hd_width * self.imageView.hd_height / self.imageView.hd_width);
                }
            }
                break;
                
            default:
                break;
        }
        self.imageView.center = self.scrollView.center;
    } completion:^(BOOL finished) {
        self.scrollView.contentSize = CGSizeMake(_scrollView.hd_width, _scrollView.hd_height);
        self.finalImage = [self imageWithUIView:self.imageView];
        NSLog(@"**** width = %f, height = %f", self.finalImage.size.width, self.finalImage.size.height);
    }];
}
-(UIImage *)imageWithUIView:(UIView *)view
{
    //UIGraphicsBeginImageContext(view.bounds.size);
//    UIGraphicsBeginImageContext(view.frame.size);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
}
#pragma mark - ProcessImageType
- (void)processImageWithType:(int )type
{
    switch (type) {
        case 0:
        {
            _imageView.image = self.defaultImage;
            self.finalImage = self.defaultImage;
            
        }
            break;
        case 1:
            if (self.contraryImage) {
                self.imageView.image = self.contraryImage;
                self.finalImage = self.contraryImage;
            }else
            {
                self.imageView.image = [ImageUtil imageBlackToTransparent:self.defaultImage];
                self.finalImage = [ImageUtil imageBlackToTransparent:self.defaultImage];
            }
            break;
        case 2:
            NSLog(@"喷墨");
            if (self.inkjetImage) {
                self.imageView.image = self.inkjetImage;
                self.finalImage = self.inkjetImage;
            }else
            {
                self.imageView.image = [ImageUtil splashInk:self.defaultImage];
                self.finalImage = self.imageView.image;
                self.inkjetImage = self.imageView.image;
            }
            break;
        case 3:
             NSLog(@"描边");
            self.imageView.image = [ImageUtil memory:self.defaultImage];
            self.finalImage = [ImageUtil memory:self.defaultImage];
            break;
        case 4:
             NSLog(@"素描");
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 图片剪切
- (void)tailorImage:(NSDictionary *)imageDic
{
    self.imageView.image =  [self zoomImageScale:[imageDic objectForKey:@"ImageArr"][0]];
    self.finalImage = [self zoomImageScale:[imageDic objectForKey:@"ImageArr"][0]];
    self.imageView.hd_height = SELF_WIDTH *self.imageView.image.size.height / self.imageView.image.size.width;
    if (self.imageView.hd_height < self.scrollView.hd_height) {
        self.imageView.center = self.scrollView.center;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.hd_width, self.imageView.hd_height );
    
    CGRect rect = CGRectFromString([imageDic objectForKey:@"Rect"]);
    CGRect imageViewRect = CGRectFromString([imageDic objectForKey:@"imageViewRecf"]);
    CGFloat scale = self.defaultImage.size.width / imageViewRect.size.width;
    self.defaultImage = [self cropImageWithScale:scale Rect:rect imageViewRect:imageViewRect];
}

- (UIImage *)cropImageWithScale:(CGFloat)scale
                           Rect:(CGRect)rect
                  imageViewRect:(CGRect)imageViewRect
{
    rect.origin.x = (rect.origin.x - imageViewRect.origin.x) * scale;
    rect.origin.y = (rect.origin.y - imageViewRect.origin.y) * scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [self.defaultImage drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.defaultImage.size.width, self.defaultImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processImage:(ProcessImage)processImage
{
    self.processImage = [processImage copy];
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
