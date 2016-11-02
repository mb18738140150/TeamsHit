//
//  ChooseDicenumberView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ChooseDicenumberView.h"
#import "DIcePointAndCountCollectionViewCell.h"

#import "ChooseDiceModel.h"
#define DICEPOINTANDCOUNTCELLIDENTIFIRE @"dicePointAndcountcell"

@interface ChooseDicenumberView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIView * backView;
}

@property (nonatomic, strong)UILabel *countdownLabel;// 倒计时label
@property (nonatomic, strong)UILabel * diceCountlabel;// 所选骰子个数label
@property (nonatomic, strong)UIImageView * dicePointImageView;// 所选骰子点数
@property (nonatomic, strong)UIButton * completeBT;

// 初始骰子点数以及骰子数量
@property (nonatomic, assign)int begainDiceCount;
@property (nonatomic, assign)int begainDicePoint;

// 倒计时
@property (nonatomic, strong)NSTimer * timer;
@property (nonatomic, assign)int timeLenght;

// 骰子数量
@property (nonatomic, strong)UICollectionView * diceCountCollectionView;
@property (nonatomic, strong)NSMutableArray * diceCountDataArray;
@property (nonatomic, assign)int diceCountIndex;
// 骰子点数
@property (nonatomic, strong)UICollectionView * dicePointCollectionView;
@property (nonatomic, strong)NSMutableArray * dicePOintDataArray;
@property (nonatomic, assign)int dicepointIndex;

@end

@implementation ChooseDicenumberView

- (NSMutableArray *)dicePOintDataArray
{
    if (!_dicePOintDataArray) {
        self.dicePOintDataArray = [NSMutableArray array];
    }
    return _dicePOintDataArray;
}

- (NSMutableArray *)diceCountDataArray
{
    if (!_diceCountDataArray) {
        self.diceCountDataArray = [NSMutableArray array];
    }
    return _diceCountDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame withDiceNumber:(int)diceNumber andDicePoint:(int)dicePoint
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUIwith:diceNumber dicePoint:dicePoint];
        self.begainDiceCount = diceNumber;
        self.begainDicePoint = dicePoint;
    }
    return self;
}

