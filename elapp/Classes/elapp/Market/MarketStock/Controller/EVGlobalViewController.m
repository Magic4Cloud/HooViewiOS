//
//  EVGlobalViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVGlobalViewController.h"
#import "EVGlobalView.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVStockBaseModel.h"
#import "EVEditGlobalViewController.h"
#import "EVLoginInfo.h"
#import "EVLoginViewController.h"
#import "EVStockBaseViewCell.h"
#import "EVMarketDetailsController.h"


@interface EVGlobalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *stockTableView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *floatArray;

@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, assign) BOOL refreshFinish;

@property (nonatomic) NSTimer *refreshTimes;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;




@end

@implementation EVGlobalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUpTableView];
    [self loadHeadTailData];
    
    
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
    UITableView *stockTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, ScreenWidth, ScreenHeight - 117) style:(UITableViewStylePlain)];
    stockTableView.delegate = self;
    stockTableView.dataSource = self;
    stockTableView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:stockTableView];
    self.stockTableView = stockTableView;
    stockTableView.tableFooterView = [UIView new];
    stockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
        [self loadHeadTailData];
    }];
    
}


- (void)loadHeadTailData
{
    self.refreshFinish = YES;
    WEAK(self)
    [self.baseToolManager GETRequestTodayFloatMarket:@"cn" Success:^(NSDictionary *retinfo) {
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
        [EVProgressHUD showError:@"请求失败"];
        EVLog(@"dapan-------  %@",error);
        weakself.refreshFinish = NO;
    }];
    
//    [self.baseToolManager GETRequestGlobalSuccess:^(NSDictionary *retinfo) {
//        NSLog(@"全球 = %@",retinfo);
//
//    } error:^(NSError *error) {
//        
//    }];

    
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
    
    if (indexPath.row < 10 && indexPath.row > 0) {
        cell.lineLabel.hidden = NO;
    } else {
        cell.lineLabel.hidden = YES;
    }
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.cellType = EVStockBaseViewCellTypeGlobalSock;
    cell.globalBaseModel = self.floatArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EVBaseCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    //    [EVLineView addTopLineToView:view];
    //    [EVLineView addBottomLineToView:view];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(22, 5, ScreenWidth - 16, 20);
    [view addSubview:titleLabel];
    NSString *titleStr = @"";
//    if ([_marketType isEqualToString:@"cn"]) {
//        titleStr = section == 0 ? @"涨幅榜" : @"跌幅榜";
//    } else if([_marketType isEqualToString:@"hk"]) {
//        titleStr = section == 0 ? @"领涨股" : @"领跌股";
//    }
    titleLabel.text = [NSString stringWithFormat:@"%@",titleStr];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor evTextColorH2];
    
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 2, 14)];
    if (section == 0) {
        signLabel.backgroundColor = [UIColor colorWithHexString:@"#AE3231"];
        self.headView = view;
    }else {
        signLabel.backgroundColor = [UIColor colorWithHexString:@"#099468"];
        self.footView = view;
    }
    [view addSubview:signLabel];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
    view.backgroundColor = [UIColor evBackgroundColor];
    if (section == 2) {
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
//    _marketType = marketType;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.headView.frame.origin.y > 86) {
        self.headView.backgroundColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1];
    } else {
        self.headView.backgroundColor = [UIColor whiteColor];
    }
    if (self.footView.frame.origin.y > 766) {
        self.footView.backgroundColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1];
    } else {
        self.footView.backgroundColor = [UIColor whiteColor];
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







#pragma MARK - delegate
//- (void)editButtonWithSelectedStocks:(NSArray *)stocks
//{
//    EVLog(@"编辑");
//    
//    if ([EVLoginInfo localObject].sessionid == nil || [[EVLoginInfo localObject].sessionid isEqualToString:@""]) {
//        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
//        [self presentViewController:navighaVC animated:YES completion:nil];
//    }else {
//        EVEditGlobalViewController *editVC= [[EVEditGlobalViewController alloc] init];
//        editVC.selectedStocks = stocks;
//        editVC.popBlock = ^(){
//            [self.globalView loadData];
//        };
//        [self.navigationController pushViewController:editVC animated:YES];
//    }
//}
//
//- (void)refreshButton
//{
//    EVLog(@"刷新");
////    [self loadData];
//    
//}




@end
