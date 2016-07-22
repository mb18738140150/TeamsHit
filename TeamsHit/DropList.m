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
        self.dateArr = sourceArr;
    }
    return self;
}

- (void)creatSubViews
{
    self.backgroundColor = [UIColor clearColor];
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:self.frame];
    backImageView.image = [UIImage imageNamed:@"box_degree"];
    [self addSubview:backImageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(1, 0, self.hd_width - 2, self.hd_height - 15) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
        cell.backimageView.frame = CGRectMake(0, 0, width, width);
        cell.backimageView.center = cell.center;
        cell.backimageView.backgroundColor = [UIColor blackColor];
        cell.backimageView.layer.cornerRadius = width / 2.0;
        cell.backimageView.layer.masksToBounds = YES;
    }else if (self.listType == ListSize)
    {
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = [self.dateArr objectAtIndex:indexPath.row];
    }else
    {
        cell.imageView.hidden = NO;
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.dateArr objectAtIndex:indexPath.row]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)showWithAnimate:(BOOL)animate
{
    self.hidden = NO;
    if (animate) {
        self.frame = CGRectMake(self.rect.origin.x, self.rect.origin.y + self.hd_height, self.hd_width, 0);
        [UIView animateWithDuration:.3 animations:^{
            self.frame = self.rect;
        }];
    }else
    {
        self.frame = self.rect;
    }
}

- (void)dismiss
{
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
