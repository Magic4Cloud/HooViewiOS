//
//  EVSearchAllViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSearchAllViewController.h"
#import <PureLayout.h>
#import "EVSearchView.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVSearchResultModel.h"
#import "EVLoadingView.h"
#import "UIScrollView+GifRefresh.h"
#import "EVUserTableViewCell.h"
#import "EVOtherPersonViewController.h"
#import "EVDiscoverNowVideoCell.h"
#import "UIViewController+Extension.h"
#import "EVNowVideoItem.h"
#import "EVMoreUserInfoViewController.h"
#import "EVLoginInfo.h"
#import "EVTagListView.h"
#import "EVBaseToolManager+EVSearchAPI.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVNullDataView.h"
#import "SGSegmentedControl.h"
#import "EVNewsListViewCell.h"
#import "EVLiveListViewCell.h"
#import "EVStockBaseViewCell.h"
#import "EVHVWatchViewController.h"
#import "EVNewsDetailWebController.h"
#import "EVMarketDetailsController.h"


#define CCSearchAllViewControllerFooterHeight 40.0f
#define CCSearchAllViewControllerHeaderHeight 30.0f
#define CCSearchAllViewControllerUserCellHeight 75.0f
#define CCSearchAllViewControllerVideoCellHeight 132.5
#define CCSearchAllViewControllerUserID @"CCSearchAllViewControllerUserID"
#define CCSearchAllViewControllerVideoID @"CCSearchAllViewControllerVideoID"

#define kHistoryMaxCount 9
#define kHeaderHeight    35.f

#define kPushHotController  @"pushHotController"

@interface EVSearchAllViewController ()<CCSearchViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, EVDiscoverNowVideoCellDelegate,CCTagsViewDelegate,SGSegmentedControlStaticDelegate>

@property (weak, nonatomic) UITableView *newsTableView;  /**< 数据展示列表 */
@property (weak, nonatomic) UITableView *liveTableView;
@property (weak, nonatomic) UITableView *stockTableView;
@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求引擎 */
@property (strong, nonatomic) EVSearchResultModel *searchResult; /**< 搜索结果 */
@property (weak, nonatomic) EVLoadingView *loadingView;  /**< 加载页面 */
@property (strong, nonatomic) EVUserTableViewCell *willUnfocusCell; /**< 即将取消关注的cell */
@property (strong, nonatomic) UIButton *willUnfocusBtn; /**< 即将取消关注cell的button */
@property (copy, nonatomic) NSString *lastSearchText; /**< 上次搜索的文字 */

@property (assign, nonatomic) BOOL isRequsting; /**< 是否正在刷新 */

@property ( strong, nonatomic ) NSMutableArray *historyArray;   /**< 历史记录 */
@property (copy, nonatomic) NSString *historyFilePath;          /**< 历史记录文件路径 */
@property ( weak, nonatomic ) UITableView *historyTableView;    /**< 历史记录列表 */
@property ( weak, nonatomic ) EVSearchView *searchView;         /**< 搜索框 */
@property ( weak, nonatomic ) UIButton *clearButton;            /**< 清除按钮 */

@property (nonatomic, weak) EVTagListView *historyTagListView;

@property (nonatomic, weak) EVTagListView *heatTagListView;

@property (nonatomic, weak) UIButton *historyButton;

@property (nonatomic, weak) UIButton *heatButton;

@property (nonatomic, weak) UIScrollView *tagListScrollView;

@property (nonatomic, weak) UIView *tableFooter;

@property (nonatomic, weak) EVNullDataView *newsNoDataView;
@property (nonatomic, weak) EVNullDataView *liveNoDataView;
@property (nonatomic, weak) EVNullDataView *stockNoDataView;
@property (nonatomic, assign) BOOL newsLoaded;
@property (nonatomic, assign) BOOL liveLoaded;
@property (nonatomic, assign) BOOL stockLoaded;

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, strong) UIScrollView *searchScrollView;


@property (nonatomic, assign) NSInteger scollViewIndex;

