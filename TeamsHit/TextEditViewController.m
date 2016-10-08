//
//  TextEditViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TextEditViewController.h"
#import "DropList.h"
#import "UIColor+HDExtension.h"
#import "UIImage+HDExtension.h"

#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define TOOLBAR_HEIGHT 40
#define MaxLength (2000)

@interface TextEditViewController ()<UITextViewDelegate>

{
    UIBarButtonItem * _boldItem;
    UIBarButtonItem * _sizeItem;
    UIBarButtonItem * _printItem;
    UIBarButtonItem * _alinItem;
    UIBarButtonItem * _fontRotaItem;
    
    UIImage * boldImage ;
    UIImage * sizeImage ;
    UIImage * alinImage ;
}

@property (nonatomic, copy)TextEditBlock textEditImage;

@property (nonatomic, strong)UITextView * ideaTextView;
@property (nonatomic, strong)UIToolbar * toolBar;

@property (nonatomic, strong)DropList * sizeDropList;
@property (nonatomic, strong)DropList * alinDropList;

@property (strong, nonatomic) UILabel *placeholderLabel;

// 富文本旋转操作以后生成的图片
@property (nonatomic, strong)UIImage * rotateInmage;
@property (nonatomic, strong)UIScrollView * backScrollView;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * rotateImageView;

// 富文本编辑
@property (nonatomic, assign)NSRange newRange;
@property (nonatomic, copy)NSString * newstr;
@property (nonatomic, assign)BOOL isBold;// 是否加粗
@property (nonatomic, strong)UIColor * fontColor;// 字体颜色
@property (nonatomic, assign)CGFloat font;// 字体大小
@property (nonatomic, assign)NSUInteger location;// 记录变化的起始位置
@property (nonatomic, strong)NSMutableAttributedString * locationStr;
@property (nonatomic, assign)CGFloat lineSpace;// 行间距
@property (nonatomic, assign)BOOL isDelete;// 是否是回删

@end

@implementation TextEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"写字板"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"插入" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.ideaTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height - 64 - 40)];
    self.ideaTextView.textColor = UIColorFromRGB(0xBBBBBB);
    self.ideaTextView.delegate = self;
    self.font = 15;
    self.fontColor = [UIColor blackColor];
    self.location = 0;
    self.isBold = NO;
    self.lineSpace = 5;
    [self setInitLocation];
    
    [self.view addSubview:self.ideaTextView];
    
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 70, 15)];
    self.placeholderLabel.text = @"请输入...";
    self.placeholderLabel.textColor = [UIColor grayColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    NSLog(@"%f", self.ideaTextView.font.pointSize);
    [self.view addSubview:self.placeholderLabel];
    
    [self.view addSubview:self.toolBar];
    
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height - 64 - 40)];
    self.backScrollView.backgroundColor = [UIColor whiteColor];
    self.backScrollView.hidden = YES;
    [self.view addSubview:self.backScrollView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.backScrollView.hd_height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.hidden = YES;
    [self.backScrollView addSubview:self.scrollView];
    
    self.rotateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.hd_width, self.scrollView.hd_height)];
    self.rotateImageView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.rotateImageView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.hd_width, self.rotateImageView.hd_height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    if (self.rotateInmage) {
        self.rotateInmage = [self getcuttingImage1];
        
        if (self.textEditImage) {
            _textEditImage(self.rotateInmage);
        }
    }else
    {
        CGSize size = [self.ideaTextView sizeThatFits:CGSizeMake(self.ideaTextView.hd_width, CGFLOAT_MAX)];
        
        self.ideaTextView.frame = CGRectMake(0 ,0, self.ideaTextView.hd_width,size.height);
        CGFloat topCorrect = ([_ideaTextView bounds].size.height - [_ideaTextView contentSize].height);
        topCorrect = (topCorrect <0.0 ?0.0 : topCorrect);
        _ideaTextView.contentOffset = (CGPoint){.x =0, .y = -topCorrect/2};
        
        UIImage * image = [self getcuttingImage];
        
        if (self.textEditImage) {
            if (image) {
                _textEditImage(image);
            }else
            {
                NSLog(@"没有图片");
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getTextEditImage:(TextEditBlock)processImage
{
    self.textEditImage = [processImage copy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.ideaTextView becomeFirstResponder];
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        [self.toolBar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
        [self.toolBar setShadowImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny];
        _toolBar.backgroundColor = UIColorFromRGB(0x12B7F5);
        _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT - 64, SELF_WIDTH, TOOLBAR_HEIGHT);
        
        
        _boldItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_bold_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(changeBold)];
        
        _sizeItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_size_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(changeSize)];
        
        _printItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_print_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(print)];
        
        _alinItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_align_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(changeAlin)];
        
        _fontRotaItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ico_fontrota_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rotate)];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
        boldImage = _boldItem.image;
        sizeImage = _sizeItem.image;
        alinImage = _alinItem.image;
        
        _toolBar.items = @[_boldItem,space,_sizeItem,space,_printItem,space,_alinItem,space,_fontRotaItem];
    }
    return _toolBar;
}

