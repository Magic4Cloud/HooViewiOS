//
//  EVNewFriendViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNewFriendViewController.h"
#import "EVNotifyViewCell.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVOtherPersonViewController.h"
#import "EVNewFriendItemModel.h"
#import <PureLayout.h>
#import "UIScrollView+GifRefresh.h"
#import "EVNetWorkStateManger.h"
#include "EVLoadingView.h"
#import "EVBaseToolManager+EVMessageAPI.h"

#define kNewFriendRequestCount 20
#define kBackgroundColor [UIColor colorWithHexString:@"#f0f0f0"]

const NSString *const notifyCellID2 = @"notifylist2";

@interface EVNewFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;             //所有消息列表
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (nonatomic, strong) UILabel *netWorkIndicatorLabel;
@property (assign, nonatomic) CCRefreshState refreshState;    //设置刷新状态
@property ( weak, nonatomic ) EVLoadingView *loadingView;



@end

@implementation EVNewFriendViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = CCBackgroundColor;
    
    [self setUptable];
    
    [self setNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [_engine cancelAllOperation];
    _engine = nil;
    _messages = nil;
    [CCNotificationCenter removeObserver:self];
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

#pragma mark - 通知

//  添加通知的方法
- (void)setNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(receiveNetWorkChange:) name:CCNetWorkChangeNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(receiveRemarkChange) name:kEditedRemarkNotification object:nil];
}

//  处理网络变化的通知
- (void)receiveNetWorkChange:(NSNotification *)notification
{
    NSNumber *statusNumber = [notification.userInfo objectForKey:CCNetWorkStateKey];
    CCNetworkStatus status = [statusNumber integerValue];
    //  如果网络OK
    if (status != WithoutNetwork)
    {
        //  网络不给力指示隐藏
        [self hideNetWorkBadLabel];
        
        //  如果当前数据是空的就发送请求
        if ( self.messages.count == 0 )
        {
            [self refreshMessageData];
        }
    }
    else
    {
        [_engine cancelAllOperation];
        [self showNetWorkBadLabel];
    }
}

- (void)receiveRemarkChange
{
    [self.tableView reloadData];
}

#pragma mark - 设置隐藏显示网络不给力指示

- (void)showNetWorkBadLabel
{
    // 取消网络请求
    self.refreshState = CCRefreshStateIdle;
    self.netWorkIndicatorLabel.hidden = NO;
}

- (void)hideNetWorkBadLabel
{
    self.netWorkIndicatorLabel.hidden = YES;
}

#pragma mark - setter

- (void)setRefreshState:(CCRefreshState)refreshState
{
    [self.tableView setFooterState:refreshState];
}

#pragma mark -  getter

- (CCRefreshState)refreshState
{
    return [self.tableView footerState];
}

- (NSMutableArray *)messages{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (UILabel *)netWorkIndicatorLabel
{
    if ( _netWorkIndicatorLabel == nil )
    {
        _netWorkIndicatorLabel = [[UILabel alloc] init];
        _netWorkIndicatorLabel.text = kFailNetworking;
        _netWorkIndicatorLabel.backgroundColor = kBackgroundColor;
        _netWorkIndicatorLabel.font = [UIFont systemFontOfSize:13];
        _netWorkIndicatorLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _netWorkIndicatorLabel.textAlignment = NSTextAlignmentCenter;
        CGRect frame = [self.tableView footerBounds];
        _netWorkIndicatorLabel.frame = CGRectMake(0, 0, ScreenWidth, frame.size.height);
    }
    return _netWorkIndicatorLabel;
}

- (EVBaseToolManager *)engine {
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (EVLoadingView *)loadingView
{
    if ( _loadingView == nil )
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] init];
        [self.view addSubview:loadingView];
        [loadingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.loadingView = loadingView;
    }
    return _loadingView;
}

