//
//  EVSelfStockViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVSelfStockViewController.h"
#import "EVNullDataView.h"
#import "EVStockBaseViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVStockBaseModel.h"
#import "EVMarketDetailsController.h"
#import "EVLoginInfo.h"
#import "EVSearchStockViewController.h"
#import "EVEditSelfStockViewController.h"
#import "NSString+Extension.h"
#import "EVLoginViewController.h"


@interface EVSelfStockViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) EVNullDataView *nullDataView;

@property (nonatomic, strong) NSMutableArray *chooseArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak) UIButton *refreshButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *chooseMarketPath;
@end

@implementation EVSelfStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self addTableView];
    [self addNullView];
    [self loadData];

}

- (void)addNullView
{
    self.nullDataView = [[EVNullDataView alloc] init];
    self.nullDataView.frame = CGRectMake(0, 0, ScreenWidth, EVContentHeight-10);
    self.nullDataView.backgroundColor = [UIColor clearColor];
    self.nullDataView.title = @"您还没有添加自选噢";
    self.nullDataView.buttonTitle = @"添加自选";
    [self.nullDataView addButtonTarget:self action:@selector(nullAddClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.nullDataView.hidden = YES;
    [self.view addSubview:self.nullDataView];
    [self.nullDataView hide];
}

- (void)addTableView
{
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, ScreenHeight - 118) style:(UITableViewStylePlain)];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:listTableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    listTableView.tableFooterView = view;
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.listTableView = listTableView;
    
    
    //编辑
    UIButton *refreshButton = [[UIButton alloc] init];
    refreshButton.frame = CGRectMake(ScreenWidth - 64, listTableView.frame.size.height - 58, 44, 44);
    refreshButton.backgroundColor = [UIColor blackColor];
    refreshButton.layer.masksToBounds = YES;
    refreshButton.layer.cornerRadius = 22;
    refreshButton.alpha = 0.7;
    [refreshButton setImage:[UIImage imageNamed:@"btn_market_arrange_n"] forState:(UIControlStateNormal)];
    [self.view addSubview:refreshButton];
    [refreshButton addTarget:self action:@selector(refreshClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.refreshButton = refreshButton;
    [self.view bringSubviewToFront:refreshButton];
    
    [self.listTableView addRefreshHeaderWithRefreshingBlock:^{
        [self fetchDataWithType:EVSelfStockTypeAll];
    }];
    
    [EVNotificationCenter addObserver:self selector:@selector(loadData) name:@"chooseMarketCommit" object:nil];
    
}

- (void)loadData
{
    [self fetchDataWithType:EVSelfStockTypeAll];
}

- (void)rightClick
{

}

//跳转编辑页
- (void)refreshClick:(UIButton *)sender
{
//    if (self.Sdelegate && [self.Sdelegate respondsToSelector:@selector(refreshWithType:)]) {
//        [self.Sdelegate refreshWithType:EVSelfStockTypeAll];
//    }
    EVEditSelfStockViewController *mineVC = [[EVEditSelfStockViewController alloc] init];
    mineVC.commitBlock = ^(){
    };
    [self.navigationController pushViewController:mineVC animated:YES];

}


#pragma ---- delegate
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
    EVStockBaseViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"listCell"] ;
    if (!cell) {
        cell = [[EVStockBaseViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"listCell"];
    }
    cell.upStockBaseModel = self.dataArray[indexPath.row];
    cell.cellType = EVStockBaseViewCellTypeSelfSock;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row > 0) {
        cell.lineLabel.hidden = NO;
    }
    
    return cell;
}

