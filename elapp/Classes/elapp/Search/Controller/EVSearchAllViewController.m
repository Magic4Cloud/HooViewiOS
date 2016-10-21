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


#define CCSearchAllViewControllerFooterHeight 40.0f
#define CCSearchAllViewControllerHeaderHeight 30.0f
#define CCSearchAllViewControllerUserCellHeight 75.0f
#define CCSearchAllViewControllerVideoCellHeight 132.5
#define CCSearchAllViewControllerUserID @"CCSearchAllViewControllerUserID"
#define CCSearchAllViewControllerVideoID @"CCSearchAllViewControllerVideoID"

#define kHistoryMaxCount 9
#define kHeaderHeight    35.f

#define kPushHotController  @"pushHotController"

@interface EVSearchAllViewController ()<CCSearchViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, CCDiscoverNowVideoCellDelegate,CCTagsViewDelegate>

@property (weak, nonatomic) UITableView *tableView;  /**< 数据展示列表 */
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

@property (nonatomic, weak) EVNullDataView *nodataView;

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
    
    self.historyArray = [NSMutableArray arrayWithContentsOfFile:self.storyFilePath];
    
    [self addSearchView];
    [self addTableView];
    self.title = kE_More;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideLeftNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
// add by 佳南 to fix home navbar to bottom
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    [CCNotificationCenter removeObserver:self];
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}


#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.view endEditing:YES];
}

#pragma mark - CCSearchViewDelegate