- (void)prepareUIwith:(int)diceNumber dicePoint:(int)dicePoint
{
    self.backgroundColor = [UIColor clearColor];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, self.hd_width, self.hd_height + 64)];
    backView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.4];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
    
    UIView * backWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 233, 216)];
    backWhiteView.layer.cornerRadius = 5;
    backWhiteView.layer.masksToBounds = YES;
    backWhiteView.hd_centerX = self.center.x;
    backWhiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backWhiteView];
    
    UIView * whiteHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backWhiteView.hd_width, 93)];
    whiteHeaderView.backgroundColor = UIColorFromRGB(0x12B7F5);
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteHeaderView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = whiteHeaderView.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteHeaderView.layer.mask = maskLayer;
    [backWhiteView addSubview:whiteHeaderView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(73, 13, backWhiteView.hd_width, 14)];
    titleLabel.backgroundColor = UIColorFromRGB(0x12B7F5);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"选择骰子数";
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [backWhiteView addSubview:titleLabel];
    
    UIImageView * countdownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 28, 31)];
    countdownImageView.backgroundColor = [UIColor clearColor];
    countdownImageView.image = [UIImage imageNamed:@"时钟"];
    [backWhiteView addSubview:countdownImageView];
    
    self.countdownLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.countdownLabel.center = countdownImageView.center;
    self.countdownLabel.textAlignment = 1;
    self.countdownLabel.text = @"30";
    self.countdownLabel.font = [UIFont systemFontOfSize:12];
    self.countdownLabel.backgroundColor = [UIColor clearColor];
    [backWhiteView addSubview:self.countdownLabel];
    
    self.diceCountlabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 48, 30, 30)];
    self.diceCountlabel.backgroundColor = UIColorFromRGB(0x0598E1);
    self.diceCountlabel.textColor = [UIColor whiteColor];
    self.diceCountlabel.font = [UIFont systemFontOfSize:18];
    self.diceCountlabel.text = [NSString stringWithFormat:@"%d", diceNumber];
    self.diceCountlabel.textAlignment = 1;
    self.diceCountlabel.layer.cornerRadius = 15;
    self.diceCountlabel.layer.masksToBounds = YES;
    [backWhiteView addSubview:self.diceCountlabel];
    
    UILabel * geLabel = [[UILabel alloc]initWithFrame:CGRectMake(99, 53, 18, 18)];
    geLabel.backgroundColor = UIColorFromRGB(0x12B7F5);
    geLabel.textColor = [UIColor whiteColor];
    geLabel.textAlignment = 1;
    geLabel.text = @"个";
    [backWhiteView addSubview:geLabel];
    
    UIView * dicePointView = [[UIView alloc]initWithFrame:CGRectMake(134, 48, 30, 30)];
    dicePointView.backgroundColor = UIColorFromRGB(0x0598E1);
    dicePointView.layer.cornerRadius = 15;
    dicePointView.layer.masksToBounds = YES;
    [backWhiteView addSubview:dicePointView];
    
    self.dicePointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    self.dicePointImageView.center = dicePointView.center;
    self.dicePointImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"骰子%d", dicePoint]];
    self.dicePointImageView.backgroundColor = [UIColor clearColor];
    [backWhiteView addSubview:self.dicePointImageView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((backWhiteView.hd_width - 20 - 50) / 6, (backWhiteView.hd_width - 20 - 50) / 6);
    layout.minimumInteritemSpacing = 10;
    
    self.diceCountCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 108, backWhiteView.hd_width - 20, 27) collectionViewLayout:layout];
    self.diceCountCollectionView.delegate = self;
    self.diceCountCollectionView.dataSource = self;
    self.diceCountCollectionView.backgroundColor = [UIColor whiteColor];
    [self.diceCountCollectionView registerClass:[DIcePointAndCountCollectionViewCell class] forCellWithReuseIdentifier:DICEPOINTANDCOUNTCELLIDENTIFIRE];
    [backWhiteView addSubview:self.diceCountCollectionView];
    
    self.dicePointCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 148, backWhiteView.hd_width - 20, 27) collectionViewLayout:layout];
    self.dicePointCollectionView.delegate = self;
    self.dicePointCollectionView.dataSource = self;
    self.dicePointCollectionView.backgroundColor = [UIColor whiteColor];
    [self.dicePointCollectionView registerClass:[DIcePointAndCountCollectionViewCell class] forCellWithReuseIdentifier:DICEPOINTANDCOUNTCELLIDENTIFIRE];
    [backWhiteView addSubview:self.dicePointCollectionView];
    
    self.completeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.completeBT.frame = CGRectMake(81, 187, 69, 22);
    [self.completeBT setTitle:@"确定" forState:UIControlStateNormal];
    [self.completeBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.completeBT.backgroundColor = UIColorFromRGB(0x0598E1);
    self.completeBT.layer.cornerRadius = 5;
    self.completeBT.layer.masksToBounds = YES;
    [backWhiteView addSubview:self.completeBT];
    [self.completeBT addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)refreshViewWithDiceNumber:(int)diceNumber andDicePoint:(int)dicePoint
{
    [self.diceCountDataArray removeAllObjects];
    [self.dicePOintDataArray removeAllObjects];
    self.diceCountlabel.text = [NSString stringWithFormat:@"%d", diceNumber];
    self.dicePointImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"骰子%d", dicePoint]];
    self.begainDiceCount = diceNumber;
    self.begainDicePoint = dicePoint;
    NSArray * pointarray = @[@"骰子1", @"骰子2", @"骰子3", @"骰子4", @"骰子5", @"骰子6"];
    for (int i = 0; i < 6; i++) {
        ChooseDiceModel * model = [[ChooseDiceModel alloc]init];
        if (i + 1 == dicePoint) {
            model.isSelect = YES;
            self.dicepointIndex = i;
        }else
        {
            model.isSelect = NO;
        }
        model.contentStr = pointarray[i];
        model.isPointModel = YES;
        [self.dicePOintDataArray addObject:model];
    }
    
    for (int i = 0; i < 6; i++) {
        NSString * str = [NSString stringWithFormat:@"%d", i + diceNumber];
//        if (diceNumber + i > self.maxPointCount) {
//            break;
//        }
        if (i == 5) {
            str = @"+1";
        }
        
        ChooseDiceModel * model = [[ChooseDiceModel alloc]init];
        if (i == 0) {
            model.isSelect = YES;
            self.diceCountIndex = i;
        }else
        {
            model.isSelect = NO;
        }
        model.contentStr = str;
        model.isPointModel = NO;
        [self.diceCountDataArray addObject:model];
    }
    
    [self.dicePointCollectionView reloadData];
    [self.diceCountCollectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.dicePointCollectionView]) {
        return self.dicePOintDataArray.count;
    }else
    {
        return self.diceCountDataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([collectionView isEqual:self.dicePointCollectionView]) {
        DIcePointAndCountCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DICEPOINTANDCOUNTCELLIDENTIFIRE forIndexPath:indexPath];
        ChooseDiceModel * model = [self.dicePOintDataArray objectAtIndex:indexPath.row];
        cell.chooseDiceModel = model;
        return cell;
    }else
    {
        DIcePointAndCountCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DICEPOINTANDCOUNTCELLIDENTIFIRE forIndexPath:indexPath];
        ChooseDiceModel * model = [self.diceCountDataArray objectAtIndex:indexPath.row];
        cell.chooseDiceModel = model;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.dicePointCollectionView]) {
        if (self.dicepointIndex == indexPath.row) {
            ;
        }else
        {
            ChooseDiceModel * model = [self.dicePOintDataArray objectAtIndex:self.dicepointIndex];
            model.isSelect = NO;
        }
        self.dicepointIndex = indexPath.row;
        ChooseDiceModel * model = [self.dicePOintDataArray objectAtIndex:indexPath.row];
        model.isSelect = YES;
        
        self.dicePointImageView.image = [UIImage imageNamed:model.contentStr];
        
        [self.dicePointCollectionView reloadData];
        
    }else
    {
        if (self.diceCountIndex != indexPath.row) {
            ChooseDiceModel * model = [self.diceCountDataArray objectAtIndex:self.diceCountIndex];
            model.isSelect = NO;
        }
        self.diceCountIndex = indexPath.row;
        ChooseDiceModel * model = [self.diceCountDataArray objectAtIndex:indexPath.row];
        model.isSelect = YES;
        
        if (indexPath.row == self.diceCountDataArray.count - 1) {
            NSLog(@"self.diceCountlabel.text = %@", self.diceCountlabel.text);
            
            if (self.diceCountlabel.text.intValue >= self.maxPointCount) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能叫更大点数了" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else
            {
                self.diceCountlabel.text = [NSString stringWithFormat:@"%d", self.diceCountlabel.text.intValue + 1];
            }
            
        }else
        {
            if (model.contentStr.intValue > self.maxPointCount) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能叫更大点数了" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else
            {
                self.diceCountlabel.text = model.contentStr;
            }
        }
        
        [self.diceCountCollectionView reloadData];
    }
}

