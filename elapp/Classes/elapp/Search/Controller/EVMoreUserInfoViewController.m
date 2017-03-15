//
//  EVMoreUserInfoViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVMoreUserInfoViewController.h"
#import "EVUserTableViewCell.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "UIScrollView+GifRefresh.h"
#import <PureLayout.h>
#import "EVOtherPersonViewController.h"
#import "EVLoadingView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVBaseToolManager+EVSearchAPI.h"

@interface EVMoreUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, weak) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *userInfoArray;
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (nonatomic, assign) NSInteger next;
@property (weak, nonatomic) EVLoadingView *loadingView;  /**< 加载页面 */
@property (strong, nonatomic) EVUserTableViewCell *willUnfocusCell; /**< 即将取消关注的cell */
@property (strong, nonatomic) UIButton *willUnfocusBtn; /**< 即将取消关注cell的button */

@end

@implementation EVMoreUserInfoViewController

#pragma mark - 控制器生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self setUpNavigationBar];
    [self setUpMainTableView];
    [self addRefresh];
    [self loadData];
    self.next = 0;
    self.title = kE_More;
}

#pragma mark - 控制器生命周期方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma make - 获取网络服务器数据
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    if (self.next == 0)
    {
        [self.loadingView showLoadingView];
    }
    [self.engine getSearchInfosWith:self.keyword type:@"user" start:self.next count:kCountNum startBlock:^{
        
    } fail:^(NSError *error) {
        [weakSelf.tableview endFooterRefreshing];
        [weakSelf.loadingView showFailedViewWithClickBlock:^{
            [weakSelf loadData];
        }];
        
    } success:^(NSDictionary *dict) {
        
        [weakSelf endPageRefresh];
        // 删除loadingView
        [weakSelf.loadingView destroy];
        weakSelf.loadingView = nil;
        
        NSArray *userInfos = dict[kUserKey];
        NSArray *pageArray = [EVFindUserInfo objectWithDictionaryArray:userInfos];
        [self.userInfoArray addObjectsFromArray:pageArray];
        self.next = [dict[@"user_next"] integerValue];
        [weakSelf.tableview reloadData];
        
        if (pageArray.count < kCountNum)
        {
            [self endRefresh];
        }
    } sessionExpire:^{
        [weakSelf.tableview endFooterRefreshing];
        EVRelogin(weakSelf);
    } reterrBlock:^(NSString *reterr) {
        weakSelf.loadingView.failTitle = kNot_find_content;
        [weakSelf.loadingView showFailedViewWithClickBlock:^{
            [weakSelf loadData];
        }];
        
    }];
}

#pragma mark - 设置导航栏信息
- (void)setUpNavigationBar
{
    // 设置leftBarButtonItem
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 50);
    [backButton setTitle:kEBack forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToLastController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
}

#pragma mark - 返回上一个控制器页面
- (void)backToLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置tableview
- (void)setUpMainTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectZero];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.showsVerticalScrollIndicator = NO;
    _tableview = tableview;
    [self.view addSubview:tableview];
    [tableview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.view.backgroundColor = [UIColor evBackgroundColor];
}

#pragma mark - 添加加载更多动画
- (void)addRefresh
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉加载更多的回调函数
    [weakSelf.tableview addRefreshFooterWithRefreshingBlock:^
     {
         [weakSelf loadData];
     }];
}

#pragma mark - 分页结束刷新
- (void)endPageRefresh
{
    [self.tableview endFooterRefreshing];
    [self.tableview setFooterState:CCRefreshStateIdle];
    
}

#pragma mark - 全部数据加载完毕结束刷新
- (void)endRefresh
{
    [self.tableview endFooterRefreshing];
    [self.tableview setFooterState:CCRefreshStateNoMoreData];
}

#pragma mark - 设置tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    EVUserTableViewCell *userCell = [EVUserTableViewCell userTableViewCellWithTableView:tableView];
    userCell.userInfo = self.userInfoArray[indexPath.row];
    userCell.buttonClickBlock = ^(EVUserTableViewCell * cell, UIButton *btn){
        [weakSelf focusPersonWithCell:cell button:btn];
    };
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return userCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVUserTableViewCell *cell = (EVUserTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    EVOtherPersonViewController *otherPersonVC = [EVOtherPersonViewController instanceWithName:cell.userInfo.name];
    otherPersonVC.fromLivingRoom = NO;
    [self.navigationController pushViewController:otherPersonVC animated:YES];
}

#pragma mark - 点击关注按钮
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

#pragma mark - 发出关注请求
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 )
    {
        [self requestwithCell:self.willUnfocusCell button:self.willUnfocusBtn];
    }
}

#pragma mark - 懒加载方法
- (EVBaseToolManager *)engine
{
    if (_engine == nil)
    {
        _engine = [[EVBaseToolManager alloc]init];
    }
    return _engine;
}

- (NSMutableArray *)userInfoArray
{
    if (_userInfoArray == nil)
    {
        _userInfoArray = [NSMutableArray array];
    }
    return _userInfoArray;
}

- (EVLoadingView *)loadingView
{
    if ( !_loadingView )
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:loadingView];
        _loadingView = loadingView;
    }
    
    return _loadingView;
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    
    _tableview.dataSource = nil;
    _tableview.delegate = nil;
    _tableview = nil;
}

@end
