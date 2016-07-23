//
//  DropList.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "DropList.h"
#import "DropListCell.h"
#define CELL_ID @"cellidentifire"

@interface DropList ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign)ListType listType;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dateArr;

@property (nonatomic, copy)SelectBlock selectBlock;
@property (nonatomic, assign)CGRect rect;

@end

@implementation DropList

- (NSMutableArray *)dateArr
{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}

- (instancetype)initWithFrame:(CGRect)frame listType:(ListType)listType sourceArr:(NSArray *)sourceArr
{
    if (self = [super initWithFrame:frame]) {
        self.listType = listType;
        [self creatSubViews];
        self.rect = frame;
        self.dateArr = [sourceArr mutableCopy];
    }
    return self;
}

- (void)creatSubViews
{
    self.backgroundColor = [UIColor clearColor];
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"box_degree"];
    [self addSubview:backImageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(1, 1, self.frame.size.width - 2, self.frame.size.height - 10) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropListCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (nil == cell) {
        cell = [[DropListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    
    if (self.listType == ListWidth) {
        cell.imageView.hidden = NO;
        CGFloat width = [[self.dateArr objectAtIndex:indexPath.row] floatValue];
        NSLog(@"width = %f", width);
        cell.backimageView.frame = CGRectMake(0, 0, width, width);
        cell.backimageView.center = CGPointMake(15, 15);
        cell.backimageView.backgroundColor = [UIColor blackColor];
        cell.backimageView.layer.cornerRadius = width / 2.0;
        cell.backimageView.layer.masksToBounds = YES;
    }else if (self.listType == ListSize)
    {
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = [self.dateArr objectAtIndex:indexPath.row];
    }else
    {
        cell.backimageView.hidden = NO;
        cell.backimageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.dateArr objectAtIndex:indexPath.row]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)showWithAnimate:(BOOL)animate
{
    NSLog(@"**%f", self.tableView.frame.size.width);
    
    self.hidden = NO;
    if (animate) {
        self.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 1.0;
        }];
    }else
    {
        self.alpha = 1.0;
    }
}

- (void)dismiss
{
    self.hidden = YES;
}

- (void)getSelectRow:(SelectBlock)selectBlock
{
    self.selectBlock = [selectBlock copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
