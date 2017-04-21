//
//  EVShopVideoViewController.m
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVShopVideoViewController.h"
#import "EVShopVideoCell.h"

#import "EVVideoAndLiveModel.h"

#import "EVBaseToolManager+MyShopAPI.h"
@interface EVShopVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation EVShopVideoViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadNewData];
}


#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVShopVideoCell" bundle:nil] forCellReuseIdentifier:@"EVShopVideoCell"];
}
#pragma mark - 🌐Networks
- (void)loadNewData
{
   [self.baseToolManager  GETMyShopsWithType:@"1" fail:^(NSError * error) {
       
   } success:^(NSDictionary * retinfo) {
       NSArray * videos = retinfo[@"videolive"];
       if ([videos isKindOfClass:[NSArray class]] && videos.count >0) {
           [videos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               EVVideoAndLiveModel * model = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
               [self.dataArray addObject:model];
           }];
           [self.tableView reloadData];
       }
   } sessionExpire:^{
       
   }];
   
}

#pragma mark -👣 Target actions

#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"EVShopVideoCell";
    EVShopVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    EVVideoAndLiveModel * model = _dataArray[indexPath.row];
    cell.videoModel = model;
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
        _tableView.backgroundColor = [UIColor evBackGroundLightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 355-194+(ScreenWidth-30)/1.778;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
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
