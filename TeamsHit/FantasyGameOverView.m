//
//  FantasyGameOverView.m
//  TeamsHit
//
//  Created by 仙林 on 16/12/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "FantasyGameOverView.h"
#import "FantasyGamerInfoModel.h"
#import "FantasyResulttableviewcell.h"
#import "AppDelegate.h"

#define FANTASYRESULTTABLEVIEWCELLID @"FANTASYRESULTTABLEVIEWCELLID"

@interface FantasyGameOverView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray * resultDataArr;
@property (nonatomic, strong)UITableView * resultTableview;

@end

@implementation FantasyGameOverView

- (NSMutableArray *)resultDataArr
{
    if (!_resultDataArr) {
        _resultDataArr = [NSMutableArray array];
    }
    return _resultDataArr;
}

- (instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)resultGamerInfoArr
{
    if (self = [super initWithFrame:frame]) {
        self.resultDataArr = [resultGamerInfoArr mutableCopy];
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.5];
    [self addSubview:backView];
    
    
    int height = 50 + 40 * self.resultDataArr.count + 95;
    
    UIImageView * cartoonheadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.hd_height - height) / 2, 97, 118)];
    cartoonheadImageView.hd_centerX = backView.hd_centerX;
    cartoonheadImageView.image = [UIImage imageNamed:@"bragGameOverSign"];
    [self addSubview:cartoonheadImageView];
    
    self.resultTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(cartoonheadImageView.frame) + 95, 195, height - 95) style:UITableViewStylePlain];
    self.resultTableview.hd_centerX = backView.hd_centerX;
    [self.resultTableview registerClass:[FantasyResulttableviewcell class] forCellReuseIdentifier:FANTASYRESULTTABLEVIEWCELLID];
    self.resultTableview.tableHeaderView = [self getTableviewheaderView];
    self.resultTableview.delegate = self;
    self.resultTableview.dataSource = self;
    self.resultTableview.layer.cornerRadius = 5;
    self.resultTableview.layer.masksToBounds = YES;
    self.resultTableview.backgroundColor = UIColorFromRGB(0xA551E7);
    [self addSubview:self.resultTableview];
    
    UIImageView * cartoonLeftHandImageview = [[UIImageView alloc]initWithFrame:CGRectMake(_resultTableview.hd_x - 9, 39 + CGRectGetMidY(_resultTableview.frame), 18, 18)];
    cartoonLeftHandImageview.backgroundColor = UIColorFromRGB(0x12B7F5);
    cartoonLeftHandImageview.layer.cornerRadius = 9;
    cartoonLeftHandImageview.layer.masksToBounds = YES;
    [self addSubview:cartoonLeftHandImageview];
    
    UIImageView * cartoonrightHandImageview = [[UIImageView alloc]initWithFrame:CGRectMake(_resultTableview.hd_x + _resultTableview.hd_width - 9, -39 + CGRectGetMidY(_resultTableview.frame) - 18, 18, 18)];
    cartoonrightHandImageview.backgroundColor = UIColorFromRGB(0x12B7F5);
    cartoonrightHandImageview.layer.cornerRadius = 9;
    cartoonrightHandImageview.layer.masksToBounds = YES;
    [self addSubview:cartoonrightHandImageview];
    
    [self.resultTableview reloadData];
}

- (UIView *)getTableviewheaderView
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.resultTableview.hd_width, 37)];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, headerView.hd_width, 23)];
    titleLabel.hd_centerX = headerView.hd_centerX;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textAlignment = 1;
    titleLabel.text = @"游戏结束";
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FantasyResulttableviewcell * cell = [tableView dequeueReusableCellWithIdentifier:FANTASYRESULTTABLEVIEWCELLID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [cell creatSubviews];
    cell.gamerInfoModel = [self.resultDataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)show
{
    AppDelegate * delegate = ShareApplicationDelegate;
    [delegate.window addSubview:self];
    
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
