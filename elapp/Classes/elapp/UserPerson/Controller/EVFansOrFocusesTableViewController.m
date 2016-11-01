//
//  EVFansOrFocusesTableViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFansOrFocusesTableViewController.h"
#import "EVFansOrFocusTableViewCell.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVFanOrFollowerModel.h"
#import "UIScrollView+GifRefresh.h"
#import "EVOtherPersonViewController.h"
#import "EVLoadingView.h"
#import "EVLoginInfo.h"
#import "EVNullDataView.h"
#import "EVHomeViewController.h"
#import "UIViewController+Extension.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#define tabandNav 113;
#define cellsize 64
static const NSString *const fansOrFocusCellID = @"fansOrFocus";

@interface EVFansOrFocusesTableViewController ()

@property (strong, nonatomic) NSMutableArray *fansOrFollowers;
@property (strong, nonatomic) EVBaseToolManager *engine;
@property (weak, nonatomic) UIView *noDataView;
@property (assign, nonatomic) NSInteger times;         // 据此判断，如果是加载更多或下拉刷新，则indicator不出现

@property (weak, nonatomic) EVLoadingView *loadingView; /**< 加载视图 */

@end

@implementation EVFansOrFocusesTableViewController

@synthesize times;

#pragma mark - life circle

- (instancetype)init{
    self = [super init];
    
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.times = 0;
    [self addNotification];
    [self setUI];
    [self loadDataWithname:self.name Start:0 count:kCountNum];
    self.noDataView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    
    [_engine cancelAllOperation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _engine = nil;
    _fansOrFollowers = nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fansOrFollowers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EVFansOrFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)fansOrFocusCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = self.type;
    if ( indexPath.row >= self.fansOrFollowers.count )
    {
        return cell;
    }
    EVFanOrFollowerModel *fanOrFollower = self.fansOrFollowers[indexPath.row];
    CCLog(@"[indexPath.row]:%@, model:%@", self.fansOrFollowers[indexPath.row], fanOrFollower);
    cell.model = fanOrFollower;
    __weak typeof(self) weakself = self;
    cell.iconClick = ^(EVFanOrFollowerModel *model){
        EVOtherPersonViewController *otherPersonVC = [EVOtherPersonViewController instanceWithName:model.name];
        otherPersonVC.fromLivingRoom = NO;
        [weakself.navigationController pushViewController:otherPersonVC animated:YES];
    };
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVFansOrFocusTableViewCell *cell = (EVFansOrFocusTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    EVOtherPersonViewController *otherPersonVC = [EVOtherPersonViewController instanceWithName:cell.model.name];
    otherPersonVC.fromLivingRoom = NO;
    [self.navigationController pushViewController:otherPersonVC animated:YES];
}


#pragma mark - Notifications

- (void)changeRemark:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    
    // 遍历当前数组中的model，是否有相同name的，如果有，则其remarks属性值都做相应更改
    NSString *editedPersonName = dict[kNameKey];
    NSString *editedPersonRemarks = dict[kRemarks];
    
    for (EVFanOrFollowerModel *model in self.fansOrFollowers)
    {
        if ( [model.name isEqualToString:editedPersonName] )
        {
            model.remarks = editedPersonRemarks;
        }
    }
    
    // 刷新数据列表
    [self.tableView reloadData];
}


#pragma mark - private methods

- (void)setUI{
    switch (self.type)
    {
        case FANS:
        {
            self.title = kE_GlobalZH(@"e_fans");
        }
            break;
            
        case FOCUSES:
        {
            self.title = kE_GlobalZH(@"navigationBarFollow");
        }
            break;
            
        default:
            break;
    }
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    self.tableView.backgroundColor = [UIColor evBackgroundColor];
    self.tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    self.tableView.rowHeight = 67.0f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVFansOrFocusTableViewCell" bundle:nil] forCellReuseIdentifier:(NSString *)fansOrFocusCellID];
    __weak typeof(self) weakself = self;
    [self.tableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadDataWithname:weakself.name Start:0 count:kCountNum];
    }];
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadDataWithname:weakself.name Start:weakself.fansOrFollowers.count count:kCountNum];
    }];
    [self.tableView hideFooter];
}

