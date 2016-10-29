//
//  PublishBigImageViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PublishBigImageViewController.h"

@interface PublishBigImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView * myScrollView;
@property (nonatomic, assign)int imageCount;
@end

@implementation PublishBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.myScrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.myScrollView.backgroundColor = [UIColor blackColor];
    
}

- (void)creatWithImageArr:(NSArray *)imageArr
{
    self.imageCount = imageArr.count;
    self.title = [NSString stringWithFormat:@"%d/%d", self.item, self.imageCount];
    //给ScrollView添加图片
    for (int i = 0; i < imageArr.count; i++) {
        UIImage *image = imageArr[i];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        CGPoint centerPoint = imageView.center;
        
        if (image.size.width > screenWidth) {
            imageView.hd_height = imageView.hd_width * image.size.height / image.size.width;
        }
        if (imageView.hd_height > screenHeight) {
            imageView.hd_width = imageView.hd_height * image.size.width / image.size.height;
        }
        imageView.center = centerPoint;
        imageView.image = image;
        [self.myScrollView addSubview:imageView];
        
    }
    
    //给ScrollView设置contentSize
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * imageArr.count, self.view.frame.size.height);
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    // 整页翻动
    self.myScrollView.pagingEnabled = YES;
    
    //给scrollView添加代理对象
    self.myScrollView.delegate = self;
    
    [self.myScrollView setContentOffset:CGPointMake(self.view.frame.size.width * (self.item - 1), 0) animated:NO];
    
    [self.view addSubview:self.myScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //先找到偏移量，再根据偏移量设置currentPage
    self.title = [NSString stringWithFormat:@"%.0f/%d", self.myScrollView.contentOffset.x / self.view.frame.size.width + 1, self.imageCount];
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
