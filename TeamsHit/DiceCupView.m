//
//  DiceCupView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "DiceCupView.h"
#import "PublishCollectionViewCell.h"

#import "UIImage+GIF.h"

#define TOP_SPACE 64
#define DICECELLIDENTIFIRE @"diceCellIdentifire"

@interface DiceCupView ()<UICollectionViewDelegate, UICollectionViewDataSource>

// TipDiceCupView
@property (nonatomic, strong)UIImageView * diceCupImageView;
@property (nonatomic, strong)UIButton * tipDiceCupButton;

// DiceCupResultView
@property (nonatomic, strong)UIImageView * diceCupResultImageView;
@property (nonatomic, strong)UICollectionView * diceResultCollectionView;
@property (nonatomic, strong)UIButton * reTipdiceCupButton;
@property (nonatomic, strong)UIButton * completeButton;
@property (nonatomic, strong)UILabel * reTipLabel;
@property (nonatomic, strong)UIImageView * gifImageView;

@property (nonatomic, strong)NSMutableArray * dataSourceArr;

@end

@implementation DiceCupView

- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, self.hd_width, self.hd_height + 64)];
    backView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.4];
    [self addSubview:backView];
    
    [self creatTipDiceCupView];
    
    [self creatDiceCupResultView];
}

- (void)creatTipDiceCupView
{
    self.tipDiceCupView = [[UIView alloc]initWithFrame:self.bounds];
    self.tipDiceCupView.backgroundColor = [UIColor clearColor];
    
    self.diceCupImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 144 - TOP_SPACE, 75, 85)];
    self.diceCupImageView.hd_centerX = self.center.x;
    self.diceCupImageView.image = [UIImage imageNamed:@"骰盅"];
    [self.tipDiceCupView addSubview:self.diceCupImageView];
    
    self.tipDiceCupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _tipDiceCupButton.frame = CGRectMake(0, 242 - TOP_SPACE, 131, 20);
    _tipDiceCupButton.hd_centerX = self.center.x;
    [_tipDiceCupButton setTitle:@"点击骰盅摇一摇" forState:UIControlStateNormal];
    [_tipDiceCupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_tipDiceCupButton addTarget:self action:@selector(tipDiceCupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tipDiceCupView addSubview:self.tipDiceCupButton];
    
    [self addSubview:self.tipDiceCupView];
}

