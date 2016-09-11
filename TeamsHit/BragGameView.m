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

#import "DiceCupView.h"

#define BRAGEGAMECELLIDENTIFIRE @"BRAGEGAMECELL"
#define BRAGEGAMESCORECELLIDENTIFIRE @"bragGameScoreCell"

@interface BragGameView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)DiceCupView * diceCupView;

@end

@implementation BragGameView

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
    [self addSubview:self.scoreTableView];
    
    self.diceCupView = [[DiceCupView alloc]initWithFrame:self.bounds];
    [self addSubview:self.diceCupView];
    
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
        return 16;
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
         cell.backgroundColor = [UIColor clearColor];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
