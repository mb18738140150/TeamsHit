//
//  TailorImageViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TailorImageViewController.h"
#import "TailorImageView.h"

#define bottomViewHeight 60
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define RGBA(red, green, blue, al) [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:al]

@interface TailorImageViewController ()

@property (nonatomic, strong) TailorImageView *imageCropperView;

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) CGRect rect;

@end

@implementation TailorImageViewController

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.title = @"裁减";
        _flag = YES;
        
        TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"剪切"];
        [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat left = 50;
        CGFloat cropWidth = ScreenWidth - left * 2.0;
        CGRect rect = CGRectMake((screenWidth - 100) / 2.0, (screenHeight - bottomViewHeight) / 2.0 - 100, 100, 100);
        _rect = rect;
        
        [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        self.imageCropperView = [[TailorImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - bottomViewHeight) image:image rectArray:@[NSStringFromCGRect(rect)]];
        //        [self.imageCropperView setConstrain:CGSizeMake(30, 10)];
        [self.view addSubview:_imageCropperView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - bottomViewHeight, screenWidth, bottomViewHeight)];
        bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        bottomView.userInteractionEnabled = YES;
        
        CGFloat buttonTop = 10;
        CGFloat buttonHeight = bottomViewHeight - buttonTop * 2;
        
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(0, buttonTop, 100, buttonHeight);
        [cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        cancleButton.backgroundColor = [UIColor clearColor];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:cancleButton];
        
        CGFloat imageButtonWidth = (screenWidth - 100 - 30) / 2.0;
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(CGRectGetMaxX(cancleButton.frame) + 10, buttonTop, imageButtonWidth, buttonHeight);
        [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        addButton.backgroundColor = [UIColor clearColor];
        [addButton setImage:[UIImage imageNamed:@"chapter_plus_green"] forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:addButton];
        
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        photoButton.frame = CGRectMake(CGRectGetMaxX(addButton.frame) + 10, buttonTop, imageButtonWidth, buttonHeight);
        [photoButton addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
        photoButton.backgroundColor = [UIColor clearColor];
        [photoButton setImage:[UIImage imageNamed:@"cut"] forState:UIControlStateNormal];
        [photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:photoButton];
        
        [self.view addSubview:bottomView];
    }
    return self;
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)add:(UIButton *)button {
    if (_flag) {
        [button setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
        [_imageCropperView addCropRect:CGRectMake(CGRectGetMinX(_rect), CGRectGetMaxY(_rect) + 10, CGRectGetWidth(_rect), CGRectGetHeight(_rect))];
    } else {
        [button setImage:[UIImage imageNamed:@"chapter_plus_green"] forState:UIControlStateNormal];
        [_imageCropperView removeCropRectByIndex:1];
    }
    _flag = !_flag;
}

- (void)photo {
    if (self.doneBlock) {
        self.doneBlock([self.imageCropperView cropedImageArray]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(TailorImageBlock)done {
    self.doneBlock = done;
}


- (void)complete
{
    if (self.doneBlock) {
        self.doneBlock([self.imageCropperView cropedImageArray]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