@property (nonatomic, strong) NSMutableArray *newsArray;

@property (nonatomic, strong) NSMutableArray *liveArray;

@property (nonatomic,strong) NSMutableArray *stockArray;

@property (nonatomic, assign) NSInteger newsInteger;
@property (nonatomic, assign) NSInteger liveInteger;
@property (nonatomic, assign) NSInteger stockInteger;


@end

@implementation EVSearchAllViewController

#pragma mark - life circle

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSearchView];
    [self addTableView];
    WEAK(self)
    [self.newsTableView addRefreshFooterWithRefreshingBlock:^{
        [self GETSearchInfoWithType:0 text:self.searchView.text start:weakself.newsInteger];
    }];
    [self.liveTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself GETSearchInfoWithType:1 text:self.searchView.text start:weakself.liveInteger];
    }];
    [self.stockTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself GETSearchInfoWithType:2 text:self.searchView.text start:weakself.stockInteger];
        
    }];
    self.title = kE_More;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideLeftNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    [EVNotificationCenter removeObserver:self];
    _newsTableView.dataSource = nil;
    _newsTableView.delegate = nil;
    _newsTableView = nil;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        if (self.newsLoaded == NO) {
            if (self.newsTableView && self.searchView.text.length > 0) {
                [self GETSearchInfoWithType:0 text:self.searchView.text start:0];
            }
        }
    }
    else if (offsetX == ScreenWidth) {
        if (self.liveLoaded == NO) {
            if (self.liveTableView && self.searchView.text.length > 0) {
                [self GETSearchInfoWithType:1 text:self.searchView.text start:0];
            }
        }
    }
    else if (offsetX == ScreenWidth * 2) {
        if (self.stockLoaded == NO) {
            if (self.stockTableView && self.searchView.text.length > 0) {
                [self GETSearchInfoWithType:2 text:self.searchView.text start:0];
            }
        }
    }
    self.lastSearchText = self.searchView.text;
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.view endEditing:YES];
}

