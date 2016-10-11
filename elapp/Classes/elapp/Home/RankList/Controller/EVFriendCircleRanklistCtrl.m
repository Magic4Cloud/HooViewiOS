//
//  EVFriendCircleRanklistCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFriendCircleRanklistCtrl.h"
#import <PureLayout.h>
#import "EVFriendCircleRanklistCell.h"
#import "EVHomeTabbar.h"
#import "UIScrollView+GifRefresh.h"
#import "EVBaseToolManager+EVDiscoverAPI.h"
#import "EVLoadingView.h"
#import "EVFriendCircleRanklistMoreCtrl.h"
#import "EVOtherPersonViewController.h"
#import "EVSegmentView.h"
#import "EVNullDataView.h"


#define kListTypeAll    @"all"

@interface EVFriendCircleRanklistCtrl () <UITableViewDelegate, UITableViewDataSource,EVSegmentDelegate>

@property (nonatomic, weak) UITableView *mTableView;
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (assign, nonatomic) CGPoint oldPoint;
@property (nonatomic, strong) EVFriendCircleRanklistModel *ranklistModel;
@property (nonatomic, weak) EVLoadingView *loadingView;

@property (nonatomic, assign) NSInteger segmentInteger;

@property ( weak, nonatomic ) EVNullDataView *nullDataView;     /**< 空数据时覆盖的视图 */

@end

@implementation EVFriendCircleRanklistCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self mainView];
    
    //
    [self setNotification];
    
    //
    [self loadDataInteger:2];
    
    //
    [self addObserver];
    
    [self setUpNullData];
    //
    __weak typeof(self) weakSelf = self;
    [self.mTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakSelf loadDataInteger:2];
    }];
}

- (void)setUpNullData
{
    // 空数据视图
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 105, ScreenWidth, ScreenHeight - HOMETABBAR_HEIGHT)];
    [self.view addSubview:nullDataView];
    nullDataView.topImage = [UIImage imageNamed:@"home_pic_leaderboard_blank"];
    self.nullDataView = nullDataView;
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    [CCNotificationCenter removeObserver:self];
    [_mTableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (EVLoadingView *)loadingView
{
    if (!_loadingView)
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] initWithFrame:CGRectMake(0,138, ScreenWidth, ScreenHeight-138)];
        [self.view addSubview:loadingView];
        _loadingView = loadingView;
    }
    return _loadingView;
}



- (void)mainView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor evBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(CCHOMENAV_HEIGHT, 0, HOMETABBAR_HEIGHT, 0);
    [tableView setContentOffset:CGPointMake(0, -CCHOMENAV_HEIGHT) animated:YES];
    [self.view addSubview:tableView];
    [tableView autoPinEdgesToSuperviewEdges];
    self.mTableView = tableView;
    
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.ranklistModel.send_rank_list.count;
        case 1:
            return self.ranklistModel.receive_rank_list.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, 50.f)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //
    NSString *text = kE_GlobalZH(@"coinRank");
    NSString *imgName = @"home_leaderboard_pic_coin";
    if (section) {
        imgName = @"home_leaderboard_pic_diamond";
        text = kE_GlobalZH(@"diamondRank");
    }
    
    UILabel *dividingLine = [[UILabel alloc] init];
    dividingLine.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    [headerView addSubview:dividingLine];
    [dividingLine autoSetDimension:ALDimensionHeight toSize:1.f];
    [dividingLine autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [dividingLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView];
    [dividingLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView];

    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [headerView addSubview:imgView];
    imgView.backgroundColor = [UIColor whiteColor];
    [imgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:17.f];
    [imgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:headerView];


    
    //
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor evTextColorH2];
    label.text = text;
    [headerView addSubview:label];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:55.f];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, 40.f + 10.f)];
    footerView.backgroundColor = [UIColor evBackgroundColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, 40.f)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:kE_GlobalZH(@"check_more") forState:UIControlStateNormal];
    button.titleLabel.font = CCBoldFont(13);
    [button setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
    button.tag = 1000 + section;
    [button addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    //
    UILabel *dividingLine = [[UILabel alloc] init];
    dividingLine.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    [footerView addSubview:dividingLine];
    [dividingLine autoSetDimension:ALDimensionHeight toSize:1.f];
    [dividingLine autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [dividingLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView];
    [dividingLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:footerView];
    
    return footerView;
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
    if (indexPath.section) {
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
    
    if (indexPath.row == 4) {
        cell.dividingLine.hidden = YES;
    } else {
        cell.dividingLine.hidden = NO;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc] init];
    otherVC.fromLivingRoom = NO;
    if (indexPath.section) {
        CCFriendCircleRanklistReceiveModel *model = self.ranklistModel.receive_rank_list[indexPath.row];
        otherVC.name = model.name;
    } else {
        CCFriendCircleRanklistSendModel *model = self.ranklistModel.send_rank_list[indexPath.row];
        otherVC.name = model.name;
    }
    
    [self.navigationController pushViewController:otherVC animated:YES];
}

#pragma mark - load data
- ( void ) loadDataInteger:(NSInteger)integer
{
    __weak typeof(self) weakSelf = self;
    // 获取当前的请求类型
    NSString *type = [NSString stringWithFormat:@"%@",kListTypeAll];

    [self.engine GETObtainAssetsranklist:0 count:5 type:type start:^{
        if ( !weakSelf.ranklistModel.send_rank_list.count )
        {
            [weakSelf.loadingView showLoadingView];
        }
    } fail:^(NSError *error) {
        [weakSelf.mTableView setHeaderState:CCRefreshStateIdle];
        weakSelf.mTableView.scrollEnabled  = NO;
        [weakSelf.loadingView showFailedViewWithClickBlock:^{
            weakSelf.mTableView.scrollEnabled = YES;
            [weakSelf loadDataInteger:integer];
        }];
    } success:^(NSDictionary *messageData) {
        [weakSelf.loadingView destroy];
        weakSelf.ranklistModel = [EVFriendCircleRanklistModel objectWithDictionary:messageData];
        if (weakSelf.ranklistModel.send_rank_list.count == 0 && weakSelf.ranklistModel.receive_rank_list.count == 0) {
            weakSelf.nullDataView.hidden = NO;
        }else{
            weakSelf.nullDataView.hidden = YES;
        }
        [weakSelf.mTableView setHeaderState:CCRefreshStateIdle];
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

#pragma mark - 监听tableview的滑动
- (void)addObserver
{

    [self.mTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionNew context:NULL];
}

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

#pragma mark - notification
- (void)setNotification
{

    [CCNotificationCenter addObserver:self selector:@selector(receiveSessionUpdate) name:CCSessionIdDidUpdateNotification object:nil];
}

- (void)receiveSessionUpdate
{
    [self loadDataInteger:2];
}


#pragma mark - button action
- (void) moreButtonAction:(UIButton *)sender
{
    EVFriendCircleRanklistMoreCtrl *ctrl = [EVFriendCircleRanklistMoreCtrl new];
    NSString *type = [NSString stringWithFormat:@"%@",kListTypeAll];
    NSMutableString *moreType = [type mutableCopy];
    if (sender.tag == 1000) {
        [moreType replaceCharactersInRange:NSMakeRange(type.length - 3, 3) withString:@"send"];
    } else {
        [moreType replaceCharactersInRange:NSMakeRange(type.length - 3, 3) withString:@"receive"];
    }
    ctrl.type = moreType;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}


@end