#pragma mark - table view delegate & data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNotifyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)notifyCellID2];
    cell.contantLabelFont = [UIFont systemFontOfSize:14];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EVNotifyItem *model = self.messages[indexPath.row];
    cell.cellItem = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewFriendItemModel *item = [self.messages objectAtIndex:indexPath.row];
    EVOtherPersonViewController *personalPage = [EVOtherPersonViewController instanceWithName:item.name];
    personalPage.fromLivingRoom = NO;
    [self.navigationController pushViewController:personalPage animated:YES];
}


#pragma mark - UI
- (UIView *)addHeaderView
{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 11.5)];
    headerView.backgroundColor = CCBackgroundColor;
    
    UIView * topDiv = [UIView newAutoLayoutView];
    [headerView addSubview:topDiv];
    
    [topDiv autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0];
    [topDiv autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:0];
    [topDiv autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerView withOffset:0];
    [topDiv autoSetDimension:ALDimensionHeight toSize:0.7];
    
    UIView * bottomDiv = [UIView newAutoLayoutView];
    [headerView addSubview:bottomDiv];
    [bottomDiv autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [bottomDiv autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [bottomDiv autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [bottomDiv autoSetDimension:ALDimensionHeight toSize:0.7];
    return headerView;
    
}

//  UI
-(void)setUptable
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.tableHeaderView = [self addHeaderView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView = tableView;
    tableView.backgroundColor = CCBackgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"EVNotifyViewCell" bundle:nil] forCellReuseIdentifier:(NSString *)notifyCellID2];
    
    //  标题
    self.title = kE_GlobalZH(@"new_Friend");

    //  添加上拉加载更多
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        [weakSelf sendRequstIfNetWorkOK];
    }];
    
    //  添加网络不给力指示
    [self.tableView addSubviewToFooterWithSubview:self.netWorkIndicatorLabel];
    [self hideNetWorkBadLabel];
    
    //  刷新数据
//    [self refreshMessageData];
    [self sendRequstIfNetWorkOK];
}

#pragma mark - 网络请求

- (void)refreshMessageData
{
    if ( self.refreshState != CCRefreshStateNoMoreData )
    {
        /**发送请求  设置state为MJRefreshFooterStateRefreshing会自动回调addLegendFooterWithRefreshingBlock*/
        self.refreshState = CCRefreshStateRefreshing;
    }
}

//  如果网络良好发送网络请求
- (void)sendRequstIfNetWorkOK
{
    if ( [EVNetWorkStateManger sharedManager].currNetWorkState == WithoutNetwork )
    {
        [self showNetWorkBadLabel];
    }
    else
    {
        [self hideNetWorkBadLabel];
        [self refreshMessagesStart:self.messages.count count:kNewFriendRequestCount];
    }
}

/**
 *  更新数据
 *
 *  @param start 开始位置
 *  @param count 更新的数据长度
 */
- (void)refreshMessagesStart:(NSInteger)start count:(NSInteger)count
{
    if ( 0 == self.messages.count )
    {
        [self.loadingView showLoadingView];
    }
    __weak typeof(self) weakSelf = self;
    [self.engine GETMessageitemlistStart:start
                                count: count
                              groupid:self.notiItem.groupid
                                start:^
    {
    } fail:^(NSError *error) {
        [weakSelf.loadingView showFailedViewWithClickBlock:^{
            [weakSelf refreshMessagesStart:start count:count];
        }];
    } success:^(id messageData) {
        [weakSelf.loadingView destroy];
        [weakSelf.tableView endFooterRefreshing];
        if ([messageData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)messageData;
            NSArray *items = [dic objectForKey:@"items"];
            if ( items.count < count )
            {
                [weakSelf setRefreshState:CCRefreshStateNoMoreData];
            }
            else
            {
                [weakSelf setRefreshState:CCRefreshStateIdle];
            }
            for (NSDictionary *dictItem in items) {
                EVNewFriendItemModel *item = [EVNewFriendItemModel objectWithDictionary:dictItem];
                [weakSelf.messages addObject:item];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
