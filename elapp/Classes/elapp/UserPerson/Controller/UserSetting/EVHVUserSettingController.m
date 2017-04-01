//
//  EVHVUserSettingController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/27.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVHVUserSettingController.h"
#import "EVHVUserSettingViewCell.h"
#import "EVUserSettingModel.h"
#import "EVMineHeader.h"
#import "EVCacheManager.h"
#import "EVAccountBindViewController.h"
#import "EVAboutTableViewController.h"
#import "EVRefreshTimeViewController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVLoginInfo.h"
#import "SDCycleScrollView.h"
#import "EVSDKInitManager.h"
#import "EVEaseMob.h"
#import "EVRelationWith3rdAccoutModel.h"
#import "EVTextLiveModel.h"

typedef enum : NSUInteger {
    EVLogoutType = 1000,
    EVForecastType,
} EVMineAlertType;
@interface EVHVUserSettingController ()<UITableViewDelegate,UITableViewDataSource,EVAccountBindViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) UITableView *settingTableView;

@property (nonatomic, strong) NSMutableArray *allCellArray;

/** 计算缓存大小结束 */
@property (nonatomic, assign) BOOL calculateCacheSizeOver;

/** 应用所占内存大小 */
@property (nonatomic, assign) double cacheSize;

@property (strong, nonatomic) EVBaseToolManager *engine;

@end

@implementation EVHVUserSettingController
- (instancetype)init{
    self = [super init];
    
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)dealloc {
    [EVNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addTableView];
    self.title = @"设置";
    [EVNotificationCenter addObserver:self selector:@selector(updateAuth:) name:EVUpdateAuthStatusNotification object:nil];
}
- (void)updateAuth:(NSNotification *)notify {
    NSString *obj = notify.object;
    NSDictionary *userInfo = notify.userInfo;
    
    EVRelationWith3rdAccoutModel *currentModel;
    for (EVRelationWith3rdAccoutModel *model in self.userModel.auth) {
        if ([model.type isEqualToString:obj]) {
            currentModel = model;
        }
    }
    
    if (currentModel) {
        currentModel.token = userInfo[@"accessToken"];
    }
    else {
        NSMutableArray *tempArray = @[].mutableCopy;
        [tempArray addObjectsFromArray:self.userModel.auth];
        currentModel = [EVRelationWith3rdAccoutModel new];
        currentModel.token = userInfo[@"accessToken"];
        currentModel.type = obj;
        [tempArray addObject:currentModel];
        self.userModel.auth = tempArray.copy;
    }
}

