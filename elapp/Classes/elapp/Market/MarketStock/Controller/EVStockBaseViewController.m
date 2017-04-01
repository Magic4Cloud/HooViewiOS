//
//  EVStockBaseViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVStockBaseViewController.h"
#import "EVStockTopView.h"
#import "EVLineView.h"
#import "EVStockBaseModel.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVStockBaseViewCell.h"
#import "EVTodayFloatModel.h"
#import "EVMarketDetailsController.h"


@interface EVStockBaseViewController ()<UITableViewDelegate,UITableViewDataSource,EVStockTopViewDelegate>

@property (nonatomic, weak) UITableView *stockTableView;

@property (nonatomic, weak) EVStockTopView *stockTopView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *floatArray;

@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, assign) BOOL refreshFinish;

@property (nonatomic) NSTimer *refreshTimes;


@end

@implementation EVStockBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUpTableView];
    [self loadStockData];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)addUpTableView
{
    EVStockTopView *stockTopView = [[EVStockTopView alloc] init];
    stockTopView.frame  = CGRectMake(0, 0, ScreenWidth, 108);
    stockTopView.delegate = self;
    
    UITableView *stockTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, EVContentHeight-10) style:(UITableViewStylePlain)];
    stockTableView.delegate = self;
    stockTableView.dataSource = self;
    [self.view addSubview:stockTableView];
    self.stockTableView = stockTableView;
    stockTableView.tableFooterView = [UIView new];
//    stockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    stockTableView.tableHeaderView = stockTopView;
    self.stockTopView = stockTopView;
    
    
    UIButton *refreshButton = [[UIButton alloc] init];
    refreshButton.frame = CGRectMake(ScreenWidth - 64, stockTableView.frame.size.height - 58, 44, 44);
    refreshButton.backgroundColor = [UIColor blackColor];
    refreshButton.layer.masksToBounds = YES;
    refreshButton.layer.cornerRadius = 22;
    refreshButton.alpha = 0.7;
    [refreshButton setImage:[UIImage imageNamed:@"hv_refresh_white"] forState:(UIControlStateNormal)];
    [self.view addSubview:refreshButton];
    [refreshButton addTarget:self action:@selector(refreshClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.refreshButton = refreshButton;
    [self.view bringSubviewToFront:refreshButton];
    
    [stockTableView addRefreshHeaderWithRefreshingBlock:^ {
        [self loadStockData];
        [self loadHeadTailData];
     }];
}

- (void)loadStockData
{
    [self.baseToolManager GETRequestHSuccess:^(NSDictionary *retinfo) {
        [self.stockTableView endHeaderRefreshing];
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        NSArray *stockArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"][self.marketType]];
        NSArray *getArray = [stockArray subarrayWithRange:NSMakeRange(0, 3)];
        [self.dataArray addObjectsFromArray:getArray];
        [self.stockTopView updateStockData:self.dataArray];
    } error:^(NSError *error) {
         [self.stockTableView endHeaderRefreshing];
        [EVProgressHUD showError:@"请求失败"];
    }];
    
    
}

- (void)loadHeadTailData
{
    
    self.refreshFinish = YES;
    WEAK(self)
    [self.baseToolManager GETRequestTodayFloatMarket:_marketType Success:^(NSDictionary *retinfo) {
         [self.stockTableView endHeaderRefreshing];
        if (self.floatArray.count > 0) {
            [weakself.floatArray removeAllObjects];
        }
         [EVProgressHUD hideHUDForView:self.view];
        NSDictionary *floatDict = retinfo[@"data"];
        NSArray *tailArray = floatDict[@"tail"];
        NSArray *headArray = floatDict[@"head"];
        NSArray  *headData =[EVTodayFloatModel objectWithDictionaryArray:headArray];
        NSArray  *tailData =[EVTodayFloatModel objectWithDictionaryArray:tailArray];
        [weakself.floatArray addObject:headData];
        [weakself.floatArray addObject:tailData];
        weakself.refreshFinish = NO;
        [weakself.stockTableView reloadData];
    } error:^(NSError *error) {
        [self.stockTableView endHeaderRefreshing];
        [EVProgressHUD hideHUDForView:self.view];
        [EVProgressHUD showError:@"大盘请求失败"];
        EVLog(@"dapan-------  %@",error);
        weakself.refreshFinish = NO;
    }];

}

- (void)refreshClick
{
    if (self.refreshFinish == NO) {
         [self loadHeadTailData];
    }
}
#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.floatArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.floatArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVStockBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell"];
    if (!cell) {
        cell =  [[EVStockBaseViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"baseCell"];
    }
    if (indexPath.section == 0) {
        cell.rankColor = [UIColor colorWithHexString:@"#AE3231"];
    }else {
        cell.rankColor = [UIColor colorWithHexString:@"#099468"];
    }
    
    if (indexPath.row > 2) {
        cell.rankLabel.hidden = YES;
    }else {
        cell.rankLabel.hidden = NO;
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.cellType = EVStockBaseViewCellTypeSock;
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
    cell.stockBaseModel = self.floatArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EVBaseCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    [EVLineView addTopLineToView:view];
//    [EVLineView addBottomLineToView:view];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(16, 10, ScreenWidth - 16, 22);
    [view addSubview:titleLabel];
    NSString *titleStr = section == 0 ? @"涨幅榜" : @"跌幅榜";
    titleLabel.text = [NSString stringWithFormat:@"%@",titleStr];
    titleLabel.textColor = [UIColor evTextColorH2];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [UIColor evBackgroundColor];
        if (section == 1) {
        view.hidden = YES;
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVStockBaseModel *stockBaseModel =   self.floatArray[indexPath.section][indexPath.row];
    EVMarketDetailsController *marketDetailVC = [[EVMarketDetailsController alloc] init];
    marketDetailVC.special = 1;
    marketDetailVC.stockBaseModel = stockBaseModel;
    [self.navigationController pushViewController:marketDetailVC animated:YES];
}

- (void)didSelectItemBaseModel:(EVStockBaseModel *)stockModel
{
    EVMarketDetailsController *marketDetailVC = [[EVMarketDetailsController alloc] init];
    marketDetailVC.special = 0;
    marketDetailVC.stockBaseModel = stockModel;
    [self.navigationController pushViewController:marketDetailVC animated:YES];
}
- (void)setMarketType:(NSString *)marketType
{
    _marketType = marketType;
    
}

- (void)setChooseIndex:(NSInteger)chooseIndex
{
    _chooseIndex = chooseIndex;
    switch (chooseIndex) {
            case 0:
        {
             [self refreshClick];
        }
            break;
            case 1:
        {
             [self refreshClick];
        }
            break;
            case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}
- (EVBaseToolManager *)baseToolManager
{
    if ( !_baseToolManager ) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)floatArray
{
    if (!_floatArray) {
        _floatArray = [NSMutableArray array];
    }
    
    return _floatArray;
}

- (void)dealloc
{
    [_refreshTimes invalidate];
    _refreshTimes = nil;
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
