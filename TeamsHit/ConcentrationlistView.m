//
//  ConcentrationlistView.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/10.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "ConcentrationlistView.h"
#import "ConcentrationLayout.h"
#import "ConcentrationCollectionViewCell.h"
#import "AppDelegate.h"

#define CONCENTRATIONCELLID @"ConcentrationCollectionViewCellid"

@interface ConcentrationModel : NSObject

@property (nonatomic, assign)int concentrationNumber;
@property (nonatomic, assign)BOOL isSelect;

@end

@implementation ConcentrationModel


@end

@interface ConcentrationlistView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UIView *concentrationListView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIButton * completeBT;
@property (nonatomic, strong)UICollectionView * concentrationCollectionView;

@property (nonatomic, strong)NSMutableArray * dataArr;
@property (nonatomic, strong)ConcentrationModel * myModel;
@property (nonatomic, copy)ModifyConcentration myBlock;
@property (nonatomic, strong)ConcentrationLayout * layout;
@end

@implementation ConcentrationlistView

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame with:(int)concentrationNum
{
    if (self = [super initWithFrame:frame]) {
        self.concentrationNum = concentrationNum;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.6];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
    
    self.concentrationListView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 195, self.frame.size.width, 195)];
    self.concentrationListView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.concentrationListView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.concentrationListView.center.x - 80, 27, 80, 17)];
    self.titleLabel.textAlignment = 1;
    self.titleLabel.text = @"设置浓度";
    self.titleLabel.textColor = UIColorFromRGB(0x12B7F5);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.concentrationListView addSubview:self.titleLabel];
    
    self.completeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.completeBT.frame = CGRectMake(self.concentrationListView.hd_width - 18 - 50, 25, 50, 20);
    self.completeBT.layer.cornerRadius  = 3;
    self.completeBT.layer.masksToBounds = YES;
    self.completeBT.layer.borderWidth = 1;
    self.completeBT.layer.borderColor = UIColorFromRGB(0xBFBFBF).CGColor;
    self.completeBT.backgroundColor = [UIColor whiteColor];
    [self.completeBT setTitle:@"确定" forState:UIControlStateNormal];
    [self.completeBT setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    self.completeBT.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.concentrationListView addSubview:self.completeBT];
    [self.completeBT addTarget:self action:@selector(complateAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.layout = [[ConcentrationLayout alloc]init];
    _layout.selectNum = self.concentrationNum;
    self.concentrationCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 74, self.hd_width - 60, 76) collectionViewLayout:_layout];
    self.concentrationCollectionView.backgroundColor = [UIColor whiteColor];
    self.concentrationCollectionView.scrollEnabled = NO;
    self.concentrationCollectionView.delegate = self;
    self.concentrationCollectionView.dataSource = self;
    [self.concentrationCollectionView registerNib:[UINib nibWithNibName:@"ConcentrationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CONCENTRATIONCELLID];
    [self.concentrationListView addSubview:self.concentrationCollectionView];
    
    for (int i = 0; i < 8; i++) {
        ConcentrationModel * model = [[ConcentrationModel alloc]init];
        model.concentrationNumber = i+1;
        model.isSelect = NO;
        if (i+1 == self.concentrationNum) {
            model.isSelect = YES;
            self.myModel = model;
        }
        [self.dataArr addObject:model];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ConcentrationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CONCENTRATIONCELLID forIndexPath:indexPath];
    ConcentrationModel * mocel = self.dataArr[indexPath.item];
    cell.concentrationLB.text = [NSString stringWithFormat:@"%d", mocel.concentrationNumber];
    if (mocel.isSelect) {
        cell.backView.backgroundColor = MAIN_COLOR;
        cell.selectTyleImageView.hidden = NO;
        
    }else
    {
        cell.backView.backgroundColor = UIColorFromRGB(0xBFBFBF);
        cell.selectTyleImageView.hidden = YES;
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myModel) {
        self.myModel.isSelect = NO;
    }
    
    self.myModel = self.dataArr[indexPath.row];
    self.myModel.isSelect = YES;
    _layout.selectNum = self.myModel.concentrationNumber-1;
    [self.concentrationCollectionView reloadData];
}

- (void)show
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:self];
    self.concentrationListView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 195);
    [UIView animateWithDuration:.3 animations:^{
        self.concentrationListView.frame = CGRectMake(0, self.frame.size.height - 195, self.frame.size.width, 195);
    }];
    
}

- (void)complateAction
{
    if (self.myBlock) {
        _myBlock(self.myModel.concentrationNumber);
    }
    [self dismiss];
}

- (void)modifyConcentration:(ModifyConcentration)Block
{
    self.myBlock = [Block copy];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
