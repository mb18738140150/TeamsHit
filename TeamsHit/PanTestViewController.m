//
//  PanTestViewController.m
//  TeamsHit
//
//  Created by 仙林 on 17/3/14.
//  Copyright © 2017年 仙林. All rights reserved.
//

#import "PanTestViewController.h"
#import "PanTestTableViewCell.h"
#define PANCELLID @"pancellID"

@interface PanTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableview;

@end

@implementation PanTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.tableview registerNib:[UINib nibWithNibName:@"PanTestTableViewCell" bundle:nil] forCellReuseIdentifier:PANCELLID];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PanTestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:PANCELLID forIndexPath:indexPath];
    cell.myLabel.text = [NSString stringWithFormat:@"pantext %d", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
