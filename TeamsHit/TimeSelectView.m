//
//  TimeSelectView.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "TimeSelectView.h"

#define TWW self.frame.size.width
#define TWH self.frame.size.height

#define TWRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define BtnW 60
#define toolH 40
#define BJH 260

@interface TimeSelectView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *_pickView;        //最主要的选择器
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *monthMutableArray;
    NSMutableArray *DaysMutableArray;
    NSMutableArray *DaysArray;
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSInteger m ;
    int year;
    int month;
    int day;
    
}

@property (nonatomic, strong)UIView *BJView;//一个view，工具栏和pickview都是添加到上面，便于管理

@property (nonatomic, copy) void(^sele)(NSString *yearStr, NSString *monthStr, NSString *dayStr);

@end

@implementation TimeSelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
    
    //显示pickview和按钮最底下的view
    self.BJView = [[UIView alloc] initWithFrame:CGRectMake(0, TWH, TWW, BJH)];
    [self addSubview:_BJView];
    
    UIView *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, TWW, toolH)];
    tool.backgroundColor = TWRGB(237, 236, 234);
    [_BJView addSubview:tool];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    left.frame = CGRectMake(0, 0, BtnW, toolH);
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftBTN) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:left];
    
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    right.frame = CGRectMake(TWW-BtnW ,0,BtnW, toolH);
    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightBTN) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:right];
    
    
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,tool.hd_y + tool.hd_height, TWW, _BJView.frame.size.height-toolH)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = TWRGB(237, 237, 237);
    [_BJView addSubview:_pickView];
    
    m=0;
    firstTimeLoad = YES;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    day =[currentDateString intValue];
    
    
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    for (int i = 1970; i <= year ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    
    
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    for (int i=1; i<month+1; i++) {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    for (int i = 1; i <day+1; i++)
    {
        [DaysMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    // PickerView - Default Selection as per current Date
    // 设置初始默认值
    [_pickView selectRow:20 inComponent:0 animated:YES];
    
    // [pickerView selectRow:30 inComponent:0 animated:NO];
    
    [_pickView selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    [_pickView selectRow:0 inComponent:2 animated:YES];
    

    
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m = row;
    if (component == 0) {
        selectedYearRow = row;
        [_pickView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [_pickView reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [_pickView reloadAllComponents];
    }
}
#pragma mark - UIPickerViewDatasource
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    
    
    return pickerLabel;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        NSInteger selectRow =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        if (selectRow==n) {
            return [monthMutableArray count];
        }else
        {
            return [monthArray count];
            
        }
    }
    else
    {
        NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        NSInteger selectRow =  [pickerView selectedRowInComponent:1];
        
        if (selectRow==month-1 &selectRow1==n) {
            
            return day;
            
        }else{
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
    }
}

/**
 *  左边的取消按钮
 */
-(void)leftBTN{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = TWH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
    
}
/**
 *  右边的确认按钮
 */
-(void)rightBTN{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = TWH;
    
    if (self.sele) {
        self.sele([yearArray objectAtIndex:[_pickView selectedRowInComponent:0]],[monthArray objectAtIndex:[_pickView selectedRowInComponent:1]],[DaysArray objectAtIndex:[_pickView selectedRowInComponent:2]]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
}

- (void)showTimeSelectView:(void (^)(NSString *, NSString *, NSString *))selectStr
{
    self.sele = selectStr;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    __weak typeof(UIView*)blockview = _BJView;
    __block int blockH = TWH;
    __block int bjH = BJH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH-bjH;
        blockview.frame = bjf;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_BJView.frame, point)) {
        [self leftBTN];
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
