//
//  ChooseCreatGameTypeView.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ChooseCreatGameTypeView.h"
#import "CreatGamerTypeCollectionViewCell.h"
#import "AppDelegate.h"

#define CREATGAMETYPECOLLECTIONVIEWCELLID @"CreatGamerTypeCollectionViewCellId"

@interface CreatgametypeModel:NSObject

@property (nonatomic, copy)NSString * typeIconString;
@property (nonatomic, copy)NSString * typeNameString;

@end

@implementation CreatgametypeModel


@end

@interface ChooseCreatGameTypeView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * gameTypeCollectionview;
@property (nonatomic, strong)NSMutableArray * gameTypeDataArr;
@property (nonatomic, strong)UIButton * closeBT;

@end


@implementation ChooseCreatGameTypeView

- (NSMutableArray *)gameTypeDataArr
{
    if (!_gameTypeDataArr) {
        _gameTypeDataArr = [NSMutableArray array];
    }
    return _gameTypeDataArr;
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
    
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.5];
    [self addSubview:backView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(50, 70);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 26;
    layout.minimumLineSpacing = 30;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.gameTypeCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake((screenWidth - 204) / 2, (screenHeight - 70) / 2, 204, 70) collectionViewLayout:layout];
    self.gameTypeCollectionview.backgroundColor = [UIColor clearColor];
    [self.gameTypeCollectionview registerClass:[CreatGamerTypeCollectionViewCell class] forCellWithReuseIdentifier:CREATGAMETYPECOLLECTIONVIEWCELLID];
    self.gameTypeCollectionview.delegate = self;
    self.gameTypeCollectionview.dataSource = self;
    [self addSubview:self.gameTypeCollectionview];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_gameTypeCollectionview.frame) - 45, backView.hd_width, 18)];
    titleLabel.text = @"请选择游戏类型";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = 1;
    [self addSubview:titleLabel];
    
    self.closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBT.frame = CGRectMake((screenWidth - 28) / 2, CGRectGetMaxY(_gameTypeCollectionview.frame) + 41, 28, 28);
    [self.closeBT setImage:[UIImage imageNamed:@"closecreatgameviewBT"] forState:UIControlStateNormal];
    [self.closeBT addTarget:self action:@selector(closecreatgametypeviewAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBT];
    
    CreatgametypeModel * bragModel = [[CreatgametypeModel alloc]init];
    bragModel.typeIconString = @"creatBraggamesign";
    bragModel.typeNameString = @"吹牛";
    [self.gameTypeDataArr addObject:bragModel];
    
    CreatgametypeModel * fantasyModel = [[CreatgametypeModel alloc]init];
    fantasyModel.typeIconString = @"creatfantasygamesign";
    fantasyModel.typeNameString = @"梦幻";
    [self.gameTypeDataArr addObject:fantasyModel];
    
    [self.gameTypeCollectionview reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gameTypeDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CreatGamerTypeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CREATGAMETYPECOLLECTIONVIEWCELLID forIndexPath:indexPath];
    CreatgametypeModel * model = [self.gameTypeDataArr objectAtIndex:indexPath.row];
    cell.typeIconImageview.image = [UIImage imageNamed:model.typeIconString];
    cell.typeNamelabel.text = model.typeNameString;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeFromSuperview];
}

- (void)closecreatgametypeviewAction
{
    [self removeFromSuperview];
}

- (void)show
{
    AppDelegate * delegate = ShareApplicationDelegate;
    [delegate.window addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