- (void)loadDataWithname:(NSString *)name Start:(NSInteger)start count:(NSInteger)count{
    __weak typeof(self) weakself = self;
    switch (self.type)
    {
        case FANS:
        {
            if (times < 1)
            {
                //                    [CCProgressHUD showProgressMumWithClearColorToView:weakself.view];
                [self.loadingView showLoadingView];
            }
            
             times ++;
            [self.engine GETFansListWithName:name startID:start count:count start:^{

                
               
            } fail:^(NSError *error) {
                [weakself.tableView endHeaderRefreshing];
                [weakself.tableView endFooterRefreshing];
                [weakself.loadingView showFailedViewWithClickBlock:^{
                    [weakself loadDataWithname:name Start:start count:count];
                }];
            } success:^(NSArray *fans){
                [weakself.loadingView destroy];
                
                if (start == 0) {
                    weakself.fansOrFollowers = nil;
                }
                
                [weakself.fansOrFollowers addObjectsFromArray:fans];
                [weakself.tableView reloadData];
                [weakself.tableView endHeaderRefreshing];
                [weakself.tableView endFooterRefreshing];
                
                // 处理数据列表为空的情况，当前页面显示为没有粉丝
                if ( weakself.fansOrFollowers.count )
                {
                    [weakself.tableView showFooter];
                }
                else
                {
                    [weakself.tableView hideFooter];
                }
                
                if (weakself.fansOrFollowers.count)
                {
                    weakself.noDataView.hidden = YES;
                    [weakself.noDataView removeFromSuperview];
                    
                    if (fans.count < count)
                    {
                        [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
                    }
                    else
                    {
                        [weakself.tableView setFooterState:CCRefreshStateIdle];
                    }
                    //数据没有满一屏幕的时候隐藏加载更多
                    if((ScreenHeight - cellsize) / cellsize >= weakself.fansOrFollowers.count && fans.count < count)
                    {
                        [weakself.tableView hideFooter];
                    }else
                    {
                        [weakself.tableView showFooter];
                    }
                }
                else
                {
                    weakself.noDataView.hidden = NO;
                }
            } essionExpire:^{
//                [CCProgressHUD hideHUDForView:weakself.view];
                [weakself.loadingView showFailedViewWithClickBlock:^{
                    [weakself loadDataWithname:name Start:start count:count];
                }];
                [weakself.tableView endHeaderRefreshing];
                [weakself.tableView endFooterRefreshing];
                CCRelogin(weakself);
            }];
        }
            break;
            
        case FOCUSES:{
            if (times < 1)
            {
                //                    [CCProgressHUD showProgressMumWithClearColorToView:weakself.view];
                [self.loadingView showLoadingView];
            }
            
            times ++;
            [self.engine GETFollowersListWithName:name startID:start count:count start:^{
//                static NSInteger times = 0;         // 据此判断，如果是加载更多或下拉刷新，则indicator不出现
                
                
            } fail:^(NSError *error) {
//                [CCProgressHUD hideHUDForView:weakself.view];
                [weakself.tableView endHeaderRefreshing];
                [weakself.tableView endFooterRefreshing];
                [weakself.loadingView showFailedViewWithClickBlock:^{
                    [weakself loadDataWithname:name Start:start count:count];
                }];
            } success:^(NSArray *fans) {
//                [CCProgressHUD hideHUDForView:weakself.view];
                [weakself.loadingView destroy];
                
                if (start == 0)
                {
                    weakself.fansOrFollowers = nil;
                }
                
                [weakself.fansOrFollowers addObjectsFromArray:fans];
                [weakself.tableView reloadData];
                [weakself.tableView endHeaderRefreshing];
                [weakself.tableView endFooterRefreshing];
                
                // 处理数据列表为空的情况，当前页面显示为没有关注的对象
                if ( weakself.fansOrFollowers.count )
                {
                    [weakself.tableView showFooter];
                }
                else
                {
                    [weakself.tableView hideFooter];
                }
                
                if (weakself.fansOrFollowers.count)
                {
                    weakself.noDataView.hidden = YES;
                    [weakself.noDataView removeFromSuperview];
                    
                    if (fans.count < count)
                    {
                        [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
                    }
                    
                    
                    //数据没有满一频目的时候盈藏加载更多
                    if((ScreenHeight - cellsize) / cellsize >= weakself.fansOrFollowers.count && fans.count < count)
                    {
                        [weakself.tableView hideFooter];
                    }else
                    {
                        [weakself.tableView showFooter];
                    }
                }
                else
                {
                    weakself.noDataView.hidden = NO;
                }
                
            } essionExpire:^{
                [weakself.loadingView showFailedViewWithClickBlock:^{
                    [weakself loadDataWithname:name Start:start count:count];
                }];
                [weakself.tableView endHeaderRefreshing];
                [weakself.tableView endFooterRefreshing];
                CCRelogin(weakself);
            }];
        }
            break;
    }
}

/**
 *  添加通知监听
 */
- (void)addNotification
{
    // 监听备注编辑成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRemark:) name:kEditedRemarkNotification object:nil];
}

#pragma mark - getters and setters

- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (NSMutableArray *)fansOrFollowers{
    if (!_fansOrFollowers)
    {
        _fansOrFollowers = [NSMutableArray array];
    }
    
    return _fansOrFollowers;
}

- (UIView *)noDataView {
    if (!_noDataView)
    {
      
        EVNullDataView *nodataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.tableView addSubview:nodataView];
        if ( [self.name isEqualToString:[EVLoginInfo localObject].name] || self.name == nil)
        {
            nodataView.topImage = [UIImage imageNamed:@"home_pic_findempty"];
            nodataView.title = self.type == FANS ? kE_GlobalZH(@"no_have_fans") :kE_GlobalZH(@"no_have_follow");
//            nodataView.subtitle = self.type == FANS ?  nil : kE_GlobalZH(@"go_follow");
            nodataView.subtitle = nil;
//            nodataView.buttonTitle = self.type == FANS ? kE_GlobalZH(@"send_go_living") : kE_GlobalZH(@"select_living_see");
        }
        else
        {
            nodataView.topImage = [UIImage imageNamed:@"personal_empty"];
            nodataView.title = kE_GlobalZH(@"null_data");
            nodataView.subtitle = nil;
            nodataView.buttonTitle = nil;
        }
        // delete by 佳南
//        [nodataView addButtonTarget:self action:@selector(noDataViewButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.noDataView = nodataView;
    }
    return _noDataView;
}

- (void)noDataViewButtonDidClicked:(UIButton *)button
{
    if ( [button.titleLabel.text isEqualToString:kE_GlobalZH(@"send_go_living")] )
    {
        [self requestNormalLivingPageForceImage:NO  allowList:nil audioOnly:NO delegate:self];
        
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ( [rootVC isKindOfClass:[EVHomeViewController class]] )
    {
        EVHomeViewController *homeVC = (EVHomeViewController *)rootVC;
        if ([button.titleLabel.text isEqualToString:kE_GlobalZH(@"select_living_see")])
        {
            homeVC.selectedIndex = 0;
        }
    }
}

- (EVLoadingView *)loadingView
{
    if ( !_loadingView )
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] initWithFrame:self.view.bounds];
        loadingView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_loadingView];
        _loadingView = loadingView;
    }
    
    return _loadingView;
}

@end
