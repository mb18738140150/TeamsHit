//
//  GroupDetailSetTipView.m
//  TeamsHit
//
//  Created by 仙林 on 16/9/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GroupDetailSetTipView.h"
#import "AppDelegate.h"
#import "GameRuleModel.h"
#import "GameRulesTableViewCell.h"

#define GAME_RULECELL_IDENTIFIRE @"gamerulecell"

@interface GroupDetailSetTipView ()

@property (nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation GroupDetailSetTipView

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSArray *)content
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUIWith:title Content:content isRule:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSArray *)content isRule:(BOOL)isRule
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUIWith:title Content:content isRule:isRule];
    }
    return self;
}


- (void)prepareUIWith:(NSString *)title Content:(NSArray *)content isRule:(BOOL)isRule
{
    self.backgroundColor = [UIColor clearColor];
    self.dataArr = [NSArray arrayWithArray:content];
    UIView * backBlackView = [[UIView alloc]initWithFrame:self.bounds];
    backBlackView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.6];
    [self addSubview:backBlackView];
    
    UIView * backWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 264, 152)];
    backWhiteView.layer.cornerRadius = 5;
    backWhiteView.layer.masksToBounds = YES;
    backWhiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backWhiteView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backWhiteView.hd_width, 44)];
    titleLabel.backgroundColor = UIColorFromRGB(0x12B7F5);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = 1;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = titleLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    titleLabel.layer.mask = maskLayer;
    [backWhiteView addSubview:titleLabel];
    
    if (isRule) {
        backWhiteView.hd_height = 201;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(22, 64, backWhiteView.hd_width - 52 , 110) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[GameRulesTableViewCell class] forCellReuseIdentifier:GAME_RULECELL_IDENTIFIRE];
        [backWhiteView addSubview:self.tableView];
        
        for (int i = 0;i < content.count;i++) {
            GameRuleModel * model = [[GameRuleModel alloc]init];
            model.number = i + 1;
            model.content = content[i];
            [model getcontentHeightWithWidth:self.tableView.hd_width - 20];
            [self.dataArray addObject:model];
        }
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [backBlackView addGestureRecognizer:tap];
        
    }else
    {
        if (content.count == 1) {
            UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 60, backWhiteView.hd_width - 54, 70)];
            tipLabel.font = [UIFont systemFontOfSize:15];
            tipLabel.textColor = UIColorFromRGB(0x12B7F5);
            tipLabel.text = content[0];
            tipLabel.numberOfLines = 0;
            CGSize tipSize = [tipLabel.text boundingRectWithSize:CGSizeMake(tipLabel.hd_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            tipLabel.hd_height = tipSize.height;
            [backWhiteView addSubview:tipLabel];
            
        }else if (content.count > 1)
        {
            self.customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, backWhiteView.hd_width, 70)];
            self.customPicker.delegate = self;
            self.customPicker.dataSource = self;
            self.customPicker.backgroundColor = [UIColor clearColor];
            
            UIView * pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, _customPicker.hd_width, 28)];
            pickBackView.backgroundColor = UIColorFromRGB(0x12B7F5);
            pickBackView.alpha = .4;
            pickBackView.userInteractionEnabled = YES;
            [backWhiteView addSubview:pickBackView];
            [backWhiteView addSubview:self.customPicker];
        }else
        {
            self.textFiled = [[UITextField alloc]initWithFrame:CGRectMake(29, 66, backWhiteView.hd_width - 58, 34)];
            self.textFiled.layer.borderColor = UIColorFromRGB(0x12B7F5).CGColor;
            self.textFiled.layer.borderWidth = 1;
            self.textFiled.layer.cornerRadius = 5;
            self.textFiled.layer.masksToBounds = YES;
            self.textFiled.borderStyle = UITextBorderStyleNone;
            
            [backWhiteView addSubview:self.textFiled];
        }
        
        
        UIButton * cancleBT = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBT.frame = CGRectMake(backWhiteView.hd_width - 94, 118, 24, 16);
        [cancleBT setTitle:@"取消" forState:UIControlStateNormal];
        cancleBT.titleLabel.font = [UIFont systemFontOfSize:12];
        [cancleBT setTitleColor:UIColorFromRGB(0xBABABA) forState:UIControlStateNormal];
        [backWhiteView addSubview:cancleBT];
        [cancleBT addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton * sureBT = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBT.frame = CGRectMake(backWhiteView.hd_width - 53, 118, 24, 16);
        [sureBT setTitle:@"确定" forState:UIControlStateNormal];
        sureBT.titleLabel.font = [UIFont systemFontOfSize:12];
        [sureBT setTitleColor:UIColorFromRGB(0x12B7F5) forState:UIControlStateNormal];
        [backWhiteView addSubview:sureBT];
        [sureBT addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    backWhiteView.center = self.center;
    
}


#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.comleteString = self.dataArr[row];
}

#pragma mark - UIPickerViewDatasource
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0, 0, self.hd_width, 23);
        pickerLabel = [[UILabel alloc]initWithFrame:frame];
        pickerLabel.textAlignment = 1;
        pickerLabel.backgroundColor = [UIColor whiteColor];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    pickerLabel.text = [self.dataArr objectAtIndex:row];
    pickerLabel.backgroundColor = [UIColor clearColor];
    
    return pickerLabel;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArr.count;
}

- (void)show
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
}

- (void)dismiss
{
    self.alpha = 1;
    [UIView animateWithDuration:.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}

- (void)completeAction
{
    if (self.textFiled) {
        if (self.textFiled.text.length != 0) {
            self.comleteString = self.textFiled.text;
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"房间名称不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if (self.myblock) {
        _myblock(self.comleteString);
        [self dismiss];
    }
}

- (void)getPickerData:(GroupDetailPickerBlock)block
{
    self.myblock = [block copy];
}

#pragma mark - tableviewdelegate datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameRulesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GAME_RULECELL_IDENTIFIRE forIndexPath:indexPath];
    [cell creatCellWithFrame:tableView.bounds];
    GameRuleModel * model = self.dataArray[indexPath.row];
    cell.numberlabel.text = [NSString stringWithFormat:@"%d", model.number];
    cell.contentLabel.text = model.content;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameRuleModel * model = self.dataArray[indexPath.row];
    if (model.height < 25) {
        return 25;
    }else
    {
        return model.height + 10;
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