#pragma mark - completeChoose
- (void)completeAction:(UIButton *)button
{
    ChooseDiceModel * model = [self.diceCountDataArray objectAtIndex:self.diceCountIndex];
    int count = 0;
    if ([model.contentStr isEqualToString:@"+1"]) {
        count = self.diceCountlabel.text.intValue;
    }else
    {
        count = model.contentStr.intValue;
    }
    
    if (self.isOnePoint) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseCompleteWithnumber:point:)]) {
            [self.delegate chooseCompleteWithnumber:count point:self.dicepointIndex + 1];
        }
        
        [self dismiss];
    }else
    {
        if (self.dicepointIndex + 1 != 1) {
            if (count < self.begainDiceCount || (count == self.begainDiceCount && self.dicepointIndex + 1 < self.begainDicePoint) ) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"所选择的骰子数量必须大于上家所选数量" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(chooseCompleteWithnumber:point:)]) {
                    [self.delegate chooseCompleteWithnumber:count point:self.dicepointIndex + 1];
                }
                
                [self dismiss];
            }
        }else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chooseCompleteWithnumber:point:)]) {
                [self.delegate chooseCompleteWithnumber:count point:self.dicepointIndex + 1];
            }
            
            [self dismiss];
        }
        
    }
}

- (void)show
{
    self.timeLenght = self.leaveTime;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown
{
    self.timeLenght--;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d", self.timeLenght];
    if (self.timeLenght <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self dismiss];
    }
    NSLog(@"剩余时间 %d", self.timeLenght);
}

- (void)dismiss
{
    [self.timer invalidate];
    self.timer = nil;
    self.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
