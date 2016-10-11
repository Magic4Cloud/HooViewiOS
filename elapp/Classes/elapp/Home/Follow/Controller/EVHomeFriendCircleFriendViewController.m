//
//  EVHomeFriendCircleFriendViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVHomeFriendCircleFriendViewController.h"
#import <PureLayout.h>
#import "EVCircleRecordedModel.h"
#import "EVOtherPersonViewController.h"
#import "EVBaseToolManager+EVFindFreindsAPI.h"
#import "EVLoadingView.h"
#import "UIScrollView+GifRefresh.h"
#import "EVWatchVideoInfo.h"
#import "UIViewController+Extension.h"
#import "EVLoginInfo.h"
#import "EVHomeTabbar.h"
#import "EVNullDataView.h"
#import "EVCircleLiveVideoTableViewCell.h"

#define kEditViewHeight 49

@interface EVHomeFriendCircleFriendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) CGPoint oldPoint;
@property ( weak, nonatomic ) UITableView *tableView;
@property ( strong, nonatomic ) EVBaseToolManager *engine;
@property ( strong, nonatomic ) NSArray *dataArray;
@property ( strong, nonatomic ) NSMutableArray *liveArray;         /**< 直播数组 */
@property ( weak, nonatomic ) EVLoadingView *loadingView;
@property (nonatomic, assign) BOOL refreshing;
@property (assign, nonatomic) NSInteger loadCount;
@property (assign, nonatomic) NSInteger next;                   /**< 下次请求的起点 */
@property ( strong, nonatomic ) NSString *lastLoginname;        /**< 上次登录的易视云号 */
@property ( weak, nonatomic ) EVNullDataView *nullDataView;     /**< 空数据时覆盖的视图 */

@end

@implementation EVHomeFriendCircleFriendViewController

- (void)dealloc
{
    [_engine cancelAllOperation];
    [CCNotificationCenter removeObserver:self];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self addObserver];
    [self setNotification];
    [self loadDataStart:0 count:kCountNum];
    [self addRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(sessionDidUpdate) name:CCSessionIdDidUpdateNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(followStateChanged) name:CCFollowedStateChangedNotification object:nil];
}

// 关注好友的状态发生改变
- (void)followStateChanged
{
    [self loadDataStart:0 count:kCountNum];
}

// 切换新用户成功
- (void)sessionDidUpdate
{
    [self loadDataStart:0 count:kCountNum];
}

- (void) setUpUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(CCHOMENAV_HEIGHT, 0, HOMETABBAR_HEIGHT, 0);
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor evBackgroundColor];
    if ( IOS8_OR_LATER )
    {
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    // 空数据视图
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - HOMETABBAR_HEIGHT)];
    [self.tableView addSubview:nullDataView];
    nullDataView.topImage = [UIImage imageNamed:@"home_pic_findempty"];
    nullDataView.title = kE_GlobalZH(@"no_have_follow");
    nullDataView.subtitle = kE_GlobalZH(@"goFollow");
    nullDataView.buttonTitle = kE_GlobalZH(@"pickLive");
    [nullDataView addButtonTarget:self action:@selector(nullDataViewButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.nullDataView = nullDataView;
    
    // 加载动画
    EVLoadingView *loadingView = [[EVLoadingView alloc] init];
    [self.view addSubview:loadingView];
    [loadingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.loadingView = loadingView;
}

//  点击空数据列表的按钮
- (void)nullDataViewButtonDidClicked:(UIButton *)button
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushHotViewController)]) {
        [self.delegate pushHotViewController];
    }
    
}

// 添加刷新动画
- (void)addRefresh
{
    // 添加下拉刷新的回调函数
    __weak typeof(self) weakself = self;
    [self.tableView addRefreshHeaderWithRefreshingBlock:^{
        if ([weakself.tableView isTableViewFooterRefreshing])
        {
            [weakself.tableView endHeaderRefreshing];
            return;
        }
        [weakself loadDataStart:0 count:kCountNum];
    }];
    
    // 添加上拉刷新的回调函数
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        if ([weakself.tableView isTableViewHeaderRefreshing])
        {
            [weakself.tableView endFooterRefreshing];
            return;
        }
        [weakself loadDataStart:weakself.next count:kCountNum];
    }];
}

