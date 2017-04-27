//
//  EVMyReleaseCheatsViewController.m
//  elapp
//
//  Created by 周恒 on 2017/4/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMyReleaseCheatsViewController.h"
#import "EVShopCheatsCell.h"

#import "EVBaseToolManager+MyShopAPI.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#import "EVCheatsModel.h"
#import "EVNullDataView.h"


@interface EVMyReleaseCheatsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger start;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) EVNullDataView *nullDataView;
@end

@implementation EVMyReleaseCheatsViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
//    [self.tableView startHeaderRefreshing];
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVShopCheatsCell" bundle:nil] forCellReuseIdentifier:@"EVShopCheatsCell"];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addRefreshFooterWithiTarget:self action:@selector(loadMoreData)];
    
    [self.tableView hideFooter];
    
    [self.view addSubview:self.nullDataView];
}

#pragma mark - 🌐Networks
- (void)loadNewData
{
    start = 0;
    
    [self.baseToolManager GETMyReleaseListWithUserid:self.watchVideoInfo.name type:@"1" start:start count:20 startBlock:^{
        
    } fail:^(NSError *error) {
        [self.tableView endHeaderRefreshing];
    } success:^(NSDictionary *videos) {
        [self.tableView endHeaderRefreshing];
        if (![videos isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSArray * cheats = videos[@"cheats"];
        [self.dataArray removeAllObjects];
        if ([cheats isKindOfClass:[NSArray class]] && cheats.count >0) {
            
            [cheats enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVCheatsModel * model = [EVCheatsModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            if (cheats.count<20)
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
        
    } essionExpire:^{
        [self.tableView endHeaderRefreshing];

    }];

}

- (void)loadMoreData
{
    [self.baseToolManager GETMyReleaseListWithUserid:self.watchVideoInfo.name type:@"1" start:start count:20 startBlock:^{
        
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
        [self.tableView endHeaderRefreshing];
    } success:^(NSDictionary *videos) {
        [self.tableView endFooterRefreshing];
        NSArray * cheats = videos[@"cheats"];
        [self.dataArray removeAllObjects];
        if ([cheats isKindOfClass:[NSArray class]] && cheats.count >0) {
            
            [cheats enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVCheatsModel * model = [EVCheatsModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            if (cheats.count<20)
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
        
    } essionExpire:^{
        [self.tableView endHeaderRefreshing];
        
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
    static NSString * identifer = @"EVShopCheatsCell";
    EVShopCheatsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    EVCheatsModel * model = _dataArray[indexPath.row];
    cell.cheatsModel = model;
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor evBackGroundLightGrayColor];
        if (ScreenWidth == 320) {
            _tableView.rowHeight = 120;
        }
        else
        {
            _tableView.rowHeight = 140;
        }
        
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

- (EVNullDataView *)nullDataView
{
    if (!_nullDataView) {
        _nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-108)];
        _nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
        _nullDataView.title = @"秘籍暂未开通";
    }
    return _nullDataView;
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

@end
