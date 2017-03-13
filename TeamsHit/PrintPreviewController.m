//
//  PrintPreviewController.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PrintPreviewController.h"
#import "MaterialDataModel.h"
#import "PrintPreviewCell.h"

#define TOUSERHEIGHT 33

static NSString* ALCELLID = @"PrintPreviewCellId";
@interface PrintPreviewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIButton * styleBT;
@property (nonatomic, strong)UITableView * printTableView;

@property (nonatomic, strong)UIView * headerView;
@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UILabel * importantLabel;
@property (nonatomic, strong)UIImageView * importantImageView;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UIImageView * imaginariView;
@property (nonatomic, strong)UILabel * toUsernameLabel;
@property (nonatomic, strong)UIImageView * tousernameImaginariView;

@property (nonatomic, assign)BOOL isImportantInformation;
@end

@implementation PrintPreviewController

- (NSMutableArray *)printDataSourceArr
{
    if (!_printDataSourceArr) {
        _printDataSourceArr = [NSMutableArray array];
    }
    return _printDataSourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"img_back"] title:@""];
    self.title = @"打印预览";
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打印" style:UIBarButtonItemStylePlain target:self action:@selector(printAction)];
    
    if (self.userId.intValue == [RCIM sharedRCIM].currentUserInfo.userId.intValue) {
        self.userName = [RCIM sharedRCIM].currentUserInfo.name;
    }else
    {
        
        RCDUserInfo * userInfo = [[RCDataBaseManager shareInstance]getFriendInfo:[NSString stringWithFormat:@"%@", self.userId]];
        self.userName = userInfo.displayName;
    }
    
    [self prepareUI];
    
    // Do any additional setup after loading the view.
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)printAction
{
    NSLog(@"print");
    NSNumber * type = @0;
    if (self.isImportantInformation) {
        type = @1;
    }else
    {
        type = @0;
    }
    [[Print sharePrint] printWithArr:self.printDataSourceArr taskType:type toUserId:self.userId];
    
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor = UIColorFromRGB(0x12B7F5);
    [self.view addSubview:backView];
    
    self.printTableView = [[UITableView alloc]initWithFrame:CGRectMake(25, 17, screenWidth - 50, screenHeight - 34) style:UITableViewStylePlain];
    self.printTableView.delegate = self;
    self.printTableView.dataSource = self;
    self.printTableView.backgroundColor = UIColorFromRGB(0x12B7F5);
    self.printTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.printTableView registerClass:[PrintPreviewCell class] forCellReuseIdentifier:ALCELLID];
    [self.view addSubview:self.printTableView];
    self.printTableView.tableHeaderView = [self prepareHeaderView];
    self.printTableView.tableFooterView = [self prepareFooterView];
}

- (UIView * )prepareHeaderView
{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.printTableView.hd_width, 143)];
    _headerView.backgroundColor = UIColorFromRGB(0x12B7F5);
    
    self.styleBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.styleBT.frame = CGRectMake(0, 0, 95, 35);
    self.styleBT.backgroundColor = [UIColor clearColor];
    [self.styleBT setImage:[[UIImage imageNamed:@"normalscrip"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.styleBT setImage:[[UIImage imageNamed:@"importantscrip"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.styleBT addTarget:self action:@selector(importantAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:self.styleBT];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.styleBT.frame) + 21, _headerView.hd_width, 87 + TOUSERHEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _bottomView.bounds;
    maskLayer.path = path.CGPath;
    _bottomView.layer.mask = maskLayer;
    [_headerView addSubview:_bottomView];
    
    self.importantImageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 13, 19, 19)];
    _importantImageView.image = [UIImage imageNamed:@"importantINformation"];
    [_bottomView addSubview:_importantImageView];
    
    self.importantLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 17, 150, 14)];
    _importantLabel.font = [UIFont systemFontOfSize:13];
    _importantLabel.backgroundColor = [UIColor whiteColor];
    _importantLabel.text = @"这是一条重要信息！";
    _importantLabel.textColor = UIColorFromRGB(0x323232);
    [_bottomView addSubview:_importantLabel];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString * printTime = [formatter stringFromDate:date];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 49, _bottomView.hd_width - 34, 13)];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.text = printTime;
    _timeLabel.textColor = UIColorFromRGB(0x323232);
    [_bottomView addSubview:_timeLabel];
    
    self.imaginariView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 71, _headerView.hd_width - 20, 2)];
    _imaginariView.image = [UIImage imageNamed:@"imaginaryline"];
    [_bottomView addSubview:_imaginariView];
    
    self.toUsernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 81, _bottomView.hd_width - 34, 13)];
    _toUsernameLabel.font = [UIFont systemFontOfSize:13];
    _toUsernameLabel.backgroundColor = [UIColor whiteColor];
    _toUsernameLabel.text = [NSString stringWithFormat:@"To:%@", self.userName];
    _toUsernameLabel.textColor = UIColorFromRGB(0x323232);
    [_bottomView addSubview:_toUsernameLabel];
    
    self.tousernameImaginariView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 103, _headerView.hd_width - 20, 2)];
    _tousernameImaginariView.image = [UIImage imageNamed:@"imaginaryline"];
    [_bottomView addSubview:_tousernameImaginariView];
    
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self calculateTableviewHeight];
}

