//
//  EVSearchStockViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVSearchStockViewController.h"
#import "EVSearchView.h"
#import "SGSegmentedControl.h"
#import "EVSearchStockViewCell.h"
#import "EVStockBaseModel.h"
#import "EVBaseToolManager+EVSearchAPI.h"
#import "EVNullDataView.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"

@interface EVSearchStockViewController ()<CCSearchViewDelegate,UIScrollViewDelegate,SGSegmentedControlStaticDelegate,UITableViewDelegate,UITableViewDataSource,EVSearchStockDelegate>

@property (nonatomic, weak) EVSearchView *searchView;

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) UIScrollView *searchScrollView;

@property (nonatomic, weak) UITableView *allTableView;

@property (nonatomic, weak) UITableView *shTableView;

@property (nonatomic, weak) UITableView *hkTableView;

@property (nonatomic, weak) UITableView *usTableView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, copy) NSString *lastSearchText;

@property (nonatomic, weak) EVNullDataView *stockNoDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger startCount;

@end

@implementation EVSearchStockViewController

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideLeftNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchView];
    [self addTableView];
    // Do any additional setup after loading the view.
    
}


- (void)addSearchView
{
    CGFloat height = 31.0f;
    // 搜索视图
    EVSearchView *searchView = [[EVSearchView alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth , height)];
    searchView.placeHolder = @"请输入股票代码/简称";
    searchView.placeHolderColor = [UIColor evTextColorH2];
    searchView.searchDelegate = self;
    self.searchView = searchView;
    
    self.navigationItem.titleView = searchView;
    [searchView begineEditting];
    
    [searchView layoutIfNeeded];
}

- (void)addTableView
{
    NSArray *titleArray = @[@"全部"];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, 44)];
    topBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBackView];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 1, ScreenWidth, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
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
    
    UIScrollView *searchScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:searchScrollView];
    self.searchScrollView = searchScrollView;
    self.searchScrollView.showsHorizontalScrollIndicator = NO;
    searchScrollView.backgroundColor = [UIColor clearColor];
    searchScrollView.frame = CGRectMake(0, 54, ScreenWidth, ScreenHeight - 118);
    searchScrollView.contentSize = CGSizeMake(ScreenWidth , ScreenHeight - 118);
    searchScrollView.delegate = self;
    searchScrollView.pagingEnabled = YES;
    
    UITableView *allTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    allTableView.dataSource = self;
    allTableView.delegate = self;
    [searchScrollView addSubview:allTableView];
    self.allTableView = allTableView;
    self.allTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 设置展示列表的约束
    self.allTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 118);
    
//    UITableView *shTableView = [[UITableView alloc] initWithFrame:CGRectZero];
//    shTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    shTableView.dataSource = self;
//    shTableView.delegate = self;
//    [searchScrollView addSubview:shTableView];
//    self.shTableView = shTableView;
//    self.shTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    // 设置展示列表的约束
//    self.shTableView.frame = CGRectMake(ScreenWidth , 0, ScreenWidth, ScreenHeight - 118);
//    
//    
//    UITableView *hkTableView = [[UITableView alloc] initWithFrame:CGRectZero];
//    hkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    hkTableView.dataSource = self;
//    hkTableView.delegate = self;
//    [searchScrollView addSubview:hkTableView];
//    self.hkTableView = hkTableView;
//    self.hkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    // 设置展示列表的约束
//    self.hkTableView.frame = CGRectMake(ScreenWidth * 2 , 0, ScreenWidth, ScreenHeight - 118);
//    
//    
//    UITableView *usTableView = [[UITableView alloc] initWithFrame:CGRectZero];
//    usTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    usTableView.dataSource = self;
//    usTableView.delegate = self;
//    [searchScrollView addSubview:usTableView];
//    self.usTableView = usTableView;
//    self.usTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    // 设置展示列表的约束
//    self.usTableView.frame = CGRectMake(ScreenWidth * 3, 0, ScreenWidth, ScreenHeight - 118);
    
    
    
    EVNullDataView *stockNoDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 54, ScreenWidth, ScreenHeight-115)];
    [self.view addSubview:stockNoDataView];
    stockNoDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    stockNoDataView.title = @"搜索您想了解的股票资讯";
    self.stockNoDataView = stockNoDataView;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rigistKeyBoard)];
    [stockNoDataView addGestureRecognizer:tapGR];
    
    WEAK(self)
    [self.allTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself GETSearchInfoWithType:2 text:weakself.lastSearchText start:weakself.startCount];
    }];
    
}


