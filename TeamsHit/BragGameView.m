//
//  BragGameView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/10.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "BragGameView.h"

#import "BraggameTableViewCell.h"
#import "BragGameScoreTableViewCell.h"
#import "ChooseDicenumberView.h"
#import "DiceCupView.h"

#define BRAGEGAMECELLIDENTIFIRE @"BRAGEGAMECELL"
#define BRAGEGAMESCORECELLIDENTIFIRE @"bragGameScoreCell"

@interface BragGameView()<UITableViewDelegate, UITableViewDataSource, TipDiceCupProtocol, ChooseDiceNumberProtocol>

@property (nonatomic, strong)DiceCupView * diceCupView;
@property (nonatomic, strong)ChooseDicenumberView * chooseDiceNumberView;

@property (nonatomic, strong)NSMutableArray * resultDataSource;

@end

@implementation BragGameView

- (NSMutableArray *)resultDataSource
{
    if (!_resultDataSource) {
        self.resultDataSource = [NSMutableArray array];
    }
    return _resultDataSource;
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
    
    self.gametableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 33, 360) style:UITableViewStylePlain];
    self.gametableView.delegate = self;
    self.gametableView.dataSource = self;
    self.gametableView.backgroundColor = [UIColor clearColor];
    [self.gametableView registerClass:[BraggameTableViewCell class] forCellReuseIdentifier:BRAGEGAMECELLIDENTIFIRE];
    [self addSubview:self.gametableView];
    
    
    self.scoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.hd_width - 33, 16, 33, 340) style:UITableViewStylePlain];
    self.scoreTableView.delegate = self;
    self.scoreTableView.dataSource = self;
    self.scoreTableView.backgroundColor = [UIColor clearColor];
    [self.scoreTableView registerClass:[BragGameScoreTableViewCell class] forCellReuseIdentifier:BRAGEGAMESCORECELLIDENTIFIRE];
    self.scoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoreTableView.transform = CGAffineTransformMakeScale(1, -1);
    [self addSubview:self.scoreTableView];
    
    self.diceCupView = [[DiceCupView alloc]initWithFrame:self.bounds];
    self.diceCupView.delegete = self;
    self.diceCupView.hidden = YES;
    [self addSubview:self.diceCupView];
    
    self.chooseDiceNumberView = [[ChooseDicenumberView alloc]initWithFrame:self.bounds withDiceNumber:4 andDicePoint:3];
    self.chooseDiceNumberView.delegate = self;
    [self addSubview:self.chooseDiceNumberView];
    self.chooseDiceNumberView.hidden = YES;
    
    for (int i = 1; i <= 16; i++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        [self.resultDataSource addObject:str];
    }
    [self.scoreTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.gametableView]) {
        return 6;
    }else
    {
        return self.resultDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.gametableView]) {
        BraggameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BRAGEGAMECELLIDENTIFIRE forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else
    {
        BragGameScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BRAGEGAMESCORECELLIDENTIFIRE forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale(1, -1);
        [cell creatWithFrame:tableView.bounds];
        cell.numberLabel.text = self.resultDataSource[indexPath.row];
        if (indexPath.row < self.resultDataSource.count / 2) {
            cell.numberLabel.backgroundColor = UIColorFromRGB(0xF8B551);
        }
        if (indexPath.row == self.resultDataSource.count / 4 * 3 || indexPath.row == self.resultDataSource.count / 4 ) {
            cell.winImageView.hidden = NO;
            cell.iswin = YES;
        }else
        {
            cell.winImageView.hidden = YES;
            cell.iswin = NO;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.gametableView]) {
        return 60;
    }else
    {
        return 16;
    }
}

#pragma mark - TipDiceCupProtocol
- (void)tipDiceCup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragShakeDIceCup)]) {
        [self.delegate bragShakeDIceCup];
    }
}
- (void)reShakeCup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragReshakeCup)]) {
        [self.delegate bragReshakeCup];
    }
}

- (void)completeShakeDiceCup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragCompleteShakeDiceCup)]) {
        [self.delegate bragCompleteShakeDiceCup];
    }
    self.diceCupView.hidden = YES;
    self.chooseDiceNumberView.hidden = NO;
    [self.chooseDiceNumberView show];
}

#pragma mark - ChooseDiceNumberProtocol
- (void)chooseCompleteWithnumber:(int)number point:(int )point
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bragChooseCompleteWithnumber:point:)]) {
        [self.delegate bragChooseCompleteWithnumber:number point:point];
    }
}

- (void)begainState
{
    self.diceCupView.hidden = NO;
    self.diceCupView.tipDiceCupView.hidden = NO;
    self.diceCupView.diceCuptipResultView.hidden = YES;
    self.chooseDiceNumberView.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