#pragma mark - toolBar点击事件
- (void)changeBold
{
    NSData * data1 = UIImagePNGRepresentation(_boldItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_bold_unchecked"]);
    if ([data1 isEqual:data2]) {
        [_boldItem setImage:[[UIImage imageNamed:@"ico_bold_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.isBold = YES;
    }else
    {
        [_boldItem setImage:[[UIImage imageNamed:@"ico_bold_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.isBold = NO;
    }
    boldImage = _boldItem.image;
}

- (void)changeSize
{
    
    if (self.alinDropList) {
        [self.alinDropList dismiss];
        [_alinItem setImage:[[UIImage imageNamed:@"ico_align_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        alinImage = [UIImage imageNamed:@"ico_align_unchecked"];
    }
    
    NSData * data1 = UIImagePNGRepresentation(_sizeItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_size_unchecked"]);
    if ([data1 isEqual:data2]) {
        [_sizeItem setImage:[[UIImage imageNamed:@"ico_size_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        if (!self.sizeDropList) {
            NSMutableArray * array = [NSMutableArray array];
            for (int i = 1; i <= 15; i++) {
                NSString * str = [NSString stringWithFormat:@"%d", i];
                [array addObject:str];
            }
            
            self.sizeDropList = [[DropList alloc]initWithFrame:CGRectMake(SELF_WIDTH / 2 - SELF_WIDTH / 5 - 15, _toolBar.hd_y - 154, 30, 160) listType:ListSize sourceArr:array];
            [self.view addSubview:self.sizeDropList];
            
            __weak TextEditViewController * vc = self;
            [self.sizeDropList getSelectRow:^(NSInteger number) {
                NSInteger textFont = number * number  + 15;
//                vc.ideaTextView.font = [UIFont systemFontOfSize:textFont];
                [_sizeItem setImage:[[UIImage imageNamed:@"ico_size_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                vc.font = textFont;
                sizeImage = [UIImage imageNamed:@"ico_size_unchecked"];
            }];
            
            [self.sizeDropList showWithAnimate:YES];
        }else
        {
            self.sizeDropList.frame = CGRectMake(SELF_WIDTH / 2 - SELF_WIDTH / 5 - 15, _toolBar.hd_y - 154, 30, 160);
            [self.sizeDropList showWithAnimate:YES];
        }
    }else
    {
        [_sizeItem setImage:[[UIImage imageNamed:@"ico_size_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        if (self.sizeDropList) {
            [self.sizeDropList dismiss];
        }
    }
    sizeImage = _sizeItem.image;
}
- (void)print
{
    NSLog(@"打印功能");
}
- (void)changeAlin
{
    if (self.sizeDropList) {
        [self.sizeDropList dismiss];
        [_sizeItem setImage:[[UIImage imageNamed:@"ico_size_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        sizeImage = [UIImage imageNamed:@"ico_size_unchecked"];
    }
    
    NSData * data1 = UIImagePNGRepresentation(_alinItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_align_unchecked"]);
    if ([data1 isEqual:data2]) {
        [_alinItem setImage:[[UIImage imageNamed:@"ico_align_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        if (!self.alinDropList) {
            NSArray * array = @[@"ico_align_left", @"ico_align_center", @"ico_align_right"];
            
            self.alinDropList = [[DropList alloc]initWithFrame:CGRectMake(SELF_WIDTH / 2 + SELF_WIDTH / 5 - 15, _toolBar.hd_y - 92, 30, 96) listType:ListAlin sourceArr:array];
            [self.view addSubview:self.alinDropList];
            
            __weak TextEditViewController * vc = self;
            [self.alinDropList getSelectRow:^(NSInteger number) {
                vc.ideaTextView.textAlignment = number;
                [_alinItem setImage:[[UIImage imageNamed:@"ico_align_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                alinImage = [UIImage imageNamed:@"ico_align_unchecked"];
                
            }];
            
            [self.alinDropList showWithAnimate:NO];
        }else
        {
            self.alinDropList.frame = CGRectMake(SELF_WIDTH / 2 + SELF_WIDTH / 5 - 15, _toolBar.hd_y - 92, 30, 96);
            [self.alinDropList showWithAnimate:NO];
        }
        
    }else
    {
        [_alinItem setImage:[[UIImage imageNamed:@"ico_align_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        if (self.alinDropList) {
            [self.alinDropList dismiss];
        }
    }
    alinImage = _alinItem.image;
}

#pragma mark - rotate
- (void)rotate
{
    [self.ideaTextView resignFirstResponder];
    
    if (self.sizeDropList) {
        [self.sizeDropList dismiss];
        [_sizeItem setImage:[[UIImage imageNamed:@"ico_size_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        sizeImage = [UIImage imageNamed:@"ico_size_unchecked"];
    }
    if (self.alinDropList) {
        [self.alinDropList dismiss];
        [_alinItem setImage:[[UIImage imageNamed:@"ico_align_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        alinImage = [UIImage imageNamed:@"ico_align_unchecked"];
    }
    
    NSData * data1 = UIImagePNGRepresentation(_fontRotaItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_fontrota_unchecked"]);
    if ([data1 isEqual:data2]) {
        [_fontRotaItem setImage:[[UIImage imageNamed:@"ico_fontrota_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [_boldItem setImage:nil];
        _boldItem.enabled = NO;
        [_sizeItem setImage:nil];
        _sizeItem.enabled = NO;
        [_alinItem setImage:nil];
        _alinItem.enabled = NO;
        
        [self getrotateTextImage];
        
    }else
    {
        [_fontRotaItem setImage:[[UIImage imageNamed:@"ico_fontrota_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [_boldItem setImage:[boldImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _boldItem.enabled = YES;
        [_sizeItem setImage:[sizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _sizeItem.enabled = YES;
        [_alinItem setImage:[alinImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _alinItem.enabled = YES;
        [self removeRotateView];
    }
}

- (void)getrotateTextImage
{
    self.backScrollView.hidden = NO;
    self.scrollView.hidden = NO;
    self.rotateImageView.hidden = NO;
    CGSize size = [self.ideaTextView sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.ideaTextView.hd_width)];
    
    self.ideaTextView.frame = CGRectMake(0 ,0, size.width,self.ideaTextView.hd_width);
    CGFloat topCorrect = ([_ideaTextView bounds].size.height - [_ideaTextView contentSize].height);
    topCorrect = (topCorrect <0.0 ?0.0 : topCorrect);
//    _ideaTextView.contentOffset = (CGPoint){.x =0, .y = -topCorrect/2};
    _ideaTextView.contentInset = UIEdgeInsetsMake(topCorrect / 2, 0, topCorrect / 2, 0);
    UIImage * image = [self getcuttingImage];
    
    UIImage * newImage = [UIImage image:image rotation:UIImageOrientationRight];
    self.rotateInmage = newImage;
    self.rotateImageView.image = newImage;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, -topCorrect / 2, 0, topCorrect / 2);
    self.rotateImageView.hd_height = newImage.size.height;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.hd_width , self.rotateImageView.hd_height );
//    self.rotateInmage = [self getcuttingImage1];
}

- (void)removeRotateView
{
    self.backScrollView.hidden = YES;
    self.scrollView.hidden = YES;
    self.rotateImageView.hidden = YES;
    self.rotateInmage = nil;
    self.ideaTextView.frame = CGRectMake(0, 0, self.view.hd_width, self.view.hd_height - 40);
    self.ideaTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

// 截取字体图片
- (UIImage *)getcuttingImage
{
    UIGraphicsBeginImageContext(self.ideaTextView.bounds.size);
    [self.ideaTextView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage *)getcuttingImage1
{
    self.toolBar.hidden = YES;
    self.backScrollView.frame = CGRectMake(self.backScrollView.hd_x, self.backScrollView.hd_y, self.backScrollView.hd_width, self.rotateImageView.hd_height);
    self.scrollView.frame = CGRectMake(self.scrollView.hd_x, self.scrollView.hd_y, self.scrollView.hd_width, self.rotateImageView.hd_height);
    UIGraphicsBeginImageContext(CGSizeMake(self.view.hd_width, self.rotateImageView.hd_height));
    [self.backScrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.toolBar.hidden = NO;
//    self.view.frame = CGRectMake(self.view.hd_x, self.view.hd_y, self.view.hd_width, [UIScreen mainScreen].bounds.size.height - 64);
    return viewImage;
}

#pragma mark - uitextviewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView
{
//    if ([textView.text isEqualToString:@"这一刻的想法..."]) {
//        NSRange range;
//        range.location = 0;
//        range.length = 0;
//        textView.selectedRange = range;
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 1) { // 回删
        return YES;
    }else
    {
        // 超过长度限制
        if (textView.text.length >= MaxLength ) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.ideaTextView.attributedText.length>0) {
        self.placeholderLabel.hidden=YES;
    }
    else
    {
        self.placeholderLabel.hidden=NO;
    }
    NSInteger len = textView.attributedText.length - self.locationStr.length;
    if (len>0) {
        self.isDelete = NO;
        self.newRange = NSMakeRange(self.ideaTextView.selectedRange.location - len, len);
        self.newstr = [textView.text substringWithRange:self.newRange];
    }else
    {
        self.isDelete = YES;
    }
    
#warning If there are some problems when you input,please check here
    bool isChinese; // 判断当前输入法是否是中文
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"en-US"]) {
        isChinese = false;
    }else
    {
        isChinese = true;
    }
    
    NSString * str = [[self.ideaTextView text]stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) {
        UITextRange * selectedRange = [self.ideaTextView markedTextRange];
        // 获取高亮部分
        UITextPosition * position = [self.ideaTextView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行数字统计和限制
        if (!position) {
            [self setStyle];
            if (str.length>=MaxLength) {
                NSString * strNew = [NSString stringWithString:str];
                [self.ideaTextView setText:[strNew substringToIndex:MaxLength]];
            }
        }else
        {
            if ([str length]>=MaxLength+10) {
                NSString *strNew = [NSString stringWithString:str];
                [ self.ideaTextView setText:[strNew substringToIndex:MaxLength+10]];
            }
        }
    }else
    {
        [self setStyle];
        if ([str length]>=MaxLength) {
            NSString *strNew = [NSString stringWithString:str];
            [ self.ideaTextView setText:[strNew substringToIndex:MaxLength]];
        }
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.sizeDropList) {
        [self.sizeDropList dismiss];
        [_sizeItem setImage:[[UIImage imageNamed:@"ico_size_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    if (self.alinDropList) {
        [self.alinDropList dismiss];
        [_alinItem setImage:[[UIImage imageNamed:@"ico_align_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
}

#pragma mark - 富文本编辑
- (void)setInitLocation
{
    self.locationStr = nil;
    self.locationStr = [[NSMutableAttributedString alloc]initWithAttributedString:self.ideaTextView.attributedText];
}
- (void)setStyle
{
    // 把最新内容进行替换
    [self setInitLocation];
    
    if (self.isDelete) {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = self.lineSpace;// 字体的行间距
    NSDictionary * attributes = nil;
    if (self.isBold) {
        attributes = @{
                       NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font],
                       NSForegroundColorAttributeName:self.fontColor,
                       NSParagraphStyleAttributeName:paragraphStyle
                       };
    }else
    {
        attributes = @{
                       NSFontAttributeName:[UIFont systemFontOfSize:self.font],
                       NSForegroundColorAttributeName:self.fontColor,
                       NSParagraphStyleAttributeName:paragraphStyle
                       };
    }
    
    NSAttributedString * replaceStr = [[NSAttributedString alloc]initWithString:self.newstr attributes:attributes];
    [self.locationStr replaceCharactersInRange:self.newRange withAttributedString:replaceStr];
    _ideaTextView.attributedText = self.locationStr;
    
    // 重新设置光标位置
    self.ideaTextView.selectedRange = NSMakeRange(self.newRange.location + self.newRange.length, 0);
    
}

#pragma mark - 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)note
{
    
    CGRect begin = [[[note userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect end = [[[note userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    self.toolBar.frame = CGRectMake(0, end.origin.y - 40 - 64, self.toolBar.hd_width, 40);//UITextField位置的y坐标移动到offY
    if (self.sizeDropList) {
        self.sizeDropList.frame = CGRectMake(SELF_WIDTH / 2 - SELF_WIDTH / 5 - 15, _toolBar.hd_y - 154, 30, 160);
    }
    if (self.alinDropList) {
        self.alinDropList.frame = CGRectMake(SELF_WIDTH / 2 + SELF_WIDTH / 5 - 15, _toolBar.hd_y - 92, 30, 96);
    }
    
    //因为第三方键盘或者是在键盘加个toolbar会导致回调三次，这个判断用来判断是否是第三次回调，原生只有一次
//    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
//        
//        //处理逻辑
//        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
//        [UIView setAnimationDuration:0.3];//设置动画时间 秒为单位
//        self.toolBar.frame = CGRectMake(0, end.origin.y - 40 - 64, self.toolBar.hd_width, 40);//UITextField位置的y坐标移动到offY
//        if (self.sizeDropList) {
//            self.sizeDropList.frame = CGRectMake(SELF_WIDTH / 2 - SELF_WIDTH / 5 - 15, _toolBar.hd_y - 154, 30, 160);
//        }
//        if (self.alinDropList) {
//            self.alinDropList.frame = CGRectMake(SELF_WIDTH / 2 + SELF_WIDTH / 5 - 15, _toolBar.hd_y - 92, 30, 96);
//        }
//        [UIView commitAnimations];//开始动画效果
//    }
    
}
-(void)keyboardWillHide:(NSNotification *)note{
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT , self.toolBar.hd_width, 40);
    if (self.sizeDropList) {
        self.sizeDropList.frame = CGRectMake(SELF_WIDTH / 2 - SELF_WIDTH / 5 - 15, _toolBar.hd_y - 154, 30, 160);
    }
    if (self.alinDropList) {
        self.alinDropList.frame = CGRectMake(SELF_WIDTH / 2 + SELF_WIDTH / 5 - 15, _toolBar.hd_y - 92, 30, 96);
    }
    [UIView commitAnimations];
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