- (void)rigistKeyBoard
{
    [self.searchView endEditting];
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    
    [self.searchView endEditting];
    CGFloat offsetX = index * self.view.frame.size.width;
    self.searchScrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.searchScrollView) {
          [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
    }
    
}

#pragma mark - searchViewDelegate
- (void)searchView:(nonnull EVSearchView *)searchView didBeginSearchWithText:(nullable NSString *)searchText
{
    [searchView endEditting];
    // 处理网络请求
    EVLog(@"---search text:%@", searchText);
    self.lastSearchText = searchText;
    
    [self GETSearchInfoWithType:2 text:searchText start:0];
    
}

- (void)GETSearchInfoWithType:(NSUInteger)type text:(NSString *)text start:(NSInteger)start {

    __weak typeof(self) weakself = self;
    if (text.length <= 0) {
        [EVProgressHUD showMessage:@"请输入搜索内容"];
        return;
    }
    [self.baseToolManager getSearchInfosWith:text type:type start:start count:kCountNum startBlock:^{
        
    } fail:^(NSError *error) {
//        weakself.loadingView.failTitle = kNot_newwork_wrap;
//        [weakself.loadingView showFailedViewWithClickBlock:^{
//            [weakself searchView:weakself.searchView didBeginSearchWithText:weakself.lastSearchText];
//        }];
        weakself.stockNoDataView.hidden = NO;
    } success:^(NSDictionary *dict) {
        EVLog(@"dict:%@ -------------- type %ld", dict,type);
        weakself.stockNoDataView.hidden = YES;
        NSArray *stockArray =  [EVStockBaseModel objectWithDictionaryArray:dict[@"data"]];
        
        if (start == 0) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:stockArray];
        weakself.startCount = self.dataArray.count;
        [self.allTableView setFooterState:(stockArray.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
        [self.allTableView reloadData];
//        [weakself.loadingView destroy];
//        EVSearchResultModel *model = [EVSearchResultModel objectWithDictionary:dict];
//        
//        switch (type) {
//            case 0: {
//                [weakself.searchResult.news removeAllObjects];
//                [weakself.searchResult.news addObjectsFromArray:model.news];
//                self.newsLoaded = YES;
//                break;
//            }
//            case 1: {
//                [weakself.searchResult.videos removeAllObjects];
//                [weakself.searchResult.videos addObjectsFromArray:model.videos];
//                self.liveLoaded = YES;
//                break;
//            }
//            case 2: {
//                [weakself.searchResult.stock removeAllObjects];
//                [weakself.searchResult.stock addObjectsFromArray:model.stock];
//                self.stockLoaded = YES;
//                break;
//            }
//                
//            default:
//                break;
//        }
//        [weakself handleNoDataViewStatusWithNoticeSearch:NO];
//        [tableArray[type] reloadData];
        
    } sessionExpire:^{
        EVRelogin(weakself);
    } reterrBlock:^(NSString *reterr) {
//        [weakself handleNoDataViewStatusWithNoticeSearch:NO];
//        [weakself.loadingView destroy];
        
    }];
}

- (void)cancelSearch
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchView:(nonnull EVSearchView *)searchView didBeginEditing:(nonnull UITextField *)textField
{
    
    
}

#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVSearchStockViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!searchCell) {
        searchCell = [[EVSearchStockViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"searchCell"];
    }
    searchCell.stockBaseModel = self.dataArray[indexPath.row];
    searchCell.delegate = self;
    searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return searchCell;
}

- (void)buttonClickCell:(EVSearchStockViewCell *)cell
{
    [cell changeButtonStatus];
    WEAK(self);
    [self.baseToolManager GETUserCollectType:EVCollectTypeStock code:cell.stockBaseModel.symbol action:1 start:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD showMessage:@"添加失败"];
    } success:^(NSDictionary *retinfo) {
        [EVProgressHUD showMessage:@"已添加"];
        !weakself.addStockBlock ? : weakself.addStockBlock(cell.stockBaseModel.symbol);
    } sessionExpire:^{
        
    }];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EVBaseCellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hideLeftNavigationItem
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    for (UIView * view in [self.navigationController.navigationBar subviews]) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationItemButtonView")]) {
            [view removeFromSuperview];
        }
    }
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
