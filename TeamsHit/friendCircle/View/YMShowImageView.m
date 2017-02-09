//
//  YMShowImageView.m
//  WFCoretext
//
//  Created by 阿虎 on 14/11/3.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "YMShowImageView.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate.h"
#define kPageControlHeioght 50
#define LOADINGIMAGE_WIDTH 20

@implementation YMShowImageView{

    UIScrollView *_scrollView;
    CGRect self_Frame;
    NSInteger page;
    BOOL doubleClick;

}
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray placeImage:(UIImage *)placeImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self_Frame = frame;
        
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        self.placeImage = placeImage;
        [self configScrollViewWith:clickTag andAppendArray:appendArray];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray{

    self = [super initWithFrame:frame];
    if (self) {
        
        self_Frame = frame;
        
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        
        [self configScrollViewWith:clickTag andAppendArray:appendArray];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
    }
    return self;
    
}

- (void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray{

    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * appendArray.count, 0);
    [self addSubview:_scrollView];
    
    float W = self.frame.size.width;
    
    self.loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth / 2 - 20, screenHeight / 2 - 20, LOADINGIMAGE_WIDTH, LOADINGIMAGE_WIDTH)];
    UIImageView * loadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    loadView.image =[UIImage imageNamed:@"icon1.png"];
    loadView.alpha = 0.5;
    [_loadingImageView addSubview:loadView];
    CABasicAnimation * rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithInt:M_PI * 2.0];
    rotationAnimation.duration = 3;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    // RemovedOnCompletion这个属性默认为 YES,那意味着,在指定的时间段完成后,动画就自动的从层上移除了。这个一般不用
    rotationAnimation.removedOnCompletion = NO;
    [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    AppDelegate * delegate = ShareApplicationDelegate;
    [delegate.window addSubview:self.loadingImageView];
    
    for (int i = 0; i < appendArray.count; i ++) {
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor whiteColor];
        
        
        __weak YMShowImageView * weakself = self;
        UIImage * placeholdImage = nil;
        if (self.placeImage) {
            placeholdImage = self.placeImage;
        }else
        {
        }
        placeholdImage = [UIImage imageNamed:@"placeHolderImage1"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[appendArray objectAtIndex:i]] placeholderImage:placeholdImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGSize imagesize = [self getImageSizeForPreview:image];
            imageView.hd_width = imagesize.width;
            imageView.hd_height = imagesize.height;
            
            imageView.center = _scrollView.center;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.loadingImageView removeFromSuperview];
                weakself.loadingImageView = nil;
                NSLog(@"移除");
            });
        }];
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;
        
    }
    [_scrollView setContentOffset:CGPointMake(W * (clickTag - 9999), 0) animated:YES];
    page = clickTag - 9999;
    self.myPageControl = [[WelPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - kPageControlHeioght, self.frame.size.width, kPageControlHeioght)];
    self.myPageControl.numberOfPages = appendArray.count;
    self.myPageControl.currentPage = page;
    [_myPageControl setImagePageStateNormal:[UIImage imageNamed:@"point_unselect"]];
    [_myPageControl setImagePageStateHighlighted:[UIImage imageNamed:@"point_select"]];
    //    [_myPageControl setImagePageStateHighlighted:[UIImage imageNamed:@"1.jpg"]];
    if (appendArray.count >1) {
        [self addSubview:self.myPageControl];
    }
    
}
- (CGSize)getImageSizeForPreview:(UIImage *)image
{
    CGFloat maxWidth = screenWidth,maxHeight = screenHeight;
    
    CGSize size = image.size;
    
    if (size.width > maxWidth) {
        size.height *= (maxWidth / size.width);
        size.width = maxWidth;
    }
    
    if (size.height > maxHeight) {
        size.width *= (maxHeight / size.height);
        size.height = maxHeight;
    }
    
    return size;
    
}
- (void)disappear{
    
    _removeImg();
   
}

- (void)changeBig:(UITapGestureRecognizer *)tapGes{

    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        
        [currentScrollView zoomToRect:zoomRect animated:YES];
        
    }else {
      
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    doubleClick = !doubleClick;

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;

}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
   
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
   // NSLog(@" === %f",zoomRect.origin.x);
    return zoomRect;

}

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock{
    
     [bgView addSubview:self];
    
     _removeImg = tempBlock;
    
     [UIView animateWithDuration:.4f animations:^(){
         
         self.alpha = 1.0f;
    
      } completion:^(BOOL finished) {
        
     }];

}


#pragma mark - ScorllViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width ;
   
    self.myPageControl.currentPage = page;
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page+100+1]; //前一页
    
    if (scrollV_next.zoomScale != 1.0){
    
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
    
   // NSLog(@"page == %d",page);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
  

}

@end