- (void)creatDiceCupResultView
{
    self.diceCuptipResultView = [[UIView alloc]initWithFrame:self.bounds];
    self.diceCuptipResultView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.diceCuptipResultView];
    
    self.diceCupResultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 143 - TOP_SPACE, 79, 89)];
    self.diceCupResultImageView.hd_centerX = self.center.x;
    self.diceCupResultImageView.image = [UIImage imageNamed:@"骰盅-1"];
    [self.diceCuptipResultView addSubview:self.diceCupResultImageView];
    
    self.gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(73, 246 - TOP_SPACE, self.hd_width - 146, (self.hd_width - 146 - 48) / 5)];
    [self loadGifImageView];
    [self.diceCuptipResultView addSubview:self.gifImageView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((self.hd_width - 146 - 48) / 5, (self.hd_width - 146 - 48) / 5);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 12;
    
    self.diceResultCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(73, 246 - TOP_SPACE, self.hd_width - 146, (self.hd_width - 146 - 48) / 5) collectionViewLayout:layout];
    [self.diceResultCollectionView registerClass:[PublishCollectionViewCell class] forCellWithReuseIdentifier:DICECELLIDENTIFIRE];
    self.diceResultCollectionView.backgroundColor = [UIColor clearColor];
    self.diceResultCollectionView.delegate = self;
    self.diceResultCollectionView.dataSource = self;
    self.diceResultCollectionView.hidden = YES;
    [self.diceCuptipResultView addSubview:self.diceResultCollectionView];
    
    self.reTipdiceCupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reTipdiceCupButton.frame = CGRectMake(self.hd_width / 2 - 85, 299 - TOP_SPACE, 68, 28);
    self.reTipdiceCupButton.layer.cornerRadius = 14;
    self.reTipdiceCupButton.layer.masksToBounds = YES;
    self.reTipdiceCupButton.backgroundColor = [UIColor colorWithWhite:.9 alpha:.5];
    [self.reTipdiceCupButton setTitle:@"重摇" forState:UIControlStateNormal];
    [self.reTipdiceCupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.diceCuptipResultView addSubview:self.reTipdiceCupButton];
    [self.reTipdiceCupButton addTarget:self action:@selector(reTipDiceCupAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.completeButton.frame = CGRectMake(self.hd_width / 2 + 17, 299 - TOP_SPACE, 68, 28);
    self.completeButton.layer.cornerRadius = 14;
    self.completeButton.layer.masksToBounds = YES;
    self.completeButton.backgroundColor = [UIColor colorWithWhite:.9 alpha:.5];
    [self.completeButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.diceCuptipResultView addSubview:self.completeButton];
    [self.completeButton addTarget:self action:@selector(completeTipDiceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.reTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width / 2 - 75, 348 - TOP_SPACE, 150, 13)];
    self.reTipLabel.textColor = [UIColor whiteColor];
    self.reTipLabel.textAlignment = 1;
    self.reTipLabel.font = [UIFont systemFontOfSize:13];
    self.reTipLabel.text = @"重摇需要30碰碰币";
    [self.diceCuptipResultView addSubview:self.reTipLabel];
    
    self.diceCuptipResultView.hidden = YES;
}

- (void)loadGifImageView
{
    NSString * filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"111.gif" ofType:nil];
    
    NSData * imageData = [NSData dataWithContentsOfFile:filePath];
    self.gifImageView.image = [UIImage sd_animatedGIFWithData:imageData];
}

#pragma mark - 摇骰盅
- (void)tipDiceCupAction:(UIButton *)button
{
    if (self.delegete && [self.delegete respondsToSelector:@selector(tipDiceCup)]) {
        [self.delegete tipDiceCup];
    }
    
    // 摇骰子动画
    [self startTipDiceCup];
    
    [self performSelector:@selector(showResult) withObject:nil afterDelay:1.2];
    
}

- (void)startTipDiceCup
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.hd_width / 2 - 75  - 20,
                                                                    144 + 42.5  - TOP_SPACE)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.hd_width / 2 + 75  + 20,
                                                                  144 + 42.5 - TOP_SPACE)];
    moveAnimation.autoreverses = YES;
    moveAnimation.repeatCount = 4;
    moveAnimation.duration = .3;
    
    [self.diceCupImageView.layer addAnimation:moveAnimation forKey:@"positionAnnimation"];
}

- (void)showResult
{
    self.tipDiceCupView.hidden = YES;
    self.diceCuptipResultView.hidden = NO;
    [self startGif];
}

#pragma mark - 摇骰盅结果

- (void)startGif
{
    self.gifImageView.hidden = NO;
    self.diceResultCollectionView.hidden = YES;
    
    [self performSelector:@selector(endGif) withObject:nil afterDelay:1.5];
}

- (void)endGif
{
    self.gifImageView.hidden = YES;
    self.diceResultCollectionView.hidden = NO;
    
    [self.dataSourceArr removeAllObjects];
    for (int i = 0; i < 5; i++) {
        int a = arc4random() % (5) + 1;
        [self.dataSourceArr addObject:[NSString stringWithFormat:@"%d", a]];
    }
    [self.diceResultCollectionView reloadData];
}

- (void)reTipDiceCupAction:(UIButton *)button
{
    NSLog(@"重摇");
    [self startGif];
}

- (void)completeTipDiceAction:(UIButton *)button
{
    NSLog(@"确定");
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:DICECELLIDENTIFIRE forIndexPath:indexPath];
    cell.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"骰子%@", self.dataSourceArr[indexPath.row]]];
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