- (void)searchView:(EVSearchView *)searchView didBeginSearchWithText:(nullable NSString *)searchText
{
    
    if ( [searchText isEqualToString:@""] )
    {
        return;
    }
    // 收回键盘
    [searchView endEditting];
    

    self.tagListScrollView.hidden = YES;

    
    // 最多保留5条历史记录
    if ( self.historyArray.count > kHistoryMaxCount )
    {
        [self.historyArray removeLastObject];
    }
    
    // 如果有重复的 先把重复的删掉
    if ( [self.historyArray containsObject:searchText] )
    {
        [self.historyArray removeObject:searchText];
    }
    //  加入历史记录
    [self.historyArray insertObject:searchText atIndex:0];
    // 写入本地
    [self.historyArray writeToFile:self.storyFilePath atomically:YES];
    
    // 处理网络请求
    CCLog(@"---search text:%@", searchText);
    self.lastSearchText = searchText;
    [self.loadingView showLoadingView];
    __weak typeof(self) weakself = self;
    
    [self.engine getSearchInfosWith:searchText type:@"all" start:0 count:kCountNum startBlock:^{
        
    } fail:^(NSError *error) {
        weakself.loadingView.failTitle = kNot_newwork_wrap;
        [weakself.loadingView showFailedViewWithClickBlock:^{
            [weakself searchView:searchView didBeginSearchWithText:weakself.lastSearchText];
        }];
    } success:^(NSDictionary *dict) {
        CCLog(@"dict:%@", dict);
        weakself.searchResult = [EVSearchResultModel objectWithDictionary:dict];
        
        BOOL isNoData = weakself.searchResult.users.count == 0;
        if ( isNoData )
        {
            //            // 显示没有搜索到内容
            weakself.nodataView.hidden = NO;
            [weakself.loadingView destroy];
        }
        else
        {
            // 删除loadingView
            weakself.nodataView.hidden = YES;
            [weakself.loadingView destroy];
            weakself.loadingView = nil;
        }
        
        [weakself.tableView reloadData];
        CGFloat totalHeight =  weakself.searchResult.users.count * CCSearchAllViewControllerUserCellHeight;
        if ( totalHeight < ScreenHeight )
        {
            [weakself.tableView hideFooter];
        }
        else
        {
            [weakself.tableView showFooter];
        }
        
    } sessionExpire:^{
        CCRelogin(weakself);
    } reterrBlock:^(NSString *reterr) {
        weakself.nodataView.hidden = NO;
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
    self.nodataView.hidden = YES;
    [self historyWordArrayCountNotNil];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.searchResult.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak typeof(self) weakself = self;
    EVUserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:CCSearchAllViewControllerUserID];
        if (userCell == nil) {
            userCell = [EVUserTableViewCell userTableViewCellWithTableView:tableView];
        }
        if ( self.searchResult.users.count > indexPath.row ) {
            userCell.userInfo = self.searchResult.users[indexPath.row];
        }
        userCell.selectionStyle = UITableViewCellSelectionStyleNone;
        userCell.buttonClickBlock = ^(EVUserTableViewCell * cell, UIButton *btn){
            [weakself focusPersonWithCell:cell button:btn];
        };
        if ( indexPath.row == (NSInteger)self.searchResult.users.count - 1 )
        {
            userCell.hideBottomLine = YES;
        }
        else
        {
            userCell.hideBottomLine = NO;
        }
    
        return userCell;
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    UIView *header = nil;
    if ( section == 0 && self.searchResult.users.count > 0)
    {
        header = [self getAHeaderViewWithTitle:kE_User];
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( section == 0 && self.searchResult.users.count == 3)
    {
        UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth, CCSearchAllViewControllerFooterHeight)];
        NSString *title = kE_GlobalZH(@"check_more");
        [footer setTitle:title forState:UIControlStateNormal];
        [footer setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
        footer.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:12.0f];
        [footer addTarget:self action:@selector(lookForMore) forControlEvents:UIControlEventTouchUpInside];
        
        [self addTopSeparatorLineToView:footer];
        
        return footer;
    }
    else
    {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    CGFloat headerHeight = .0f;
    if ( section == 0 && self.searchResult.users.count > 0)
    {
        headerHeight = 30.0f;
    }
    
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    CGFloat footerHeight = .0f;
    if ( section == 0 && self.searchResult.users.count == 3)
    {
        footerHeight = 40.0f;
    }
    
    return footerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = .0f;
    if ( indexPath.section == 0 && self.searchResult.users.count > 0)
    {
        height = CCSearchAllViewControllerUserCellHeight;
    }

    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [tableView isEqual:self.historyTableView] )
    {
        NSString *historySearchText = [[self.historyArray objectAtIndex:indexPath.row] mutableCopy];
        [self searchView:self.searchView didBeginSearchWithText:historySearchText];
        self.searchView.text = historySearchText;
        return;
    }
    if ( indexPath.section == 0 && self.searchResult.users.count > 0)
    {
        EVUserTableViewCell *userCell = [tableView cellForRowAtIndexPath:indexPath];
        
        EVOtherPersonViewController *otherPersonVC = [EVOtherPersonViewController instanceWithName:userCell.userInfo.name];
        otherPersonVC.fromLivingRoom = NO;
        [self.navigationController pushViewController:otherPersonVC animated:YES];
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
    CCLog(@"查看更多");
    EVMoreUserInfoViewController *moreUserVC = [[EVMoreUserInfoViewController alloc] init];
    moreUserVC.keyword = self.lastSearchText;
    [self.navigationController pushViewController:moreUserVC animated:YES];
}


#pragma mark - CCDiscoverNowVideoCellDelegate

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
    searchView.placeHolder = kSearch_living_playback_user;
    searchView.placeHolderColor = [UIColor colorWithHexString:@"#bcb3ab"];
    searchView.searchDelegate = self;
    self.searchView = searchView;
    
    self.navigationItem.titleView = searchView;
    [searchView begineEditting];
    
    [searchView layoutIfNeeded];
}

- (void)addTableView
{
    // 设置 view 的背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加展示列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat tablevieTop = 0.f;
    // 设置展示列表的约束
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(tablevieTop, 0, 0, 0)];
    
    // cell 注册
    [tableView registerClass:[EVUserTableViewCell class] forCellReuseIdentifier:CCSearchAllViewControllerUserID];
    [tableView registerClass:[EVDiscoverNowVideoCell class] forCellReuseIdentifier:[EVDiscoverNowVideoCell cellID]];
    
    // tableView 添加底部上拉加载更多
    __weak typeof(self) weakself = self;
    [tableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadMoreDataWithSearchText:weakself.lastSearchText];
    }];
    
    
  
    // 添加历史记录列表
    UITableView *historyTableView = [[UITableView alloc] init];
    [self.view addSubview:historyTableView];
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.hidden = YES;
    [historyTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(tablevieTop, 0, 0, 0)];
    self.historyTableView = historyTableView;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0,0,ScreenWidth, ScreenHeight);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    self.tagListScrollView = scrollView;
    
    [self addTagListView];
    
    EVNullDataView *nodataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-120)];
    [self.view addSubview:nodataView];
    nodataView.hidden = YES;
    self.nodataView = nodataView;
    nodataView.topImage = [UIImage imageNamed:@"home_pic_findempty"];
    nodataView.title = kSearch_notData_title;
    nodataView.subtitle = nil;
    nodataView.buttonTitle = kTo_hot_see;
    [nodataView addButtonTarget:self action:@selector(nodataViewButton:) forControlEvents:(UIControlEventTouchDown)];
    
}

