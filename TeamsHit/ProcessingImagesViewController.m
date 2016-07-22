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

@interface ProcessingImagesViewController ()

{
    UIBarButtonItem * _imageType;
    UIBarButtonItem * _tailor;
    UIBarButtonItem * _print;
    UIBarButtonItem * _graffiti;
    UIBarButtonItem * _rotate;
}

@property (nonatomic, copy)ProcessImage processImage;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UIToolbar * toolBar;

@property (nonatomic, strong)ProcessImageTypeView * processImageTypeView;
@property (nonatomic, strong)UIImage * defaultImage;
@property (nonatomic, strong)UIImage * finalImage;

@property (nonatomic, assign)int rotateNumber;//记录旋转方向

@property (nonatomic, assign)CGRect initailRect;// imageView初始rect

@end

@implementation ProcessingImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"图片处理"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.rotateNumber = 1;
    [self creatSubviews];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)done
{
    if (self.processImage) {
        _processImage(self.finalImage);
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
    
    self.scrollView.contentSize = CGSizeMake(_scrollView.hd_width, _imageView.hd_height );
    
    self.initailRect = self.imageView.frame;
    
    if (_imageView.hd_height < _scrollView.hd_height) {
        _imageView.center = _scrollView.center;
    }
    
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT - 64, SELF_WIDTH, TOOLBAR_HEIGHT)];
        _toolBar.backgroundColor = [UIColor cyanColor];
//        _toolBar.frame = CGRectMake(0, 164, SELF_WIDTH, TOOLBAR_HEIGHT);
        
        // 图片样式
        _imageType = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat-2"] style:UIBarButtonItemStylePlain target:self action:@selector(changeType)];
        // 剪裁
        _tailor = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat-2"] style:UIBarButtonItemStylePlain target:self action:@selector(tailor)];
        // 打印
        _print = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat-2"] style:UIBarButtonItemStylePlain target:self action:@selector(print)];
        // 涂鸦
        _graffiti = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat-2"] style:UIBarButtonItemStylePlain target:self action:@selector(graffiti)];
        // 旋转
        _rotate = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat-2"] style:UIBarButtonItemStylePlain target:self action:@selector(rotate)];
        
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
        UIImage * newImage = [self zoomImageScale:self.image];
        _imageView.image = [ImageUtil grayImage:newImage];
        self.defaultImage = [ImageUtil grayImage:newImage];
        self.finalImage = [ImageUtil grayImage:newImage];
        _imageView.hd_height = SELF_WIDTH *_imageView.image.size.height / _imageView.image.size.width;
    }
    return _imageView;
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

#pragma mark - toolBar点击事件
- (void)changeType
{
    self.processImageTypeView.hidden = !(self.processImageTypeView.hidden);
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
    GraffitiViewController * graffitiVC = [[GraffitiViewController alloc]init];
    graffitiVC.sourceimage = self.finalImage;
    
    [graffitiVC graffitiImage:^(UIImage *image) {
        if (image) {
            self.imageView.image = image;
            self.finalImage = image;
            NSLog(@"获取到了");
        }
    }];
    
    [self.navigationController pushViewController:graffitiVC animated:YES];
    
}
- (void)graffiti
{
    GraffitiViewController * graffitiVC = [[GraffitiViewController alloc]init];
    graffitiVC.sourceimage = self.finalImage;
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
    [UIView animateWithDuration:.3 animations:^{
//        NSLog(@"width = %f, height = %f", self.imageView.hd_width, self.imageView.hd_height);
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI/2);
//        NSLog(@"width = %f, height = %f", self.imageView.hd_width, self.imageView.hd_height);
        
        
        switch (_rotateNumber) {
            case 1:
            {
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = self.initailRect;
                }
            }
                break;
            case 2:
            {
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = CGRectMake(0, 0, _scrollView.hd_width, _scrollView.hd_width * self.imageView.hd_height / self.imageView.hd_width);
                }
            }
                break;
            case 3:
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = self.initailRect;
                }
                break;
            case 4:
                if (self.defaultImage.size.height > self.scrollView.hd_width) {
                    self.imageView.frame = CGRectMake(0, 0, _scrollView.hd_width, _scrollView.hd_width * self.imageView.hd_height / self.imageView.hd_width);
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
            _imageView.image = [ImageUtil grayImage:self.defaultImage];
            self.finalImage = [ImageUtil grayImage:self.defaultImage];
        }
            break;
        case 1:
            self.imageView.image = [ImageUtil imageBlackToTransparent:self.defaultImage];
            self.finalImage = [ImageUtil imageBlackToTransparent:self.defaultImage];
            break;
        case 2:
            NSLog(@"素描");
            break;
        case 3:
             NSLog(@"描边");
            break;
        case 4:
             NSLog(@"喷墨");
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
