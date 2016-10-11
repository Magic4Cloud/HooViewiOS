//
//  EVFriendCircleRanklistMoreCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFriendCircleRanklistMoreCtrl.h"
#import <PureLayout.h>
#import "EVFriendCircleRanklistCell.h"
#import "UIScrollView+GifRefresh.h"
#import "EVBaseToolManager+EVDiscoverAPI.h"
#import "EVLoadingView.h"
#import "EVOtherPersonViewController.h"


@interface EVFriendCircleRanklistMoreCtrl () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITableView *mTableView;
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (assign, nonatomic) CGPoint oldPoint;
@property (nonatomic, strong) EVFriendCircleRanklistModel *ranklistModel;
@property (nonatomic, weak) EVLoadingView *loadingView;

@end

@implementation EVFriendCircleRanklistMoreCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isReceive]) {
        self.title = kE_GlobalZH(@"diamondRank");
    } else {
        
        self.title = kE_GlobalZH(@"coinRank");
    }
    
    //
    [self mainView];
    
    //
    [self setNotification];
    
    //
    [self loadDataStart:0 more:NO];
    
    // fix by 赵文霖 已修改
    __weak typeof(self) weakSelf = self;
    [self.mTableView addRefreshHeaderWithRefreshingBlock:^{
        if ( weakSelf.mTableView.isTableViewFooterRefreshing )
        {
            [weakSelf.engine cancelAllOperation];
        }
        
        [weakSelf.mTableView endFooterRefreshing];
        [weakSelf loadDataStart:0 more:NO];
    }];
    
    [self.mTableView addRefreshFooterWithRefreshingBlock:^{
        if ( weakSelf.mTableView.isTableViewHeaderRefreshing )
        {
            [weakSelf.engine cancelAllOperation];
        }
        
        [weakSelf.mTableView endHeaderRefreshing];
        [weakSelf loadDataStart:weakSelf.ranklistModel.next more:YES];
    }];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    [CCNotificationCenter removeObserver:self];
    
    _mTableView.dataSource = nil;
    _mTableView.delegate = nil;
    _mTableView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (EVLoadingView *)loadingView
{
    if (!_loadingView)
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:loadingView];
        _loadingView = loadingView;
    }
    return _loadingView;
}

- (void)mainView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = CCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView autoPinEdgesToSuperviewEdges];
    self.mTableView = tableView;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isReceive]) {
        return self.ranklistModel.receive_rank_list.count;
    } else {
        return self.ranklistModel.send_rank_list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifierKey";
    EVFriendCircleRanklistCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( !cell )
    {
        cell = [[EVFriendCircleRanklistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self isReceive]) {
        cell.receiveModel = self.ranklistModel.receive_rank_list[indexPath.row];
    } else {
        cell.sendModel = self.ranklistModel.send_rank_list[indexPath.row];
    }
    
    cell.ranklistImg.hidden = NO;
    cell.ranklistLabel.hidden = YES;
    if (indexPath.row == 0) {
        cell.ranklistImg.image = [UIImage imageNamed:@"home_leaderboard_pic_rankingone"];
    } else if (indexPath.row == 1){
        cell.ranklistImg.image = [UIImage imageNamed:@"home_leaderboard_pic_rankingtwo"];
    } else if (indexPath.row == 2){
        cell.ranklistImg.image = [UIImage imageNamed:@"home_leaderboard_pic_rankingthree"];
    } else {
        cell.ranklistLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
        cell.ranklistImg.hidden = YES;
        cell.ranklistLabel.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc] init];
    otherVC.fromLivingRoom = NO;
    if ([self isReceive]) {
        CCFriendCircleRanklistReceiveModel *model = self.ranklistModel.receive_rank_list[indexPath.row];
        otherVC.name = model.name;
    } else {
        CCFriendCircleRanklistSendModel *model = self.ranklistModel.send_rank_list[indexPath.row];
        otherVC.name = model.name;
    }
    
    [self.navigationController pushViewController:otherVC animated:YES];
}

- (BOOL) isReceive
{
    return [self.type isEqualToString:@"send"] ? NO : YES;
}

#pragma mark - load data
- ( void )loadDataStart:(NSInteger)start more:(BOOL) more
{
    NSInteger count = 20;
    __weak typeof(self) weakSelf = self;
    [self.engine GETObtainAssetsranklist:start count:count type:self.type start:^{
        
        BOOL flag = NO;
        if ([weakSelf isReceive]) {
            if ( !weakSelf.ranklistModel.receive_rank_list.count ) {
                flag = YES;
            }
        } else {
            if ( !weakSelf.ranklistModel.send_rank_list.count ) {
                flag = YES;
            }
        }
        
        if ( flag )
        {
            [weakSelf.loadingView showLoadingView];
        }
    } fail:^(NSError *error) {
        [weakSelf.mTableView setHeaderState:CCRefreshStateIdle];
        [weakSelf.mTableView setFooterState:CCRefreshStateIdle];
        [weakSelf.loadingView showFailedViewWithClickBlock:^{
            [weakSelf loadDataStart:0 more:NO];
        }];
    } success:^(NSDictionary *messageData) {
        [weakSelf.loadingView destroy];
        [weakSelf.mTableView setHeaderState:CCRefreshStateIdle];
        
        EVFriendCircleRanklistModel *model = [EVFriendCircleRanklistModel objectWithDictionary:messageData];
        if ( more == NO)
        {
            weakSelf.ranklistModel = model;
        }
        else
        {
            //
            weakSelf.ranklistModel.start = model.start;
            weakSelf.ranklistModel.count = model.count;
            weakSelf.ranklistModel.next = model.next;
            
            if ([weakSelf isReceive]) {
                [weakSelf.ranklistModel.receive_rank_list addObjectsFromArray:model.receive_rank_list];
                
                if ( model.receive_rank_list.count < count )
                {
                    [weakSelf.mTableView setFooterState:CCRefreshStateNoMoreData];
                } else {
                    [weakSelf.mTableView setFooterState:CCRefreshStateIdle];
                }
                
            } else {
                [weakSelf.ranklistModel.send_rank_list addObjectsFromArray:model.send_rank_list];
                
                if ( model.send_rank_list.count < count )
                {
                    [weakSelf.mTableView setFooterState:CCRefreshStateNoMoreData];
                } else {
                    [weakSelf.mTableView setFooterState:CCRefreshStateIdle];
                }
            }
        }
        
        if (weakSelf.ranklistModel.receive_rank_list.count == 0 && weakSelf.ranklistModel.receive_rank_list.count == 0) {
            
        }else{
            
        }
        
        [weakSelf.mTableView reloadData];
    } sessionExpire:^{
        CCRelogin(weakSelf);
    }];
}

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

#pragma mark - notification
- (void)setNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(receiveSessionUpdate) name:CCSessionIdDidUpdateNotification object:nil];
}


- (void)receiveSessionUpdate
{
    [self loadDataStart:0 more:NO];
}

@end
