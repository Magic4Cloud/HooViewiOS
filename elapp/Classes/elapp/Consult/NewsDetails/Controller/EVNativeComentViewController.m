//
//  EVNativeComentsViewController.m
//  elapp
//
//  Created by 唐超 on 5/10/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNativeComentViewController.h"

@interface EVNativeComentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIButton *orderByhotButton;
@property (weak, nonatomic) IBOutlet UIButton *orderByDateButton;

@end

@implementation EVNativeComentViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - 🌐Networks

#pragma mark -👣 Target actions
- (IBAction)orderButtonClick:(UIButton *)sender {
}

#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, ScreenWidth, ScreenHeight-64-44) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

@end
