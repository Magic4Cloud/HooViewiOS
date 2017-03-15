//
//  EVNoDisturbTableViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNoDisturbTableViewController.h"
#import "EVNoDisturbAllTableViewCell.h"
#import "EVNoDisturbOneTableViewCell.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "UIScrollView+GifRefresh.h"
#import "EVFanOrFollowerModel.h"
#import "EVOtherPersonViewController.h"
#import "EVAuthSettingModel.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#define tabandNav 113
#define cellsize 64

static const NSString *const NoDisturbAllCellID = @"allNoCell";
static const NSString *const NoDisturbOneCellID = @"oneNoCell";

@interface EVNoDisturbTableViewController ()

@property (strong, nonatomic) NSMutableArray *followers;
@property (strong, nonatomic) EVBaseToolManager *engine;

@end

@implementation EVNoDisturbTableViewController

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
    
    self.title = kE_GlobalZH(@"living_message_remind");
    [self addNotification];
    [self tableviewSetting];
    [self loadDataWithStart:0 count:kCountNum];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    
    [_engine cancelAllOperation];
    [EVNotificationCenter removeObserver:self];
    
    _engine = nil;
    _followers = nil;
}

- (void)setAuthModel:(EVAuthSettingModel *)authModel
{
    _authModel = authModel;
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
        case 0:
            return 1;
            break;
            
        case 1:
            return self.followers.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section)
    {
        case 0:
        {
            EVNoDisturbAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)NoDisturbAllCellID];
            
            cell.live = self.authModel.live;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) weakself = self;
            cell.switchHandle = ^(BOOL on){
                // 发送网络请求，关闭所有人的消息提醒
                [weakself.engine GETUserEditSettingWithFollow:weakself.authModel.follow disturb:weakself.authModel.disturb live:on start:^{
                    
                } fail:^(NSError *error) {
                    NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"setting_fail")];
                    [EVProgressHUD showError:errorStr toView:weakself.view];
                } success:^{
                    weakself.authModel.live = on;
                    [weakself.tableView reloadData];
                } sessionExpire:^{
                    EVRelogin(weakself);
                }];
            };
            return cell;
            
            break;
        }
            
        default:
        {
            EVNoDisturbOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)NoDisturbOneCellID];
            cell.switchEnable = self.authModel.live;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.followers[indexPath.row];
            __weak typeof(self) weakself = self;
            __weak EVNoDisturbOneTableViewCell *weakcell = cell;
            cell.switchHandle = ^(BOOL on, EVNoDisturbOneTableViewCell *operationCell){

//                // TO DO :
//                [weakself.engine GETUsersubscribeWithDUname:operationCell.model.name subscribe:on start:^{
//                    
//                } fail:^(NSError *error) {
//                    NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"setting_fail")];
//                    [EVProgressHUD showError:errorStr toView:weakself.view];
//                    [EVProgressHUD hideHUDForView:weakself.view];
//                } success:^{
//                    operationCell.model.subscribed = on;
//                } sessionExpire:^{
//                    
//                }];
            };
            cell.lookOver = ^{

                EVOtherPersonViewController *otherPersonVC = [[EVOtherPersonViewController alloc] initWithName:weakcell.model.name];
                otherPersonVC.fromLivingRoom = NO;
                [weakself.navigationController pushViewController:otherPersonVC animated:YES];
            };
            return cell;
            
            break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 35.0f)];
    sectionHeader.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 0.0f, sectionHeader.bounds.size.width - 17.0f, sectionHeader.bounds.size.height)];
    title.text = kE_GlobalZH(@"close_user_living_remind");
    title.textColor = [UIColor colorWithHexString:@"#9f9f9f"];
    title.font = [UIFont systemFontOfSize:13.0f];
    [sectionHeader addSubview:title];
    return sectionHeader;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IOS8_OR_LATER)
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1)
    {
        return 35.0f;
    }
    else
    {
        return 0.0f;
    }
}


#pragma mark - Notifications

- (void)changeRemark:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    
    // 遍历当前数组中的model，是否有相同name的，如果有，则其remarks属性值都做相应更改
    NSString *editedPersonName = dict[kNameKey];
    NSString *editedPersonRemarks = dict[kRemarks];
    
    for (EVFanOrFollowerModel *model in self.followers)
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

- (void)tableviewSetting{
    self.tableView.backgroundColor = [UIColor evBackgroundColor];
    self.tableView.rowHeight = 67.0f;
    self.tableView.separatorColor = [UIColor evGlobalSeparatorColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNoDisturbAllTableViewCell" bundle:nil] forCellReuseIdentifier:(NSString *)NoDisturbAllCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNoDisturbOneTableViewCell" bundle:nil] forCellReuseIdentifier:(NSString *)NoDisturbOneCellID];
    __weak typeof(self) weakself = self;
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadDataWithStart:weakself.followers.count count:kCountNum];
    }];
}

- (void)loadDataWithStart:(NSInteger)start count:(NSInteger)count{
    __weak typeof(self) weakself = self;
    
    [self.engine GETFollowersListWithName:nil startID:start count:count start:^{
        
    } fail:^(NSError *error) {
        // TO DO :
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"follow_list_data_fail")];
        [EVProgressHUD showError:errorStr toView:weakself.view];
        [weakself.tableView endFooterRefreshing];
    } success:^(NSArray *fans) {
        if (start == 0) {
            weakself.followers = nil;
        }
        [weakself.followers addObjectsFromArray:fans];
        [weakself.tableView reloadData];
        [weakself.tableView endFooterRefreshing];
        
        // 处理数据列表为空的情况，当前页面显示为没有视频
//        weakself.tableView.footer.hidden = weakself.followers.count ? NO : YES;
        if ( weakself.followers.count )
        {
            [weakself.tableView showFooter];
        }
        else
        {
            [weakself.tableView hideHeader];
        }
        
        if (weakself.followers.count)
        {
            if (fans.count < count)
            {
                [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
            }
            else
            {
                [weakself.tableView setFooterState:CCRefreshStateIdle];
            }
            //数据没有满一频目的时候盈藏加载更多
            if((ScreenHeight - tabandNav) / cellsize >= weakself.followers.count && fans.count < count)
            {
                [weakself.tableView hideFooter];
            }else
            {
                [weakself.tableView showFooter];
            }

        }
    } essionExpire:^{
        // TO DO :
        
        [weakself.tableView endFooterRefreshing];
    }];
}

- (void)addNotification
{
    // 监听备注编辑成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRemark:) name:kEditedRemarkNotification object:nil];
}

#pragma mark - getters and setters 

- (NSMutableArray *)followers {
    if (!_followers)
    {
        _followers = [NSMutableArray array];
    }
    
    return _followers;
}

- (EVBaseToolManager *)engine {
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

@end