#pragma mark - CCSearchViewDelegate
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{

    [self.searchView endEditting];
    CGFloat offsetX = index * self.view.frame.size.width;
    self.searchScrollView.contentOffset = CGPointMake(offsetX, 0);
    self.scollViewIndex = index;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 2.把对应的标题选中
    if (scrollView == self.searchScrollView) {
          NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.scollViewIndex = index;
        [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
        NSUInteger offsetX = scrollView.contentOffset.x;
        if (offsetX == 0) {
            if (self.newsLoaded == NO) {
                if (self.newsTableView && self.searchView.text.length > 0) {
                    [self GETSearchInfoWithType:0 text:self.searchView.text start:0];
                }
            }
        }
        else if (offsetX == ScreenWidth) {
            if (self.liveLoaded == NO) {
                if (self.liveTableView && self.searchView.text.length > 0) {
                    [self GETSearchInfoWithType:1 text:self.searchView.text start:0];
                }
            }
        }
        else if (offsetX == ScreenWidth * 2) {
            if (self.stockLoaded == NO) {
                if (self.stockTableView && self.searchView.text.length > 0) {
                    [self GETSearchInfoWithType:2 text:self.searchView.text start:0];
                }
            }
        }
    }
}


- (void)searchView:(EVSearchView *)searchView didBeginSearchWithText:(nullable NSString *)searchText
{
    // 收回键盘
    [searchView endEditting];
    self.tagListScrollView.hidden = YES;
    // 处理网络请求
    EVLog(@"---search text:%@", searchText);
    self.lastSearchText = searchText;
    
    [self GETSearchInfoWithType:self.scollViewIndex text:searchText start:0];
}


- (void)endRefresh
{
    [self.newsTableView endFooterRefreshing];
    [self.liveTableView endFooterRefreshing];
    [self.stockTableView endFooterRefreshing];
}
- (void)GETSearchInfoWithType:(NSUInteger)type text:(NSString *)text start:(NSInteger)start{
    
    [self.loadingView showLoadingView];
    __weak typeof(self) weakself = self;
    NSArray *tableArray = @[self.newsTableView,self.liveTableView,self.stockTableView];
    
    [self.engine getSearchInfosWith:text type:type start:start count:kCountNum startBlock:^{
        
    } fail:^(NSError *error) {
        [weakself endRefresh];
        if ([error.userInfo[@"reterr"] isEqualToString:@"无数据"]) {
            weakself.loadingView.activityIndicator.hidden = YES;
            weakself.loadingView.hidden = YES;
            [weakself handleNoDataViewStatusWithNoticeSearch:NO];
            
        }else {
            weakself.loadingView.failTitle = kNot_newwork_wrap;
            [weakself.loadingView showFailedViewWithClickBlock:^{
                [weakself searchView:weakself.searchView didBeginSearchWithText:weakself.lastSearchText];
            }];
        }
        
    } success:^(NSDictionary *dict) {
        EVLog(@"dict:%@ -------------- type %ld", dict,type);
        [weakself endRefresh];
        [weakself.loadingView destroy];
        EVSearchResultModel *model = [EVSearchResultModel objectWithDictionary:dict];

        switch (type) {
            case 0: {
                if (start == 0) {
                     [weakself.searchResult.news removeAllObjects];
                }
                weakself.newsInteger = [dict[@"next"] integerValue];
                [weakself.newsTableView setFooterState:([dict[@"count"] integerValue] < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];

                [weakself.searchResult.news addObjectsFromArray:model.news];
                self.newsLoaded = YES;
                break;
            }
            case 1: {
                if (start == 0) {
                    [weakself.searchResult.videos removeAllObjects];
                }
                weakself.liveInteger = [dict[@"next"] integerValue];
                [weakself.liveTableView setFooterState:([dict[@"count"] integerValue] < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
                [weakself.searchResult.videos addObjectsFromArray:model.videos];
                self.liveLoaded = YES;
                break;
            }
            case 2: {
                if (start == 0) {
                     [weakself.searchResult.data removeAllObjects];
                }
                weakself.stockInteger = [dict[@"next"] integerValue];
                [weakself.stockTableView setFooterState:([dict[@"count"] integerValue] < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
                [weakself.searchResult.data addObjectsFromArray:model.data];
                self.stockLoaded = YES;
                break;
            }
                
            default:
                break;
        }
        
        [weakself handleNoDataViewStatusWithNoticeSearch:NO];
        [tableArray[type] reloadData];
    } sessionExpire:^{
        EVRelogin(weakself);
    } reterrBlock:^(NSString *reterr) {
        [weakself endRefresh];
        [weakself handleNoDataViewStatusWithNoticeSearch:NO];
        [weakself.loadingView destroy];
        
    }];
}

- (void)cancelSearch
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchView:(EVSearchView *)searchView didBeginEditing:(UITextField *)textField
{
    [self.loadingView destroy];
    self.tagListScrollView.hidden = NO;
    [self handleNoDataViewStatusWithNoticeSearch:YES];
    [self historyWordArrayCountNotNil];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.newsTableView) {
        return self.searchResult.news.count;
    }else if (tableView == self.liveTableView) {
        return self.searchResult.videos.count;
    }
    return self.searchResult.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.newsTableView) {
        EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
        newsCell.searchNewsModel = self.searchResult.news[indexPath.row];
        return newsCell;
    }else if (tableView == self.liveTableView) {
        EVLiveListViewCell *listCell  = [tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:indexPath];
        listCell.watchVideoInfo = self.searchResult.videos[indexPath.row];
        return listCell;
    }
    
    EVStockBaseViewCell *baseCell = [tableView dequeueReusableCellWithIdentifier:@"stockCell"];
    baseCell.searchBaseModel = self.searchResult.data[indexPath.row];
    return baseCell;

 
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.newsTableView || tableView == self.liveTableView) {
        return 100;
    }
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.newsTableView) {
        EVBaseNewsModel *newsModel = self.searchResult.news[indexPath.row];
        EVNewsDetailWebController *news = [[EVNewsDetailWebController alloc] init];
        news.newsID = newsModel.newsID;
        news.title = newsModel.title;
        [self.navigationController pushViewController:news animated:YES];
        
        
    }else if (tableView == self.liveTableView){
        EVWatchVideoInfo *WatchInfo = self.searchResult.videos[indexPath.row];
        EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
        watchViewVC.watchVideoInfo = WatchInfo;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else {
        EVStockBaseModel *STOCKModel = self.searchResult.data[indexPath.row];
        EVMarketDetailsController *markerVC = [[EVMarketDetailsController alloc] init];
        markerVC.stockBaseModel = STOCKModel;
        markerVC.special = 1;       // 搜索中的“股票”一栏，都显示股票信息
        [self.navigationController pushViewController:markerVC animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.navigationController.view endEditing:YES];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 )
    {
        [self requestwithCell:self.willUnfocusCell button:self.willUnfocusBtn];
    }
}




#pragma mark - event response

- (void)lookForMore
{
    EVLog(@"查看更多");
    EVMoreUserInfoViewController *moreUserVC = [[EVMoreUserInfoViewController alloc] init];
    moreUserVC.keyword = self.lastSearchText;
    [self.navigationController pushViewController:moreUserVC animated:YES];
}


#pragma mark - EVDiscoverNowVideoCellDelegate

- (void)discoverCellDidClickHeaderIcon:(EVNowVideoItem *)item
{
    EVOtherPersonViewController *vc = [[EVOtherPersonViewController alloc] init];
    vc.name = item.name;
    vc.fromLivingRoom = NO;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - private methods

- (void)addSearchView
{
    CGFloat height = 31.0f;
    // 搜索视图
    EVSearchView *searchView = [[EVSearchView alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth , height)];
    searchView.placeHolder = @"搜您想了解的";
    searchView.placeHolderColor = [UIColor evTextColorH2];
    searchView.searchDelegate = self;
    self.searchView = searchView;
    
    self.navigationItem.titleView = searchView;
    [searchView begineEditting];
    
    [searchView layoutIfNeeded];
}

// delegate 方法


- (void)addTableView
{
    NSArray *titleArray = @[@"新闻",@"直播",@"股票"];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, 44)];
    topBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBackView];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 1, ScreenWidth/4 * 3, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
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
    searchScrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight - 118);
    searchScrollView.delegate = self;
    searchScrollView.pagingEnabled = YES;

    // 设置 view 的背景色
    self.view.backgroundColor = [UIColor evBackgroundColor];
    // 添加展示列表
    UITableView *newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 118) style:(UITableViewStylePlain)];
    newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    newsTableView.dataSource = self;
    newsTableView.delegate = self;
    [searchScrollView addSubview:newsTableView];
    self.newsTableView = newsTableView;
    self.newsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 设置展示列表的约束
    
    UITableView *liveTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    liveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    liveTableView.dataSource = self;
    liveTableView.delegate = self;
    [searchScrollView addSubview:liveTableView];
    self.liveTableView = liveTableView;
    self.liveTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 设置展示列表的约束
    self.liveTableView.frame = CGRectMake(ScreenWidth,0 , ScreenWidth, ScreenHeight - 115);

    
    UITableView *stockTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    stockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    stockTableView.dataSource = self;
    stockTableView.delegate = self;
    [searchScrollView addSubview:stockTableView];
    self.stockTableView = stockTableView;
    self.stockTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 设置展示列表的约束
    self.stockTableView.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - 118);
    
    self.newsTableView.backgroundColor = [UIColor clearColor];
    self.liveTableView.backgroundColor = [UIColor clearColor];
    self.stockTableView.backgroundColor = [UIColor clearColor];
    
    // cell 注册
    [newsTableView registerNib:[UINib nibWithNibName:@"EVNewsListViewCell" bundle:nil]  forCellReuseIdentifier:@"newsCell"];
     [liveTableView registerNib:[UINib nibWithNibName:@"EVLiveListViewCell" bundle:nil]  forCellReuseIdentifier:@"liveCell"];
    [self.stockTableView registerClass:[EVStockBaseViewCell class] forCellReuseIdentifier:@"stockCell"];
    
    __weak typeof(self) weakself = self;
    
    EVNullDataView *newsNoDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-115)];
    [searchScrollView addSubview:newsNoDataView];
    newsNoDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    newsNoDataView.title = @"搜索您想了解的新闻";
    self.newsNoDataView = newsNoDataView;
    UITapGestureRecognizer *newsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsTap)];
    [newsNoDataView addGestureRecognizer:newsTap];
    
    
    EVNullDataView *liveNoDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-115)];
    [searchScrollView addSubview:liveNoDataView];
    liveNoDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    liveNoDataView.title = @"搜索您想了解的直播";
    self.liveNoDataView = liveNoDataView;
    UITapGestureRecognizer *liveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveTap)];
    [liveNoDataView addGestureRecognizer:liveTap];
    
    EVNullDataView *stockNoDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, ScreenHeight-115)];
    [searchScrollView addSubview:stockNoDataView];
    stockNoDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    stockNoDataView.title = @"搜索您想了解的股票";
    self.stockNoDataView = stockNoDataView;
    UITapGestureRecognizer *stockTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stockTap)];
    [stockNoDataView addGestureRecognizer:stockTap];
    [weakself handleNoDataViewStatusWithNoticeSearch:YES];
    
    [self.newsTableView addRefreshFooterWithRefreshingBlock:^{
        [self loadingMoreData];
    }];
    [self.liveTableView addRefreshFooterWithRefreshingBlock:^{
        [self loadingMoreData];
    }];
    [self.stockTableView addRefreshFooterWithRefreshingBlock:^{
        [self loadingMoreData];
    }];
}