- (void)nullAddClick:(UIButton *)btn
{
    if (![EVLoginInfo hasLogged]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }
    
    EVLog(@"添加自选");
    EVSearchStockViewController *searchStockVC = [[EVSearchStockViewController alloc] init];
    searchStockVC.addStockBlock = ^(NSString * sbom)
    {
        [EVNotificationCenter postNotificationName:@"chooseMarketCommit" object:nil];
    };
    [self.navigationController pushViewController:searchStockVC animated:YES];
    if (self.Sdelegate && [self.Sdelegate respondsToSelector:@selector(addStockClick)]) {
        [self.Sdelegate addStockClick];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EVBaseCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(24, 0, 48, 40);
    leftLabel.font = [UIFont textFontB2];
    leftLabel.textColor = [UIColor evTextColorH2];
    leftLabel.text = @"全部";
    [backView addSubview:leftLabel];
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.frame = CGRectMake((ScreenWidth - 100)/2, 0, 100, 40);
    centerLabel.font = [UIFont textFontB2];
    centerLabel.textColor = [UIColor evTextColorH2];
    centerLabel.text = @"现价";
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:centerLabel];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(ScreenWidth - 100, 0, 76, 40);
    [rightButton setTitle:@"涨跌幅" forState:(UIControlStateNormal)];
    [rightButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    rightButton.titleLabel.font = [UIFont textFontB2];
    [backView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 39, ScreenWidth, 1);
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [backView addSubview:lineLabel];
    
    return backView;
}

- (void)updateDataArray:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    NSArray *modelArray =  [EVStockBaseModel objectWithDictionaryArray:array];
    self.dataArray   = [NSMutableArray arrayWithArray:modelArray];
    [self.listTableView reloadData];
    
    
    
    if (self.dataArray.count == 0) {
        [self.nullDataView show];
        [self.view bringSubviewToFront:self.nullDataView];
    }
    else {
        [self.nullDataView hide];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVStockBaseModel *basemodel = self.dataArray[indexPath.row];
    EVMarketDetailsController *marketDetailVC = [[EVMarketDetailsController alloc] init];
    marketDetailVC.stockBaseModel = basemodel;
    if ([basemodel.symbol isEqualToString:@""] || basemodel.symbol == nil) {
        return;
    }
    [self.navigationController pushViewController:marketDetailVC animated:YES];
}
- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

-  (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSString *)storyFilePath
{
    if ( _chooseMarketPath == nil )
    {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *userMarksDirPath = [cachePath stringByAppendingPathComponent:@"chooseMarketPath"];
        NSString *currentPath = [NSString stringWithFormat:@"chooseMarketPath_%@",[EVLoginInfo localObject].name];
        if (![[NSFileManager defaultManager] fileExistsAtPath:userMarksDirPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:userMarksDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _chooseMarketPath = [userMarksDirPath stringByAppendingPathComponent:currentPath];
    }
    return _chooseMarketPath;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - networks
- (void)fetchDataWithType:(EVSelfStockType)type
{
    
    [self.baseToolManager GETRequestSelfStockList:[EVLoginInfo localObject].name Success:^(NSDictionary *retinfo) {
        [[self listTableView] endHeaderRefreshing];
        
        self.chooseArray = retinfo[@"data"];
        
        NSMutableArray *codeArray = [NSMutableArray array];
        for (NSDictionary *baseModel in self.chooseArray) {
            [codeArray addObject:baseModel[@"symbol"]];
        }
        
    
        NSArray *markets = [self _filterStockWithType:type localArray:codeArray];
        NSString *marketStr = [NSString stringWithArray:markets];
        EVLog(@"marketStr:%@",marketStr);
        if (codeArray.count == 0) {
            [self updateDataArray:@[]];
            return;
        }
        [self fetchStockDataWithString:marketStr type:type];
        
        //        [[self _selfStockViewControllerWithType:type] updateDataArray:self.chooseArray];
        
    } error:^(NSError *error) {
        
        [[self listTableView] endHeaderRefreshing];
        [self updateDataArray:@[]];
    }];
}

- (void)fetchStockDataWithString:(NSString *)stockString type:(EVSelfStockType)type
{

    [self.baseToolManager GETRealtimeQuotes:stockString success:^(NSDictionary *retinfo) {
     
        [[self listTableView] endHeaderRefreshing];
       
        NSArray *dataArray = retinfo[@"data"];
        [self updateDataArray:dataArray];
    } error:^(NSError *error) {
        [[self  listTableView] endHeaderRefreshing];
    }];
}


- (NSArray *)_filterStockWithType:(EVSelfStockType)type localArray:(NSArray *)localArray {
    switch (type) {
        case EVSelfStockTypeAll: {
            return localArray;
            break;
        }
        
        case EVSelfStockTypeIXIX: {
            break;
        }
        default:
            break;
    }
    
    return @[];
}





- (NSMutableArray *)chooseArray
{
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
    }
    return _chooseArray;
}





@end