// 结束刷新
- (void)endRefresh
{
    self.refreshing = NO;
    [self.tableView endHeaderRefreshing];
    [self.tableView endFooterRefreshing];
    if ( self.loadCount < kCountNum )
    {
        self.tableView.footerState = CCRefreshStateNoMoreData;
    }else
    {
        self.tableView.footerState = CCRefreshStateIdle;
    }
}

- (void)addObserver
{
    // 监听tableview的滑动
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

// 监听偏移量变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == NULL && [keyPath isEqualToString:@"contentOffset"] )
    {
        CGPoint newPoint = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        // 上滑
        if ( newPoint.y - _oldPoint.y > 0 && newPoint.y > 0 )
        {
            [self.homeScrollView homeScrollViewControllerHideBar];
        }
        else if (newPoint.y - _oldPoint.y < 0 )
        {
            [self.homeScrollView homeScrollViewControllerShowBar];
        }
        self.oldPoint = newPoint;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)loadDataStart:(NSInteger)start count:(NSInteger)count
{
    if (self.refreshing)
    {
        return;
    }
    self.refreshing = YES;
    
    if ( 0 == self.liveArray.count && 0 == start)
    {
        [self.loadingView showLoadingView];
    }
    __weak typeof(self) weakSelf = self;
    // 加载数据
    [self.engine GETFriendCircleStart:start count:count start:nil fail:^(NSError *error) {
        [weakSelf.loadingView showFailedViewWithClickBlock:^{
            [weakSelf loadDataStart:start count:count];
        }];
        [weakSelf endRefresh];
    } success:^(id messageData) {
        
        [weakSelf.loadingView destroy];
        
        weakSelf.next = [[messageData objectForKey:@"next"] integerValue];
        
        NSArray *vedios = [EVCircleRecordedModel videosAarryWithMessageData:messageData];
        
        weakSelf.loadCount = vedios.count;
        if ( start == 0 )
        {
            [weakSelf.liveArray removeAllObjects];
        }
        [weakSelf configDataSourceWithVedios:vedios];
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
        if ( weakSelf.lastLoginname == nil )
        {
            weakSelf.lastLoginname = [EVLoginInfo localObject].name;
        }
        if ( start == 0 )
        {
            // 是否显示空列表提示
            weakSelf.nullDataView.hidden = vedios.count > 0;
        }
    } essionExpire:^{
        [weakSelf.loadingView destroy];
        [weakSelf endRefresh];
        CCRelogin(weakSelf);
    }];
    
}

- (void)configDataSourceWithVedios:(NSArray *)vediosArray
{
    for (int i = 0; i < vediosArray.count; i ++)
    {
        EVCircleRecordedModel *model = vediosArray[i];
    
        if ( ![self.liveArray containsObject:model] )
        {
            [self.liveArray addObject:model];
        }
    
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.liveArray.count;
}

// fix by 杨尚彬 iOS 7 内存测试
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [EVCircleLiveVideoTableViewCell cellHeight];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVCircleRecordedModel *model = nil;
    if ( self.liveArray.count > 0 )
    {
        model = self.liveArray[indexPath.row];
    }
    // 直播

        EVCircleLiveVideoTableViewCell *liveCell = [EVCircleLiveVideoTableViewCell cellForTableView:tableView];
        liveCell.cellItem = model;
        __weak typeof(self) weakself = self;
        liveCell.avatarClick = ^(EVCircleRecordedModel *cellModel){
            EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc] init];
            otherVC.name = cellModel.name;
            otherVC.fromLivingRoom = NO;
            [weakself.navigationController pushViewController:otherVC animated:YES];
        };
        return liveCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
    if ( indexPath.row >= self.liveArray.count )
    {
        return;
    }
    
    EVCircleRecordedModel *video = self.liveArray[indexPath.row];
    NSString *vid = video.vid;
    EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
    videoInfo.vid = vid;
    videoInfo.play_url = video.play_url;
    videoInfo.thumb = video.thumb;
    [self playVideoWithVideoInfo:videoInfo permission:video.permission];

}


#pragma mark - CCForecastShareViewDelegate
- (void)liveShareViewDidHidden
{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - editView delegate

#pragma mark - getter
- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (NSMutableArray *)liveArray
{
    if ( _liveArray == nil )
    {
        _liveArray = [NSMutableArray array];
    }
    return _liveArray;
}


@end
