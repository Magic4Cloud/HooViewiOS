//
//  EVSelectMarketViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVSelectMarketViewController.h"
#import "EVNullDataView.h"
#import "EVSelfStockViewController.h"
#import "SGSegmentedControl.h"
#import <PureLayout.h>
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVNotOpenView.h"
#import "EVLoginInfo.h"
#import "NSString+Extension.h"

@interface EVSelectMarketViewController ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate,EVSelfStockVCDelegate>
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, strong) EVSelfStockViewController *allStockVC;

@property (nonatomic, strong)  EVSelfStockViewController *SHStockVC;

@property (nonatomic, strong) EVSelfStockViewController *HKStockVC;

@property (nonatomic, strong) EVSelfStockViewController *USStockVC;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, copy) NSString *chooseMarketPath;

@property (nonatomic, strong) NSMutableArray *chooseArray;

@property (nonatomic, assign) EVSelfStockType currentSelectedType;


@end

@implementation EVSelectMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpPageView];
    [self fetchDataWithType:EVSelfStockTypeAll];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshAll];
}

- (void)setUpPageView
{
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, ScreenWidth, EVContentHeight)];
    backScrollView.backgroundColor = [UIColor evBackgroundColor];
    backScrollView.delegate = self;
    [self.view addSubview:backScrollView];
    self.backScrollView = backScrollView;
    backScrollView.pagingEnabled = YES;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.contentSize = CGSizeMake(ScreenWidth * 4, EVContentHeight);
    
    //全部
    EVSelfStockViewController *allStockVC = [[EVSelfStockViewController alloc] init];
    [self addChildViewController:allStockVC];
    allStockVC.view.frame = CGRectMake(0, 10, ScreenWidth, EVContentHeight -10);
    [backScrollView addSubview:allStockVC.view];
    self.allStockVC = allStockVC;
    self.allStockVC.stockType = EVSelfStockTypeAll;
    
    //沪深
    EVSelfStockViewController *SHStockVC = [[EVSelfStockViewController alloc] init];
    [self addChildViewController:SHStockVC];
    SHStockVC.view.frame = CGRectMake(ScreenWidth , 10, ScreenWidth, EVContentHeight -10);
    [backScrollView addSubview:SHStockVC.view];
    self.SHStockVC = SHStockVC;
    self.SHStockVC.stockType = EVSelfStockTypeSZSH;
    
    //港股
    EVSelfStockViewController *HKStockVC = [[EVSelfStockViewController alloc] init];
    [self addChildViewController:HKStockVC];
    HKStockVC.view.frame = CGRectMake(ScreenWidth * 2, 10, ScreenWidth, EVContentHeight -10);
    [backScrollView addSubview:HKStockVC.view];
    self.HKStockVC = HKStockVC;
    self.HKStockVC.stockType = EVSelfStockTypeHK;
    
    //美股
    EVSelfStockViewController *USStockVC = [[EVSelfStockViewController alloc] init];
    [self addChildViewController:USStockVC];
    USStockVC.view.frame = CGRectMake(ScreenWidth * 3, 10, ScreenWidth, EVContentHeight -10);
    [backScrollView addSubview:USStockVC.view];
    self.USStockVC = USStockVC;
    self.USStockVC.stockType = EVSelfStockTypeUS;
    
    // 四个控制器的配置
    self.allStockVC.Sdelegate = self;
    self.SHStockVC.Sdelegate = self;
    self.HKStockVC.Sdelegate = self;
    self.USStockVC.Sdelegate = self;
    [self.allStockVC.listTableView addRefreshHeaderWithRefreshingBlock:^{
        [self fetchDataWithType:EVSelfStockTypeAll];
    }];
    [self.SHStockVC.listTableView addRefreshHeaderWithRefreshingBlock:^{
        [self fetchDataWithType:EVSelfStockTypeSZSH];
    }];
    [self.HKStockVC.listTableView addRefreshHeaderWithRefreshingBlock:^{
        [self fetchDataWithType:EVSelfStockTypeHK];
    }];
    [self.USStockVC.listTableView addRefreshHeaderWithRefreshingBlock:^{
        [self fetchDataWithType:EVSelfStockTypeUS];
    }];
    
    NSArray *titleArray = @[@"全部",@"沪深",@"港股",@"美股"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 64, ScreenWidth, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor whiteColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor evMainColor];
        *indicatorColor = [UIColor evMainColor];
    }];
    self.topSView.selectedIndex = 0;
    [self.view addSubview:_topSView];
    

    [EVNotificationCenter addObserver:self selector:@selector(refreshAll) name:@"chooseMarketCommit" object:nil];
}

