//
//  EVFantuanContributionListVC.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFantuanContributionListVC.h"
#import "EVFantuanContributorModel.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVFantuanContributorTableViewCell.h"
#import "EVFantuanTop3View.h"
#import <PureLayout/PureLayout.h>
#import "UIScrollView+GifRefresh.h"
#import "EVOtherPersonViewController.h"

@interface EVFantuanContributionListVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求管理模块 */
@property (strong, nonatomic) NSMutableArray *contributorsArrM; /**< 贡献者 */
@property (weak, nonatomic) UITableView *tableView;  /**< 贡献者排行榜列表 */
@property (weak, nonatomic) EVFantuanTop3View *top3V;  /**< 贡献者排名前三的展示视图 */

@property (assign, nonatomic) NSInteger lastNext; /**< 上次的下次取数据的开始值 */

@end

@implementation EVFantuanContributionListVC

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpUI];
    [self getDataWithName:self.name Start:0];
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
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = (NSInteger)self.contributorsArrM.count - 3;
    if ( num < 0 )
    {
        num = 0;
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVFantuanContributorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[EVFantuanContributorTableViewCell cellID]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexNum = indexPath.row + 4;
    if ( indexPath.row + 3 <= self.contributorsArrM.count )
    {
        cell.model = self.contributorsArrM[indexPath.row + 3];
    }
    __weak typeof(self) weakself = self;
    if (self.isAnchor == NO) {
        cell.logoClicked = ^(EVFantuanContributorModel *model){
            EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc]init];
            otherVC.name = [model.name mutableCopy];
            otherVC.fromLivingRoom = NO;
            [weakself.navigationController pushViewController:otherVC animated:YES];
        };
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}


#pragma mark - private methods

- (void)getDataWithName:(NSString *)name Start:(NSInteger)startNum
{
    if ( ![name isKindOfClass:[NSString class]] || name.length <= 0 )
    {
        return;
    }
    
    [self.engine cancelAllOperation];
    [self.tableView endHeaderRefreshing];
    [self.tableView endFooterRefreshing];
    __weak typeof(self) weakself = self;
    [self.engine GETContributorWithUserName:name startNum:startNum count:kCountNum start:^{
        
    } fail:^(NSError *error) {
        [weakself.tableView endFooterRefreshing];
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView setFooterState:CCRefreshStateIdle];
    } success:^(NSDictionary *info) {
        if (startNum == 0)
        {
            [weakself.contributorsArrM removeAllObjects];
        }
        [weakself.tableView endFooterRefreshing];
        [weakself.tableView endHeaderRefreshing];
        NSNumber *next = info[kNext];
        NSNumber *cc_StartNum = info[kStart];
        weakself.lastNext = [next integerValue];
        NSArray *users = info[kUserKey];
        NSArray *modelUsers = [EVFantuanContributorModel objectWithDictionaryArray:users];
        
        if ( [cc_StartNum integerValue] >= [next integerValue])
        {
            [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
        }
        else
        {
            [weakself.tableView setFooterState:CCRefreshStateIdle];
        }
        
        NSMutableArray *modelArray = [NSMutableArray arrayWithArray:modelUsers];
        
        for (NSUInteger i = 0;i < modelUsers.count; i++) {
                
                EVFantuanContributorModel *fanTuanModel = modelUsers[i];
                
                for (NSUInteger i = 0 ; i < weakself.contributorsArrM.count ; i++) {
                    
                    EVFantuanContributorModel *model = weakself.contributorsArrM[i];
                    
                    if ([model.name isEqualToString:fanTuanModel.name]) {
                        
                        [modelArray removeObject:fanTuanModel];
                        
                    }else{
                        
                        
                    }

                }
                
            }
           
        [weakself.contributorsArrM addObjectsFromArray:modelArray];
        
        if ( startNum == 0 )
        {
            if ( weakself.contributorsArrM.count <= 3 )
            {
                weakself.top3V.top3Contributors = [NSArray arrayWithArray:weakself.contributorsArrM];
            }
            else
            {
                NSMutableArray *tempArrM = [NSMutableArray array];
                for (EVFantuanContributorModel *model in weakself.contributorsArrM)
                {
                    [tempArrM addObject:model];
                    if ( tempArrM.count >= 3 )
                    {
                        break;
                    }
                }
                weakself.top3V.top3Contributors = tempArrM;
            }
        }
        [weakself.tableView reloadData];
    } sessionExpire:^{
        [weakself.tableView endFooterRefreshing];
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView setFooterState:CCRefreshStateIdle];
    }];
}

- (void)setUpUI
{
    self.title = kE_GlobalZH(@"ticket_rank_list");
    
    UIView *containerV = [[UIView alloc] init];
    [self.view addSubview:containerV];
    [containerV autoPinEdgesToSuperviewEdges];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor evBackgroundColor];
    [containerV addSubview:tableView];
    self.tableView = tableView;
    [tableView autoPinEdgesToSuperviewEdges];
    [tableView registerClass:[EVFantuanContributorTableViewCell class] forCellReuseIdentifier:[EVFantuanContributorTableViewCell cellID]];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addRefresh];
    
    EVFantuanTop3View *top3V = [[EVFantuanTop3View alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth, (10+137.5+115+102+8))];
    tableView.tableHeaderView = top3V;
    self.top3V = top3V;
    __weak typeof(self) weakself = self;
    if (self.isAnchor == NO) {
        top3V.logoClicked = ^(EVFantuanContributorModel *model){
            EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc]init];
            otherVC.name = [model.name mutableCopy];
            otherVC.fromLivingRoom = NO;
            [weakself.navigationController pushViewController:otherVC animated:YES];
        };
    }
   
}

- (void)addRefresh
{
    __weak typeof(self) weakself = self;
    [self.tableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself getDataWithName:weakself.name Start:0];
    }];
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        [weakself getDataWithName:weakself.name Start:weakself.lastNext];
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

- (NSMutableArray *)contributorsArrM
{
    if ( !_contributorsArrM )
    {
        _contributorsArrM = [NSMutableArray array];
    }
    
    return _contributorsArrM;
}

@end
