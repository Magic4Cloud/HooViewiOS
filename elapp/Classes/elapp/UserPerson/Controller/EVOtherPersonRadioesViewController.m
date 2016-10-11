//
//  EVOtherPersonRadioesViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVOtherPersonRadioesViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import <PureLayout.h>
#import "UIScrollView+GifRefresh.h"
#import "EVOtherPersonVideoTableViewCell.h"
#import "EVUserVideoModel.h"
#import "EVLoadingView.h"
#import "UIViewController+Extension.h"
#import "EVWatchVideoInfo.h"
#import "EVNullDataView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

@interface EVOtherPersonRadioesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UIView *containerView;  /**< 容器视图 */
@property (weak, nonatomic) UITableView *tableView;  /**< 列表视图 */
@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求管理模块 */
@property (strong, nonatomic) NSMutableArray *audioes; /**< 音频数组 */
@property (weak, nonatomic) EVLoadingView *loadingView;  /**< 默认刷新动画 */

@property (weak, nonatomic) UIView *noDataView;  /**< 无数据时显示的视图 */

@property (weak, nonatomic) UIButton *backTopBtn;  /**< 返回顶部小火箭 */

@end

@implementation EVOtherPersonRadioesViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kE_GlobalZH(@"living_audio");
    
    // 自定义视图
    [self setUpUI];
    [self getVidedesDataWithName:self.userName start:0 count:kCountNum];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    _audioes = nil;
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.audioes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVOtherPersonVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[EVOtherPersonVideoTableViewCell cellID]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EVUserVideoModel *audioModel = nil;
    if ( indexPath.row < self.audioes.count )
    {
        audioModel = self.audioes[indexPath.row];
    }
    cell.model = audioModel;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVOtherPersonVideoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *vid = cell.model.vid;
    if ( vid && ![vid isEqualToString:@""] )
    {
        EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
        videoInfo.vid = vid;
        videoInfo.password = cell.model.password;
        videoInfo.mode = cell.model.mode;
        videoInfo.play_url = cell.model.play_url;
        videoInfo.thumb = cell.model.thumb;
        [self playVideoWithVideoInfo:videoInfo permission:cell.model.permission];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.backTopBtn.hidden = scrollView.contentOffset.y > 0 ? NO : YES;
    self.backTopBtn.alpha = (scrollView.contentOffset.y - ScreenWidth) / ScreenWidth;
}


#pragma mark - event response

- (void)backToTop
{
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.contentOffset = CGPointMake(0, 1);
    }];
}


#pragma mark - private methods

/**
 *  根据用户的云播号，获取用户的音频列表
    当前不考虑偏移量的情况下，可以使用当前列表的数量作为start值进行请求，但最好做去重的处理。
 *
 *  @param name  云播号
 */
- (void)getVidedesDataWithName:(NSString *)name start:(NSInteger)start count:(NSInteger)count
{
    if (self.audioes.count == 0)
    {
        [self.loadingView showLoadingView];
    }
    
    __weak typeof(self) weakself = self;
    [self.engine GETUserVideoListWithName:name type:@"audio" start:start count:count startBlock:^{
        
    } fail:^(NSError *error) {
        if ( weakself.audioes.count <= 0 )
        {
            [weakself.loadingView showFailedViewWithClickBlock:^{
                [weakself getVidedesDataWithName:weakself.userName start:0 count:kCountNum];
            }];
        }
        
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        // TO DO :
        
    } success:^(NSArray *audioes) {
        [weakself.loadingView destroy];
        weakself.loadingView = nil;
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        
        if (start == 0)
        {
            weakself.audioes = nil;
        }
        
        [weakself.audioes addObjectsFromArray:audioes];
        [weakself.tableView reloadData];
        
        if ( weakself.audioes.count > 0 )
        {
            weakself.noDataView.hidden = YES;
            [weakself.noDataView removeFromSuperview];
        }
        else
        {
            weakself.noDataView.hidden = NO;
        }
        
        
        // 处理数据列表为空的情况，当前页面显示为没有视频
        //        weakself.tableView.footer.hidden = weakself.videos.count ? NO : YES;
        if ( weakself.audioes.count )
        {
            [weakself.tableView showFooter];
        }
        else
        {
            [weakself.tableView hideFooter];
        }
        if (weakself.audioes.count) {
            if (audioes.count < count) {
                [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
            } else {
                [weakself.tableView setFooterState:CCRefreshStateIdle];
            }
            //数据没有满一频目的时候盈藏加载更多
            if((ScreenHeight - 64.0f) / 96.0f > weakself.audioes.count && audioes.count < count)
            {
                [weakself.tableView hideFooter];
            }else
            {
                [weakself.tableView showFooter];
            }
            
        }
    } essionExpire:^{
        if ( weakself.audioes.count <= 0 )
        {
            [weakself.loadingView showFailedViewWithClickBlock:^{
                [weakself getVidedesDataWithName:weakself.userName start:0 count:kCountNum];
            }];
        }
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        
        CCRelogin(weakself);
    }];
}

/**
 *  构建自定义视图
 */
- (void)setUpUI
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:containerView];
    containerView.backgroundColor = [UIColor evBackgroundColor];
    [containerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.containerView = containerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.containerView addSubview:tableView];
    tableView.backgroundColor = [UIColor evBackgroundColor];
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.rowHeight = 96.0f;
    [tableView registerNib:[UINib nibWithNibName:@"EVOtherPersonVideoTableViewCell" bundle:nil] forCellReuseIdentifier:[EVOtherPersonVideoTableViewCell cellID]];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    __weak typeof(self) weakSelf = self;
    [tableView addRefreshHeaderWithRefreshingBlock:^{
        [weakSelf getVidedesDataWithName:weakSelf.userName start:0 count:kCountNum];
    }];
    [tableView addRefreshFooterWithRefreshingBlock:^{
        [weakSelf getVidedesDataWithName:weakSelf.userName start:weakSelf.audioes.count count:kCountNum];
    }];
}


#pragma mark - getters and setters

- (EVBaseToolManager *)engine
{
    if ( !_engine )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (NSMutableArray *)audioes
{
    if ( !_audioes )
    {
        _audioes = [NSMutableArray array];
    }
    
    return _audioes;
}

- (EVLoadingView *)loadingView
{
    if (!_loadingView)
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:loadingView];
        [loadingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        _loadingView = loadingView;
    }
    return _loadingView;
}

- (UIView *)noDataView {
    if (!_noDataView)
    {

        EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.tableView.bounds.size.height - 64.f)];
        nullDataView.backgroundColor = CCBackgroundColor;
        [self.tableView addSubview:nullDataView];
        nullDataView.topImage = [UIImage imageNamed:@"home_pic_findempty"];
        nullDataView.title = kE_GlobalZH(@"null_data");
        self.noDataView = nullDataView;
    }
    
    return _noDataView;
}

- (UIButton *)backTopBtn
{
    if ( !_backTopBtn )
    {
        _backTopBtn = [self addBackToTopButtonToSuperView:self.view OffsetYToBottom:.0f action:@selector(backToTop)];
    }
    
    return _backTopBtn;
}

@end