#pragma mark - networks
- (void)fetchDataWithType:(EVSelfStockType)type {
    self.chooseArray = [NSMutableArray arrayWithContentsOfFile:[self storyFilePath]];
    if (self.chooseArray.count <= 0) {
        [self.baseToolManager GETUserCollectListType:EVCollectTypeStock start:^{
            
        } fail:^(NSError *error) {
            [[[self _selfStockViewControllerWithType:type] listTableView] endHeaderRefreshing];
            [EVProgressHUD showMessage:@"加载错误"];
        } success:^(NSDictionary *retinfo) {
            [[[self _selfStockViewControllerWithType:type] listTableView] endHeaderRefreshing];
            NSString *list = retinfo[@"collectlist"];
            if (list.length > 0) {
                NSArray *marketA = [list componentsSeparatedByString:@","];
                [self.chooseArray addObjectsFromArray:marketA];
                [self.chooseArray writeToFile:[self storyFilePath] atomically:YES];
                [self fetchStockDataWithString:retinfo[@"collectlist"] type:type];
            }else {
                [[self _selfStockViewControllerWithType:type] updateDataArray:@[]];
            }
        } sessionExpire:^{
            [[[self _selfStockViewControllerWithType:type] listTableView] endHeaderRefreshing];
            [EVProgressHUD showError:@"没有登录"];
        }];
    }else {
        NSArray *markets = [self _filterStockWithType:type localArray:self.chooseArray];
        NSString *marketStr = [NSString stringWithArray:markets];
        if (markets.count == 0) {
            [[self _selfStockViewControllerWithType:type] updateDataArray:@[]];
            return;
        }
        [self fetchStockDataWithString:marketStr type:type];
    }
}

- (void)fetchStockDataWithString:(NSString *)stockString type:(EVSelfStockType)type {
    [self.baseToolManager GETRealtimeQuotes:stockString success:^(NSDictionary *retinfo) {
        [[[self _selfStockViewControllerWithType:type] listTableView] endHeaderRefreshing];
//        [EVProgressHUD showSuccess:@"加载成功"];
        NSArray *dataArray = retinfo[@"data"];
        [[self _selfStockViewControllerWithType:type] updateDataArray:dataArray];
    } error:^(NSError *error) {
        [[[self _selfStockViewControllerWithType:type] listTableView] endHeaderRefreshing];
//        [EVProgressHUD showMessage:@"加载错误"];
    }];
}

#pragma mark - private methods
- (EVSelfStockViewController *)_selfStockViewControllerWithType:(EVSelfStockType)type {
    EVSelfStockViewController *stockVC;
    switch (type) {
        case EVSelfStockTypeAll: {
            stockVC = self.allStockVC;
            break;
        }
        case EVSelfStockTypeSZSH: {
            stockVC = self.SHStockVC;
            break;
        }
        case EVSelfStockTypeHK: {
            stockVC = self.HKStockVC;
            break;
        }
        case EVSelfStockTypeUS: {
            stockVC = self.USStockVC;
            break;
        }
        case EVSelfStockTypeIXIX: {
            break;
        }
        default:
            break;
    }
    return stockVC;
}

- (NSArray *)_filterStockWithType:(EVSelfStockType)type localArray:(NSArray *)localArray {
    switch (type) {
        case EVSelfStockTypeAll: {
            return localArray;
            break;
        }
        case EVSelfStockTypeSZSH: {
            NSMutableArray *tempArray = @[].mutableCopy;
            NSArray *SZArray = [self _stocksWithString:@"SZ" localArray:localArray];
            NSArray *SHArray = [self _stocksWithString:@"SH" localArray:localArray];
            [tempArray addObjectsFromArray:SZArray];
            [tempArray addObjectsFromArray:SHArray];
            return tempArray.copy;
            break;
        }
        case EVSelfStockTypeHK: {
            return [self _stocksWithString:@"HK" localArray:localArray];
            break;
        }
        case EVSelfStockTypeUS: {
            
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

- (NSArray *)_stocksWithString:(NSString *)string localArray:(NSArray *)localArray {
    NSMutableArray *tempArray = @[].mutableCopy;
    [localArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:string]) {
            [tempArray addObject:obj];
        }
    }];
    
    return tempArray.copy;
}

- (EVSelfStockType)_typeWithIndex:(NSInteger)index {
    EVSelfStockType type;
    if (index == 0) {
        type = EVSelfStockTypeAll;
    }
    else if (index == 1) {
        type = EVSelfStockTypeSZSH;
    }
    else if (index == 2) {
        type = EVSelfStockTypeHK;
    }
    else if (index == 3) {
        type = EVSelfStockTypeUS;
    }
    return type;
}

#pragma mark - notification
- (void)refreshAll
{
    [self fetchDataWithType:EVSelfStockTypeAll];
    [self fetchDataWithType:EVSelfStockTypeSZSH];
    [self fetchDataWithType:EVSelfStockTypeHK];
    [self fetchDataWithType:EVSelfStockTypeUS];
}


#pragma mark - EVSelfStockVCDelegate
- (void)refreshWithType:(EVSelfStockType)type
{
    [self fetchDataWithType:type];
}

- (void)addStockClick {
    
}

#pragma mark -delegate

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    NSLog(@"index - - %ld", (long)index);
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    [self fetchDataWithType:[self _typeWithIndex:index]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 2.把对应的标题选中
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self fetchDataWithType:[self _typeWithIndex:index]];
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;

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


- (NSMutableArray *)chooseArray
{
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
    }
    return _chooseArray;
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