- (void)nodataViewButton:(UIButton *)btn
{
    
    [CCNotificationCenter postNotificationName:kPushHotController object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 热搜词
- (void)addTagListView
{

    UIButton *historyView = [self getButtonWithTitle:kSearch_history image:@"search_icon_record" buttonFrame:CGRectMake(15, 0, ScreenWidth, kHeaderHeight)];
    [self.tagListScrollView addSubview:historyView];
    _historyButton = historyView;
    
    EVTagListView *historyTagListView = [[EVTagListView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(historyView.frame), ScreenWidth, 0)];
    historyTagListView.type = 0;
    [self.tagListScrollView addSubview:historyTagListView];
    historyTagListView.backgroundColor = [UIColor whiteColor];
    _historyTagListView = historyTagListView;
    _historyTagListView.tagDelegate  = self;
    
    [self.historyTagListView setTagAry:self.historyArray];
    self.clearButton.hidden = self.historyArray.count == 0 ? YES : NO;
    
    self.tagListScrollView.contentSize = CGSizeMake(ScreenWidth, historyTagListView.frame.origin.y+historyTagListView.frame.size.height+140);
}

- (void)historyWordArrayCountNotNil
{
    [self.historyTagListView setTagAry:self.historyArray];
    self.historyTagListView.hidden = self.historyArray.count == 0 ? YES : NO;
    self.clearButton.hidden = self.historyArray.count == 0 ? YES : NO;
    [self.historyTagListView reloadData];
    self.tagListScrollView.contentSize = CGSizeMake(ScreenWidth, _historyTagListView.frame.origin.y+_historyTagListView.frame.size.height+140);
    self.tableFooter.frame = CGRectMake(0, _historyTagListView.frame.origin.y+_historyTagListView.frame.size.height, ScreenWidth, 60.f);
}

- (void)tagsViewButtonAction:(EVTagListView *)tagsView button:(UIButton *)sender
{
    NSString *historySearchText = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
    [self searchView:self.searchView didBeginSearchWithText:historySearchText];
    self.searchView.text = historySearchText;
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
    titleLbl.font = [[CCAppSetting shareInstance] normalFontWithSize:14.0f];
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
    topSeparatorLine.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
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
    bottomSeparatorLine.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
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
        CCRelogin(weakself);
    }];
}

- (void)loadMoreDataWithSearchText:(NSString *)searchText
{
    // 加保护，如果处于刷新状态则不再发送网络请求
    if ( self.isRequsting )
    {
        return;
    }
    
    // 发送网络请求
    __weak typeof(self) weakself = self;
    [self.engine getSearchInfosWith:searchText type:@"users" start:self.searchResult.user_next count:kCountNum startBlock:^{
        weakself.isRequsting = YES;
    } fail:^(NSError *error) {
        [weakself.tableView endFooterRefreshing];
        weakself.isRequsting = NO;
    } success:^(NSDictionary *dict) {
        // mob click fix by 马帅伟
        
        [weakself.tableView endFooterRefreshing];
        weakself.isRequsting = NO;
        EVSearchResultModel *new = [EVSearchResultModel objectWithDictionary:dict];
        if ( new.users && new.users.count > 0 )
        {
            [weakself.searchResult.users addObjectsFromArray:new.users];
            weakself.searchResult.user_next = new.user_next;
            [weakself.tableView reloadData];
        }
        
        // 下拉加载更多
        if ( new.users.count < kCountNum )
        {
            [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
        }
        else
        {
            [weakself.tableView setFooterState:CCRefreshStateIdle];
        }
        
    } sessionExpire:^{
        CCRelogin(weakself);
        [weakself.tableView endFooterRefreshing];
        weakself.isRequsting = NO;
        CCRelogin(weakself);
    } reterrBlock:^(NSString *reterr) {
        
        self.nodataView.hidden  = NO;
        
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

- (NSMutableArray *)historyArray
{
    if ( _historyArray == nil )
    {
        self.historyArray
        = [NSMutableArray arrayWithCapacity:10];
    }
    return _historyArray;
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