- (void)addTableView
{
    NSMutableArray *firstArray = [NSMutableArray array];
    NSMutableArray *secondArray = [NSMutableArray array];
    NSMutableArray *threeArray = [NSMutableArray array];
    EVUserSettingModel *accountModel = [[EVUserSettingModel alloc] init];
    accountModel.nameLabel = @"账号管理";
    accountModel.cellType = EVSettingCellTypeImage;
    [firstArray addObject:accountModel];

    EVUserSettingModel *liveModel = [[EVUserSettingModel alloc] init];
    liveModel.nameLabel = @"直播提醒";
    liveModel.cellType = EVSettingCellTypeSwitch;
    [secondArray addObject:liveModel];
    
    EVUserSettingModel *deleteModel = [[EVUserSettingModel alloc] init];
    deleteModel.nameLabel = @"清除缓存";
    deleteModel.cellType = EVSettingCellTypeLabel;
    [secondArray addObject:deleteModel];
    
    
    EVUserSettingModel *aboutModel = [[EVUserSettingModel alloc] init];
    aboutModel.nameLabel = @"关于火眼";
    aboutModel.cellType = EVSettingCellTypeImage;
    [threeArray addObject:aboutModel];
    
    [self.allCellArray addObject:firstArray];
    [self.allCellArray addObject:secondArray];
    [self.allCellArray addObject:threeArray];
    
    UITableView *settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStyleGrouped)];
    settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:settingTableView];
    self.settingTableView = settingTableView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    UIButton *exitLogin = [[UIButton alloc] init];
    exitLogin.frame = CGRectMake((ScreenWidth - 260 )/2, 56, 260, 40);
    [footView addSubview:exitLogin];
    exitLogin.layer.cornerRadius = 20;
    exitLogin.layer.masksToBounds = YES;
    exitLogin.backgroundColor = [UIColor evMainColor];
    [exitLogin setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [exitLogin setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [exitLogin addTarget:self action:@selector(exitButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.settingTableView.tableFooterView = footView;
    
    // 获取所占内存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        double size = [[EVCacheManager shareInstance] imageCachesSizeOnDisk];
        self.calculateCacheSizeOver = YES;
        self.cacheSize = size;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.settingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = self.allCellArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allCellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVUserSettingViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"hvSettingCell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"EVHVUserSettingViewCell" owner:nil options:nil];
        cell = [nibs firstObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.userSettingModel = self.allCellArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (self.calculateCacheSizeOver)
        {
            cell.tipLabel.text = [NSString stringWithFormat:@"%.02fM", self.cacheSize];
        }
        else
        {
            cell.tipLabel.text = @"正在获取缓存";
        }
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        cell.tipLabel.text = EVAppVersion;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIView * lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor evLineColor];
            [cell.contentView addSubview:lineView];
            [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8];
            [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
            [lineView autoSetDimension:ALDimensionHeight toSize:1];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVUserSettingViewCell *cell = (EVHVUserSettingViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 0) {
        EVAccountBindViewController *accoutBindVC = [EVAccountBindViewController instanceWithAuth:self.userModel.auth];
        accoutBindVC.delegate = self;
        [self.navigationController pushViewController:accoutBindVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        [EVProgressHUD showLoadingMessage:@"缓存清除中" view:self.view];
        __weak typeof(self) weakSelf = self;
        [[EVCacheManager shareInstance] clearDiskImageCachesWithCompletion:^{
            double size = [[EVCacheManager shareInstance] imageCachesSizeOnDisk];
            weakSelf.cacheSize = size;
            [EVProgressHUD hideHUDForView:self.view];
            cell.tipLabel.text = [NSString stringWithFormat:@"%.02fM", size];
            [EVProgressHUD showSuccess:@"缓存已清除"];
        }];
        
        [[[SDCycleScrollView alloc] init] clearCache];
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        EVLog(@"关于火眼");
        EVAboutTableViewController *aboutVC = [EVAboutTableViewController instanceFromStoryboard];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0)
    {
        __weak typeof(self) weakself = self;
        [EVNotificationCenter postNotificationName:@"userLogoutSuccess" object:nil];
        [_engine cancelAllOperation];
        [_engine GETLogoutWithFail:^(NSError *error) {
        } success:^{
            EVLog(@"logout success");
        } essionExpire:^{
            
        }];
        [EVEaseMob logoutIMLoginFail:^(EMError *error) {
            EVLog(@"EMlogouterror-----  %@",error);
        }];
        [EVLoginInfo cleanLoginInfo];
        [EVTextLiveModel cleanTextLiveInfo];
        [EVBaseToolManager resetSession];
        [EVSDKInitManager initMessageSDKUserData:nil];
        [EVNotificationCenter postNotificationName:NotifyOfLogout object:nil];
        if ( self.navigationController )
        {
            EVRelogin(self.navigationController);
        }
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)exitButton:(UIButton *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kE_GlobalZH(@"confirm_cancel_push_out") message:nil delegate:self cancelButtonTitle:kOK otherButtonTitles:kCancel, nil];
        alert.delegate = self;
        [alert show];
    });
}

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
}

- (NSMutableArray *)allCellArray
{
    if (!_allCellArray) {
        _allCellArray = [NSMutableArray array];
    }
    
    return _allCellArray;
}

- (EVBaseToolManager *)engine
{
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
