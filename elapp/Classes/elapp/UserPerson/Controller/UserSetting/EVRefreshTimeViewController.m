//
//  EVRefreshTimeViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/27.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVRefreshTimeViewController.h"
#import "EVRefreshTimeViewCell.h"

@interface EVRefreshTimeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *timeTableView;

@property (nonatomic, strong) NSMutableArray *allCellArray;

@end

@implementation EVRefreshTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self addTableView];
    
    
}
- (void)addTableView
{
    NSArray *firstArray = @[@"不刷新",@"5秒",@"15秒",@"30秒"];
    NSArray *secondArray = @[@"不刷新",@"5秒"];
    [self.allCellArray addObject:firstArray];
    [self.allCellArray addObject:secondArray];
    
    
    
    UITableView *timeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStyleGrouped)];
    timeTableView.delegate = self;
    timeTableView.dataSource = self;
    [self.view addSubview:timeTableView];
    self.timeTableView = timeTableView;
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allCellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *cellArray = self.allCellArray[section];
    return cellArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVRefreshTimeViewCell *Cell = [[EVRefreshTimeViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"timeCell"];
    if (!Cell) {
        Cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
    }
    Cell.timeLabel.text = self.allCellArray[indexPath.section][indexPath.row];
    
    return Cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *nameArr = @[@"2G/3G/4G环境",@"Wi-Fi环境"];
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(10, 10, 20, 20);
    leftLabel.font = [UIFont systemFontOfSize:15.f];
    leftLabel.text = [NSString stringWithFormat:@"  %@",nameArr[section]];
    leftLabel.textColor = [UIColor evTextColorH2];
    return leftLabel;
}

- (NSMutableArray *)allCellArray
{
    if (!_allCellArray) {
        _allCellArray = [NSMutableArray array];
    }
    
    return _allCellArray;
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
