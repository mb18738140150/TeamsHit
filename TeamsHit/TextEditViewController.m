//
//  TextEditViewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TextEditViewController.h"
#import "DropList.h"
#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define TOOLBAR_HEIGHT 40

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

@property (nonatomic, strong)UITextView * ideaTextView;
@property (nonatomic, strong)UIToolbar * toolBar;

@property (nonatomic, strong)DropList * sizeDropList;
@property (nonatomic, strong)DropList * alinDropList;

@end

@implementation TextEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@"写字板"];
    
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"插入" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.ideaTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.hd_width, self.view.hd_height - 64 - 40)];
    self.ideaTextView.textColor = UIColorFromRGB(0xBBBBBB);
    self.ideaTextView.text = @"这一刻的想法...";
    self.ideaTextView.delegate = self;
    [self.view addSubview:self.ideaTextView];
    
    [self.view addSubview:self.toolBar];
    
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
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)changeBold
{
    NSData * data1 = UIImagePNGRepresentation(_boldItem.image);
    NSData * data2 = UIImagePNGRepresentation([UIImage imageNamed:@"ico_bold_unchecked"]);
    if ([data1 isEqual:data2]) {
        [_boldItem setImage:[[UIImage imageNamed:@"ico_bold_checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.ideaTextView.font = [UIFont boldSystemFontOfSize:self.ideaTextView.font.pointSize];
    }else
    {
        [_boldItem setImage:[[UIImage imageNamed:@"ico_bold_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.ideaTextView.font = [UIFont systemFontOfSize:self.ideaTextView.font.pointSize];
    }
    boldImage = _boldItem.image;
}

- (void)changeSize
{
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
                NSInteger textFont = number + 15;
                vc.ideaTextView.font = [UIFont systemFontOfSize:textFont];
                [_sizeItem setImage:[[UIImage imageNamed:@"ico_size_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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


- (void)rotate
{
    
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
        
    }else
    {
        [_fontRotaItem setImage:[[UIImage imageNamed:@"ico_fontrota_unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [_boldItem setImage:[boldImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _boldItem.enabled = YES;
        [_sizeItem setImage:[sizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _sizeItem.enabled = YES;
        [_alinItem setImage:[alinImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _alinItem.enabled = YES;
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



#pragma mark - 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary * info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect begin = [[[note userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect end = [[[note userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //因为第三方键盘或者是在键盘加个toolbar会导致回调三次，这个判断用来判断是否是第三次回调，原生只有一次
    //    NSLog(@"begin.size.height = %f *** end.size.height = %f", begin.size.height, end.size.height);
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        
        //处理逻辑
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];//设置动画时间 秒为单位
        self.toolBar.frame = CGRectMake(0, end.origin.y - 40 - 64, self.toolBar.hd_width, 40);//UITextField位置的y坐标移动到offY
        if (self.sizeDropList) {
            self.sizeDropList.frame = CGRectMake(SELF_WIDTH / 2 - SELF_WIDTH / 5 - 15, _toolBar.hd_y - 154, 30, 160);
        }
        if (self.alinDropList) {
            self.alinDropList.frame = CGRectMake(SELF_WIDTH / 2 + SELF_WIDTH / 5 - 15, _toolBar.hd_y - 92, 30, 96);
        }
        [UIView commitAnimations];//开始动画效果
    }
    
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