- (void)calculateTableviewHeight
{
    if (self.styleBT.selected) {
        _headerView.hd_height = 143 + TOUSERHEIGHT;
        _bottomView.hd_height = 87+ TOUSERHEIGHT;
        
        _importantLabel.hidden = NO;
        _importantImageView.hidden = NO;
        
        _timeLabel.hd_y = 49;
        _imaginariView.hd_y = 71;
        
        _toUsernameLabel.hd_y = 81;
        _tousernameImaginariView.hd_y = 103;
    }else
    {
        _headerView.hd_height = 110+ TOUSERHEIGHT;
        _bottomView.hd_height = 54+ TOUSERHEIGHT;
        
        _importantLabel.hidden = YES;
        _importantImageView.hidden = YES;
        
        _timeLabel.hd_y = 17;
        _imaginariView.hd_y = 39;
        
        _toUsernameLabel.hd_y = 49;
        _tousernameImaginariView.hd_y = 71;
        
    }
    
    CGFloat totalHeight = 0.0;
    for (MaterialDataModel * model in self.printDataSourceArr) {
        totalHeight += model.height;
    }
    if (self.styleBT.selected) {
        if (totalHeight + 143 + 70 > screenHeight - 64 - 17 - 17) {
            self.printTableView.hd_height = screenHeight - 64 - 17 - 17;
        }else
        {
            self.printTableView.hd_height = totalHeight + 143 + 70;
        }
        
    }else
    {
        if (totalHeight + 110 + 70 > screenHeight - 64 - 17 - 17) {
            self.printTableView.hd_height = screenHeight - 64 - 17 - 17;
        }else
        {
            self.printTableView.hd_height = totalHeight + 110 + 70;
        }
    }
}

- (void)importantAction:(UIButton *)button
{
//    button.selected = !button.selected;
//    if (button.selected) {
//        self.isImportantInformation = YES;
//    }else
//    {
//        self.isImportantInformation = NO;
//    }
//    [self calculateTableviewHeight];
//    [self.printTableView reloadData];
}

- (UIView * )prepareFooterView
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.printTableView.hd_width, 70)];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = footerView.bounds;
    maskLayer.path = path.CGPath;
    footerView.layer.mask = maskLayer;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, footerView.hd_width - 20, 2)];
    imageView.image = [UIImage imageNamed:@"imaginaryline"];
    [footerView addSubview:imageView];
    
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((footerView.hd_width - 145) / 2, CGRectGetMaxY(imageView.frame) + 9, 145, 37)];
    logoImageView.image = [UIImage imageNamed:@"sendScrip-logo"];
    [footerView addSubview:logoImageView];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.printDataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrintPreviewCell * cell = [tableView dequeueReusableCellWithIdentifier:ALCELLID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MaterialDataModel * model = self.printDataSourceArr[indexPath.row];
    [cell creatSubView:model.dealImage.size.width];
    NSLog(@"model.fileName = %@", model.fileName);
    cell.photoImageView.image = model.dealImage;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialDataModel * model = self.printDataSourceArr[indexPath.row];
    return model.height + 6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
