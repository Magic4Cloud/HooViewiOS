//
//  EVShopCheatsViewController.m
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVShopCheatsViewController.h"
#import "EVShopCheatsCell.h"

#import "EVBaseToolManager+MyShopAPI.h"

#import "EVCheatsModel.h"

#import "EVNullDataView.h"
@interface EVShopCheatsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger start;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) EVNullDataView * nullDataView;
@end

@implementation EVShopCheatsViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    self.nullDataView.hidden = NO;

//    [self.tableView startHeaderRefreshing];
}


#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVShopCheatsCell" bundle:nil] forCellReuseIdentifier:@"EVShopCheatsCell"];
    
//    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadNewData)];
//    [self.tableView addRefreshFooterWithiTarget:self action:@selector(loadMoreData)];
    
    [self.tableView hideFooter];
}
#pragma mark - 🌐Networks


- (void)loadNewData
{
    start = 0;
    [self.baseToolManager  GETMyShopsWithType:@"2" start:@"0" count:@"20" fail:^(NSError * error) {
        [self.tableView endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    } success:^(NSDictionary * retinfo) {
        [self.tableView endHeaderRefreshing];
        if (![retinfo isKindOfClass:[NSDictionary class]]) {
            self.nullDataView.hidden = NO;
                        return ;
        }
        NSArray * cheats = retinfo[@"cheats"];
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
        self.nullDataView.hidden = self.dataArray.count == 0? NO:YES;
    } sessionExpire:^{
        [self.tableView endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    }];
    
}

- (void)loadMoreData
{
    [self.baseToolManager  GETMyShopsWithType:@"2" start:[NSString stringWithFormat:@"%d",start] count:@"20" fail:^(NSError * error) {
        [self.tableView endFooterRefreshing];
    } success:^(NSDictionary * retinfo) {
        [self.tableView endFooterRefreshing];
        NSArray * cheats = retinfo[@"cheats"];
        
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
//        _nullDataView.title = @"暂无购买的秘籍";
        _nullDataView.title = @"您还没有购买过秘籍噢";
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
