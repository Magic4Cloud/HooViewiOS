//
//  EVShopVideoViewController.m
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVShopVideoViewController.h"
#import "EVHVWatchViewController.h"
#import "EVShopVideoCell.h"

#import "EVVideoAndLiveModel.h"
#import "EVWatchVideoInfo.h"

#import "EVBaseToolManager+MyShopAPI.h"

#import "EVNullDataView.h"
@interface EVShopVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int start;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) EVNullDataView * nullDataView;
@end

@implementation EVShopVideoViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self.tableView startHeaderRefreshing];
}


#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVShopVideoCell" bundle:nil] forCellReuseIdentifier:@"EVShopVideoCell"];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addRefreshFooterWithiTarget:self action:@selector(loadMoreData)];
    [self.tableView hideFooter];
}
#pragma mark - 🌐Networks
- (void)loadNewData
{
    start = 0;
    [self.baseToolManager  GETMyShopsWithType:@"1" start:@"0" count:@"20" fail:^(NSError * error) {
        [self.tableView endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    } success:^(NSDictionary * retinfo) {
        [self.tableView endHeaderRefreshing];
        NSArray * videos = retinfo[@"videolive"];
        [self.dataArray removeAllObjects];
        if ([videos isKindOfClass:[NSArray class]] && videos.count >0) {
            
            [videos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * model = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            if (videos.count<20)
            {
                [self.tableView hideFooter];
            }
            else
            {
                [self.tableView showFooter];
            }
            start += 20;
        }
        else
        {
            [self.tableView hideFooter];
        }
        [self.tableView reloadData];
        self.nullDataView.hidden = self.dataArray.count == 0? NO:YES;
    } sessionExpire:^{
        [self.tableView endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    }];
    
}

- (void)loadMoreData
{
    [self.baseToolManager  GETMyShopsWithType:@"1" start:[NSString stringWithFormat:@"%d",start] count:@"20" fail:^(NSError * error) {
        [self.tableView endFooterRefreshing];
    } success:^(NSDictionary * retinfo) {
        [self.tableView endFooterRefreshing];
        NSArray * videos = retinfo[@"videolive"];
        if ([videos isKindOfClass:[NSArray class]] && videos.count >0) {
            
            [videos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * model = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            if (videos.count<20)
            {
                [self.tableView setFooterState:CCRefreshStateNoMoreData];
            }
            else
            {
                [self.tableView setFooterState:CCRefreshStateIdle];
            }
            start += 20;
        }
        else
        {
            [self.tableView setFooterState:CCRefreshStateNoMoreData];
        }
        [self.tableView reloadData];
    } sessionExpire:^{
        [self.tableView endFooterRefreshing];
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
    EVVideoAndLiveModel * model = _dataArray[indexPath.row];
    EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
    watchViewVC.videoAndLiveModel = model;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
    [self presentViewController:nav animated:YES completion:nil];
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
        [_tableView addSubview:self.nullDataView];
        self.nullDataView.hidden = YES;
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

- (EVNullDataView *)nullDataView
{
    if (!_nullDataView) {
        _nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 50)];
        _nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
        _nullDataView.title = @"暂无购买的精品视频";
    }
    return _nullDataView;
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
