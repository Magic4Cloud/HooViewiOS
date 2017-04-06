//
//  EVSpeciaColumnViewController.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVSpeciaColumnViewController.h"

@interface EVSpeciaColumnViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation EVSpeciaColumnViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    
    
}

#pragma mark - 🌐 Networks

#pragma mark - 👣 Target actions

#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = @"专栏";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 100;
        _tableView.backgroundColor = [UIColor evLineColor];
        _tableView.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
    }
    return _tableView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
