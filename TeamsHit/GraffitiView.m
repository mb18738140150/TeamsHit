//
//  GraffitiView.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GraffitiView.h"
#import "GraffitiDrawView.h"

#define SELF_WIDTH self.frame.size.width
#define SELF_HEIGHT self.frame.size.height
#define TOOLBAR_HEIGHT 40

static CGSize minSize1 = {40, 40};

@interface GraffitiView ()
{
    UIBarButtonItem * _drawItem;
    UIBarButtonItem * _eraserItem;
    UIBarButtonItem * _printItem;
    UIBarButtonItem * _widthItem;
    UIBarButtonItem * _cancleItem;
}

@property (nonatomic, strong)UIToolbar * toolBar;
@property (nonatomic, strong)GraffitiDrawView * drawer;
@property (nonatomic, strong)UIImageView * imageView;


@end

@implementation GraffitiView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.image = image;
        if (self.image) {
            self.backgroundColor = [UIColor blackColor];
        }
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    if (self.image) {
        
        CGPoint centerPonit = CGPointMake(self.hd_width / 2, (self.hd_height - 104) / 2 );
        
        self.imageView = [[UIImageView alloc]initWithImage:self.image];
        CGRect rect;
        rect.size = [self getImageSizeForPreview:self.image];
        rect.origin = CGPointMake((self.frame.size.width - rect.size.width) / 2.0, 0 );
        
        self.imageView.frame = rect;
        [self addSubview:self.imageView];
        
        self.drawer = [[GraffitiDrawView alloc]initWithFrame:self.imageView.frame];
        _drawer.width = 3;
        
        [self addSubview:_drawer];
        
        self.imageView.center = centerPonit;
        self.drawer.center = centerPonit;
        
    }else
    {
        self.drawer = [[GraffitiDrawView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 104)];
        _drawer.width = 3;
        [self addSubview:_drawer];
    }
    [self addSubview:self.toolBar];
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        [self.toolBar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
        [self.toolBar setShadowImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny];
        _toolBar.backgroundColor = UIColorFromRGB(0x12B7F5);
        _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT - 64, SELF_WIDTH, TOOLBAR_HEIGHT);
        
        
        //绘画
        _drawItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_scrawl_02_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(draw)];
        
        
        //擦除
        _eraserItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_eraser_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(eraser)];
        
        //打印
        _printItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_print_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(print)];
        
        //线宽
        _widthItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_dot_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(lianeWidth)];
        
        //撤销
        _cancleItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_cancel_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
        
        
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
        _toolBar.items = @[_drawItem,space,_eraserItem,space,_printItem,space,_widthItem,space,_cancleItem];
    }
    return _toolBar;
}



- (CGSize)getImageSizeForPreview:(UIImage *)image
{
    CGFloat maxWidth = self.frame.size.width,maxHeight = self.frame.size.height - 40 -64;
    
    CGSize size = image.size;
    
    if (size.width > maxWidth) {
        size.height *= (maxWidth / size.width);
        size.width = maxWidth;
    }
    
    if (size.height > maxHeight) {
        size.width *= (maxHeight / size.height);
        size.height = maxHeight;
    }
    
    if (size.width < minSize1.width) {
        size.height *= (minSize1.width / size.width);
        size.width = minSize1.width;
    }
    
    if (size.height < minSize1.height) {
        size.width *= (minSize1.height / size.height);
        size.height = minSize1.height;
    }
    return size;
    
}

- (void)draw
{
    NSData * data1 = UIImagePNGRepresentation(_drawItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_scrawl_02_unchecked"]);
    if ([data1 isEqual:data2]) {
        [_eraserItem setImage:[[UIImage imageNamed:@"ico_eraser_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_drawItem setImage:[[UIImage imageNamed:@"ico_scrawl_02_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    self.drawer.lineColor = [UIColor blackColor];
}
- (void)eraser
{
    NSData * data1 = UIImagePNGRepresentation(_eraserItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_eraser_checked"]);
    if ([data1 isEqual:data2]) {
        [_eraserItem setImage:[[UIImage imageNamed:@"ico_eraser_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_drawItem setImage:[[UIImage imageNamed:@"ico_scrawl_02_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    self.drawer.lineColor = [UIColor whiteColor];
}
- (void)print
{
    NSLog(@"打印");
}
- (void)lianeWidth
{
    self.drawer.width = 3;
}
- (void)cancle
{
    [self.drawer undo];
}
- (UIImage *)getGraffitiImage
{
    if (self.image) {
        self.toolBar.hidden = YES;
        CGRect rect = self.imageView.frame;
        self.imageView.frame = CGRectMake(0, 0, self.imageView.hd_width, self.imageView.hd_height);
        self.drawer.frame = self.imageView.frame;
        UIGraphicsBeginImageContext(_drawer.bounds.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.toolBar.hidden = NO;
        self.imageView.frame = rect;
        self.drawer.frame = rect;
        return viewImage;

    }else
    {
        UIGraphicsBeginImageContext(_drawer.bounds.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return viewImage;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