- (void)loadingMoreData
{
    NSInteger startCount;
    switch (self.scollViewIndex) {
        case 0:
            startCount = self.searchResult.news.count;
            break;
        case 1:
            startCount = self.searchResult.videos.count;
            break;
        case 2:
            startCount = self.searchResult.data.count;
            break;
            
        default:
            break;
    }
    WEAK(self)
    NSArray *tableArray = @[self.newsTableView,self.liveTableView,self.stockTableView];
    [self.engine getSearchInfosWith:self.lastSearchText type:self.scollViewIndex start:startCount count:20 startBlock:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD showError:@"加载失败"];
    } success:^(NSDictionary *dict) {
    
        [tableArray[self.scollViewIndex] endFooterRefreshing];
        EVSearchResultModel *model = [EVSearchResultModel objectWithDictionary:dict];
        switch (self.scollViewIndex) {
            case 0:
            {
                [weakself.newsTableView setFooterState:(model.news.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
                [weakself.searchResult.news addObjectsFromArray:model.news];
            }
                break;
            case 1:
            {
                [weakself.liveTableView setFooterState:(model.videos.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
                [weakself.searchResult.videos addObjectsFromArray:model.videos];
            }
                break;
            case 2:
            {
                [weakself.stockTableView setFooterState:(model.data.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
                [weakself.searchResult.data addObjectsFromArray:model.data];
            }
                break;
                
            default:
                break;
        }
        [tableArray[self.scollViewIndex] reloadData];
    } sessionExpire:^{
         [tableArray[self.scollViewIndex] endFooterRefreshing];
    } reterrBlock:^(NSString *reterr) {
        
    }];
}

- (void)handleNoDataViewStatusWithNoticeSearch:(BOOL)noticeToSearch {
    if (noticeToSearch) {
        self.newsNoDataView.topImage = self.liveNoDataView.topImage = self.stockNoDataView.topImage = [UIImage imageNamed:@"ic_smile"];
        self.newsNoDataView.hidden = self.liveNoDataView.hidden = self.stockNoDataView.hidden = NO;
        self.newsNoDataView.title = @"搜索您想了解的新闻";
        self.liveNoDataView.title = @"搜索您想了解的直播";
        self.stockNoDataView.title = @"搜索您想了解的股票";
        [self.searchResult.news removeAllObjects];
        [self.searchResult.videos removeAllObjects];
        [self.searchResult.data removeAllObjects];
        self.newsLoaded = NO;
        self.liveLoaded = NO;
        self.stockLoaded = NO;
        return;
    }
    
    self.newsNoDataView.title = self.liveNoDataView.title = self.stockNoDataView.title = Search_all_noData_title;
    self.newsNoDataView.topImage = self.liveNoDataView.topImage = self.stockNoDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    BOOL noNewsData = self.searchResult.news.count == 0;
    BOOL noLiveData = self.searchResult.videos.count == 0;
    BOOL noStockData = self.searchResult.data.count == 0;
    self.newsNoDataView.hidden = !noNewsData;
    self.liveNoDataView.hidden = !noLiveData;
    self.stockNoDataView.hidden = !noStockData;
}

- (void)stockTap
{
    [self.searchView endEditting];
    
}

- (void)liveTap
{
    [self.searchView endEditting];
}

- (void)newsTap
{
    [self.searchView endEditting];
}
#pragma mark - 热搜词
//- (void)addTagListView
//{
//
//    UIButton *historyView = [self getButtonWithTitle:kSearch_history image:@"search_icon_record" buttonFrame:CGRectMake(15, 0, ScreenWidth, kHeaderHeight)];
//    [self.tagListScrollView addSubview:historyView];
//    _historyButton = historyView;
//    
//    EVTagListView *historyTagListView = [[EVTagListView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(historyView.frame), ScreenWidth, 0)];
//    historyTagListView.type = 0;
//    [self.tagListScrollView addSubview:historyTagListView];
//    historyTagListView.backgroundColor = [UIColor whiteColor];
//    _historyTagListView = historyTagListView;
//    _historyTagListView.tagDelegate  = self;
//    
//    [self.historyTagListView setTagAry:self.historyArray];
//    self.clearButton.hidden = self.historyArray.count == 0 ? YES : NO;
//    
//    self.tagListScrollView.contentSize = CGSizeMake(ScreenWidth, historyTagListView.frame.origin.y+historyTagListView.frame.size.height+140);
//}

- (void)historyWordArrayCountNotNil
{
    [self.historyTagListView setTagAry:self.historyArray];
    self.historyTagListView.hidden = self.historyArray.count == 0 ? YES : NO;
    self.clearButton.hidden = self.historyArray.count == 0 ? YES : NO;
    [self.historyTagListView reloadData];
    self.tagListScrollView.contentSize = CGSizeMake(ScreenWidth, _historyTagListView.frame.origin.y+_historyTagListView.frame.size.height+140);
    self.tableFooter.frame = CGRectMake(0, _historyTagListView.frame.origin.y+_historyTagListView.frame.size.height, ScreenWidth, 60.f);
}

// 清空历史记录
- (void)clearHistoryArray:(UIButton *)button
{
    [self.historyArray removeAllObjects];
    [self.historyArray writeToFile:self.historyFilePath atomically:YES];
     self.clearButton.hidden = self.historyArray.count == 0 ? YES : NO;
    self.historyTagListView.hidden = self.historyArray.count == 0;
    // 如果清空了隐藏清除按钮
    button.hidden = self.historyArray.count == 0;
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

- (UIView *)getAHeaderViewWithTitle:(NSString *)title
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth, CCSearchAllViewControllerHeaderHeight)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLbl.text = title;
    titleLbl.textColor = [UIColor evTextColorH1];
    titleLbl.font = [[EVAppSetting shareInstance] normalFontWithSize:14.0f];
    [header addSubview:titleLbl];
    [titleLbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, 13.0f, .0f, .0f)];
    
    [self addTopSeparatorLineToView:header];
    [self addBottomSeparatorLineToView:header];
    
    return header;
}

- (UIButton *)getButtonWithTitle:(NSString *)title image:(NSString *)image buttonFrame:(CGRect)buttonFrame
{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = buttonFrame;
    button.backgroundColor = [UIColor whiteColor];
    button.selected = NO;
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15.];
    [button setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton *clearButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    clearButton.frame = CGRectMake(ScreenWidth - 85, 0, 70, 35);
    [clearButton setTitle:kE_Clear forState:(UIControlStateNormal)];
    [clearButton setTitleColor:[UIColor evMainColor] forState:(UIControlStateNormal)];
    [button addSubview:clearButton];
    clearButton.hidden = YES;
    self.clearButton = clearButton;
    clearButton.titleLabel.font = [UIFont systemFontOfSize:15.];
    [clearButton addTarget:self action:@selector(clearHistoryArray:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return button;
}

- (void)addTopSeparatorLineToView:(UIView *)view
{
    // 添加顶部分割线
    UIView *topSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    topSeparatorLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [view addSubview:topSeparatorLine];
    [topSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [topSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [topSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [topSeparatorLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

- (void)addBottomSeparatorLineToView:(UIView *)view
{
    // 添加底部分割线
    UIView *bottomSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    bottomSeparatorLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [view addSubview:bottomSeparatorLine];
    [bottomSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [bottomSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [bottomSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [bottomSeparatorLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

- (void)focusPersonWithCell:(EVUserTableViewCell *)cell button:(UIButton *)btn
{
    if ( cell.userInfo.followed )
    {
        self.willUnfocusCell = cell;
        self.willUnfocusBtn = btn;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:kE_GlobalZH(@"provoke_unhappy_cancel_follow") delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:kOK otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        
        return;
    }
    
    [self requestwithCell:cell button:btn];
}

- (void)requestwithCell:(EVUserTableViewCell *)cell button:(UIButton *)btn
{
    __weak typeof(self) weakself = self;
    __weak EVUserTableViewCell *weakCell = cell;
    __weak UIButton *weakBtn = btn;
    [self.engine GETFollowUserWithName:cell.userInfo.name followType:!cell.userInfo.followed start:^{
        
    } fail:^(NSError *error) {
        
    } success:^{
        weakCell.userInfo.followed = !weakCell.userInfo.followed;
        weakBtn.selected = weakCell.userInfo.followed;
    } essionExpire:^{
        EVRelogin(weakself);
    }];
}

#pragma mark - setters and getters

- (EVLoadingView *)loadingView
{
    if ( !_loadingView )
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:loadingView];
        //        _loadingView.verticalOffset = -60.0f;
        _loadingView = loadingView;
    }
    
    return _loadingView;
}

- (EVBaseToolManager *)engine
{
    if ( !_engine )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}
- (EVSearchResultModel *)searchResult {
    if (!_searchResult) {
        _searchResult = [EVSearchResultModel new];
        _searchResult.news = @[].mutableCopy;
        _searchResult.videos = @[].mutableCopy;
        _searchResult.data = @[].mutableCopy;
    }
    return _searchResult;
}
- (NSMutableArray *)historyArray
{
    if ( _historyArray == nil )
    {
        self.historyArray
        = [NSMutableArray arrayWithCapacity:10];
    }
    return _historyArray;
}

- (NSMutableArray *)liveArray
{
    if (!_liveArray) {
        _liveArray = [NSMutableArray array];
    }
    return _liveArray;
}

- (NSMutableArray *)newsArray
{
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

- (NSMutableArray *)stockArray
{
    if (!_stockArray) {
        _stockArray = [NSMutableArray array];
    }
    return _stockArray;
}

- (NSString *)storyFilePath
{
    if ( _historyFilePath == nil )
    {
        EVLoginInfo *info = [EVLoginInfo localObject];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *userMarksDirPath = [cachePath stringByAppendingPathComponent:@"searchRecord"];
        NSString *currentPath = [NSString stringWithFormat:@"searchRecord_%@",info.name];
        if (![[NSFileManager defaultManager] fileExistsAtPath:userMarksDirPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:userMarksDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _historyFilePath = [userMarksDirPath stringByAppendingPathComponent:currentPath];
    }
    return _historyFilePath;
}

@end
