//
//  SigninView.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/1.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "SigninView.h"
#import "SigninDateCollectionViewCell.h"
#import "SigninModel.h"
#define SIGNINDATECELLID @"SigninDateCollectionViewCellID"

@interface SigninView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat itemW;
    CGFloat itemH;
}

@property (nonatomic, assign)NSInteger firstWeekday;
@property (nonatomic, assign)NSInteger dateCount;


@end


@implementation SigninView

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)prepareUI
{
    itemW = [UIScreen mainScreen].bounds.size.width / 7;
    itemH = 50;
    NSArray *array = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    UIView *weekBg = [[UIView alloc]init];
    weekBg.frame = CGRectMake(0, 0, screenWidth, 30);
    [self addSubview:weekBg];
    
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.font = [UIFont fontWithName:FONTNAME size:17];
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(itemW * i, 0, itemW, itemH);
        label.textAlignment = NSTextAlignmentCenter;
        [weekBg addSubview:label];
    }
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.dateCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, itemH, screenWidth, itemH * 6) collectionViewLayout:layout];
    [self.dateCollectionView registerNib:[UINib nibWithNibName:@"SigninDateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SIGNINDATECELLID];
    self.dateCollectionView.delegate = self;
    self.dateCollectionView.dataSource = self;
    self.dateCollectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.dateCollectionView];
    
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    // 1.分析这个月的第一天是第一周的星期几
    self.firstWeekday = [self firstWeekdayInThisMotnth:date];
    
    // 2.分析这个月有多少天
    self.dateCount = [self totaldaysInMonth:date];
    
}

- (NSInteger)firstWeekdayInThisMotnth:(NSDate *)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];// 取得当前用户的逻辑日历
    [calendar setFirstWeekday:1];//设定每周的第一天从星期几开始，比如:. 如需设定从星期日开始，则value传入1 ，如需设定从星期一开始，则value传入2 ，以此类推
    NSDateComponents * comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [comp setDay:1];// 设置为这个月的第一天;
    NSDate * firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];// 这个月第一天在当前日历的顺序
    // 返回某个特定时间（date）其对应的小的时间单元（smaller）在大的时间单元（lager）中的顺序
    return firstWeekDay - 1;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]; // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的范围
    
    return daysInOfMonth.length;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SigninDateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SIGNINDATECELLID forIndexPath:indexPath];
    
    [cell cleanContaintView];
    
    if (indexPath.row >= self.firstWeekday && indexPath.row < self.firstWeekday + self.dateCount) {
        cell.backgroundColor = [UIColor clearColor];
        cell.dateLB.text = [NSString stringWithFormat:@"%d", indexPath.row - self.firstWeekday + 1];
        cell.dateLB.font = [UIFont fontWithName:FONTNAME size:19];
        
        for (SigninModel * model in self.dataArr) {
            if (model.MonthToDay == cell.dateLB.text.intValue) {
                cell.model = model;
                break;
            }
        }
        
    }
    
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
