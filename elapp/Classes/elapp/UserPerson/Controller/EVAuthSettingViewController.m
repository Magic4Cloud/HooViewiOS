//
//  EVAuthSettingViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVAuthSettingViewController.h"
#import "EVAuthSettingTableViewCell.h"
#import "EVAuthSettingModel.h"
#import "PureLayout.h"
#import "EVNoDisturbTableViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVCacheTableViewCell.h"
#import "EVCacheManager.h"
#import "SDCycleScrollView.h"
#import "EVAboutTableViewController.h"
#import "EVAccountPhoneBindViewController.h"
#import "EVAccountBindViewController.h"
#import "EVUserModel.h"
#import "EVLoginInfo.h"
#import "EVEaseMob.h"
#import "EVWebViewCtrl.h"
#import "EVStartResourceTool.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import "NSString+Extension.h"


NSString *const cellID = @"authCell";

typedef enum : NSUInteger {
    EVLogoutType = 1000,
    EVForecastType,
} EVMineAlertType;

@interface EVAuthSettingViewController () <UITableViewDataSource, UITableViewDelegate, EVAuthSettingTableViewCellDelegate, UIActionSheetDelegate,EVAccountBindViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) EVBaseToolManager *engine;

@property (nonatomic, strong) EVAuthSettingModel *focusModel;           /**< 关注提醒 */
@property (nonatomic, strong) EVAuthSettingModel *disturbModel;         /**< 免打扰 */
@property ( strong, nonatomic ) EVAuthSettingModel *personalMsgModel;   /**< 私信推送开关 */
@property (nonatomic, strong) EVAuthSettingModel *liveModel;            /**< 直播消息提醒 */

@property ( strong, nonatomic ) NSArray *dataArray;                     /**< 数据源 */

@property ( strong, nonatomic ) EVCacheTableViewCell *selectedCell;

/** 应用所占内存大小 */
@property (nonatomic, assign) double cacheSize;

/** 计算缓存大小结束 */
@property (nonatomic, assign) BOOL calculateCacheSizeOver;

#ifdef STARTE_SWITCH_SERVER_MANUAL
@property (nonatomic,weak) UIButton *currentSelectButton;
@property (nonatomic,strong) NSArray *menuButtons;

#endif

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@end
@implementation EVAuthSettingViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    [self setData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
#ifdef STARTE_SWITCH_SERVER_MANUAL
    for ( UIButton *button in self.menuButtons )
    {
        button.selected = NO;
        if ( button.tag == [CCAppSetting shareInstance].serverState )
        {
            button.selected = YES;
            self.currentSelectButton = button;
        }
    }
#endif
    
}

- (void)setData
{
    // 获取用户信息
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserSettingInfoStart:^{
        
    } success:^(NSDictionary *info) {
        CCLog(@"####-----%d,----%s-----%@---####",__LINE__,__FUNCTION__,info);

        for (EVAuthSettingModel *item in weakSelf.dataArray[1])
        {
            [item updateDataWithDictionary:info];
        }
        for (EVAuthSettingModel *item in weakSelf.dataArray[0])
        {
            [item updateDataWithDictionary:info];
        }
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [CCProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"user_setting_data_fail")] toView:weakSelf.view];
    } sessionExpire:^{
        CCRelogin(weakSelf);
    }];
    
    // 获取所占内存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        double size = [[EVCacheManager shareInstance] imageCachesSizeOnDisk];
        self.calculateCacheSizeOver = YES;
        self.cacheSize = size;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

- (NSArray *)dataArray
{
    if ( _dataArray == nil )
    {
        // 第一组
        EVAuthSettingModel *messageItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"living_message_remind") type:EVAuthSettingModelTypeDefault];
        self.liveModel = messageItem;
        NSArray *array0 = @[messageItem];
        
        // 第二组
        EVAuthSettingModel *focusPomptItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"have_people_follow_me_remind") type:EVAuthSettingModelTypeSwitch];
        self.focusModel = focusPomptItem;
        EVAuthSettingModel *personalMessageItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"message_remind") type:EVAuthSettingModelTypeSwitch];
        // 设置全天免打扰，设置后，您将收不到任何推送
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        personalMessageItem.personalMsgOpen = options.noDisturbStatus != ePushNotificationNoDisturbStatusDay;
        self.personalMsgModel = personalMessageItem;
        CCLog(@"####-----%d,----%s-----nodisturb status == %zd---####",__LINE__,__FUNCTION__,options.noDisturbStatus);

        EVAuthSettingModel *nightItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"night_free_disturb") type:EVAuthSettingModelTypeSwitch];
        self.disturbModel = nightItem;
        NSArray *array1 = @[focusPomptItem,personalMessageItem,nightItem];
        
        // 第三组
        EVAuthSettingModel *accountItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"account_manager") type:EVAuthSettingModelTypeAccount];
        EVAuthSettingModel *contactWeItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"relation_me") type:EVAuthSettingModelTypeDefault];
        EVAuthSettingModel *opinionItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"opinion_feedback") type:EVAuthSettingModelTypeDefault];
        EVAuthSettingModel *clearItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"clear_cache_space") type:EVAuthSettingModelTypeClear];
        EVAuthSettingModel *aboutItem = [EVAuthSettingModel modelWithName:kE_GlobalZH(@"in_regard_to") type:EVAuthSettingModelTypeDefault];
        NSArray *array2 = @[accountItem,contactWeItem,opinionItem,clearItem, aboutItem];
        
        // 第五组
        EVAuthSettingModel *logoOutItem = [EVAuthSettingModel modelWithName:@"" type:EVAuthSettingModelTypeLogOut];
        logoOutItem.midText = kE_GlobalZH(@"push_out_login");
        NSArray *array3 = @[logoOutItem];
        
        _dataArray = @[array0,array1,array2,array3];
        
    }
    return _dataArray;
}

- (void)setUI
{
    self.title = kE_GlobalZH(@"e_setting");
    [self tableView];
    
#ifdef STARTE_SWITCH_SERVER_MANUAL
    [self setUpServerMenu];
#endif
}


#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag)
    {
        case EVLogoutType:
        {
            if (buttonIndex == 0)
            {
                __weak typeof(self) weakself = self;
                [_engine cancelAllOperation];
                [_engine GETLogoutWithFail:^(NSError *error) {
                } success:^{
                    CCLog(@"logout success");
                } essionExpire:^{
                    
                }];
                [EVLoginInfo cleanLoginInfo];
                [EVBaseToolManager resetSession];
                if ( self.navigationController )
                {
                    CCRelogin(self.navigationController);
                }
                [weakself.navigationController popToRootViewControllerAnimated:NO];
            }
        }
            break;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVAuthSettingModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ( [model.name isEqualToString:kE_GlobalZH(@"living_message_remind")] )
    {
        EVNoDisturbTableViewController *disturebTVC = [[EVNoDisturbTableViewController alloc] init];
        self.liveModel.follow = self.focusModel.follow;
        self.liveModel.disturb = self.disturbModel.disturb;
        self.liveModel.live = self.liveModel.live;
        disturebTVC.authModel = self.liveModel;
        [self.navigationController pushViewController:disturebTVC animated:YES];
    }
    else if ([model.name isEqualToString:kE_GlobalZH(@"account_manager")])
    {
        EVAccountBindViewController *accoutBindVC = [EVAccountBindViewController instanceWithAuth:self.userModel.auth];
        accoutBindVC.delegate = self;
        [self.navigationController pushViewController:accoutBindVC animated:YES];
        
    }
    else if ([model.name isEqualToString:kE_GlobalZH(@"relation_me")])
    {
        EVWebViewCtrl * webCtrl = [[EVWebViewCtrl alloc] init];
        webCtrl.title = kE_GlobalZH(@"relation_me");
        webCtrl.requestUrl = [[EVStartResourceTool shareInstance] connectUsUrl];
        [self.navigationController pushViewController:webCtrl animated:YES];
    }
    else if ([model.name isEqualToString:kE_GlobalZH(@"opinion_feedback")])
    {
        [self gotoFeedbackPage];
    }
    else if ([model.name isEqualToString:kE_GlobalZH(@"clear_cache_space")])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:kE_GlobalZH(@"confirm_clear") delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:kOK otherButtonTitles:nil, nil];
        self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        [actionSheet showInView:self.view];
    }
    
    else if ([model.name isEqualToString:kE_GlobalZH(@"in_regard_to")])
    {
        EVAboutTableViewController *aboutTVC = [EVAboutTableViewController instanceFromStoryboard];
        aboutTVC.userModel = self.userModel;
        [self.navigationController pushViewController:aboutTVC animated:YES];
    }
    else if ([model.name isEqualToString:@""] && [model.midText isEqualToString:kE_GlobalZH(@"push_out_login")])
    {
        CCLog(@"logout");
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kE_GlobalZH(@"confirm_cancel_push_out") message:nil delegate:self cancelButtonTitle:kOK otherButtonTitles:kCancel, nil];
            alert.tag = EVLogoutType;
            alert.delegate = self;
            [alert show];
        });

    }
}

- (void)gotoFeedbackPage
{

    self.feedbackKit = [[YWFeedbackKit alloc]initWithAppKey:ALI_FEEDBACK_APP_KEY];
    // 提取手机号
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];

    self.feedbackKit.customUIPlist = @{@"avatar":loginInfo.logourl};
    NSMutableDictionary *user_new = [NSMutableDictionary dictionary];
   
    if ( loginInfo.phone && ![loginInfo.phone isEqualToString:@""] )
    {
        self.feedbackKit.contactInfo = loginInfo.phone;
        [user_new setValue:loginInfo.phone forKey:@"phone"];
    }else if (loginInfo.birthday && ![loginInfo.birthday isEqualToString:@""]) {
        NSString *age = [NSString ageFromDateStr:loginInfo.birthday];
        [user_new setValue:age forKey:@"age"];
    }else if (loginInfo.name) {
        [user_new setValue:loginInfo.name forKey:@"name"];
    }else if (loginInfo.nickname) {
        [user_new setValue:loginInfo.nickname forKey:@"nickname"];
    }else if (loginInfo.gender) {
        [user_new setValue:loginInfo.gender forKey:@"gender"];
    }
    WEAK(self)
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWLightFeedbackViewController *viewController, NSError *error) {
         viewController.title = kE_GlobalZH(@"opinion_feedback");
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
        
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:weakself action:@selector(actionQuitFeedback)];
        
    }];
    
}

- (void)actionQuitFeedback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
        case 3:
        case 4:
            return 13.f;
    }
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    headerView.backgroundColor = [UIColor evBackgroundColor];
    UILabel *headerLabel = [[UILabel alloc] init];
    switch ( section )
    {
        case 0:
            headerLabel.frame = CGRectMake(20, 10, tableView.bounds.size.width, 14);
            headerLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:14];
            headerLabel.text = kE_GlobalZH(@"e_notification");
            break;
            
        case 2:
            headerLabel.frame = CGRectMake(20, 8, tableView.bounds.size.width, 11);
            headerLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:12];
            headerLabel.text = kE_GlobalZH(@"night_to_morning_nit_remind");
            break;
    }
    headerLabel.textColor = [UIColor colorWithHexString:kLightGrayTextColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:headerLabel];
    return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.dataArray objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVAuthSettingModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ( [model.name isEqualToString:kE_GlobalZH(@"clear_cache_space")] )
    {
        EVCacheTableViewCell *cacheCell = [[EVCacheTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CacheCell"];
        cacheCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cacheCell.titleStr = model.name;
        if (self.calculateCacheSizeOver)
        {
            cacheCell.detailTitleStr = [NSString stringWithFormat:@"%.02fM", self.cacheSize];
        }
        else
        {
            cacheCell.detailTitleStr = kE_GlobalZH(@"calculate");
        }
        return cacheCell;
    }
    
    EVAuthSettingTableViewCell *cell = [EVAuthSettingTableViewCell cellForTableView:tableView];
    cell.delegate = self;
    cell.authModel = model;
    cell.accounts = model.type == EVAuthSettingModelTypeAccount ? self.userModel.auth : nil;
    return cell;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 )
    {
        [self.selectedCell startAnimating];
        __block EVCacheTableViewCell *_bCell = _selectedCell;
        _selectedCell.isCleaning = YES;
        __weak typeof(self) weakSelf = self;
        [[EVCacheManager shareInstance] clearDiskImageCachesWithCompletion:^{
            double size = [[EVCacheManager shareInstance] imageCachesSizeOnDisk];
            weakSelf.cacheSize = size;
            _bCell.detailTitleStr = [NSString stringWithFormat:@"%.02fM", size];
            _bCell.isCleaning = NO;
        }];
        
        [[[SDCycleScrollView alloc] init] clearCache];
    }
}

#pragma mark - 绑定账号改变的代理方法

- (void)accoutBindChanged:(EVRelationWith3rdAccoutModel *)model
{
    NSArray *array = self.userModel.auth;
    NSMutableArray *changedArray = [array mutableCopy];

    NSInteger i = 0;
    for (; i < array.count; i ++)
    {
        EVRelationWith3rdAccoutModel *aModel = array[i];
        if ( [aModel.type isEqualToString:model.type] )
        {
            [changedArray removeObject:aModel];
        }
    }
    if ( i == array.count )
    {
        [changedArray addObject:model];
    }
    self.userModel.auth = changedArray;
    [self.tableView reloadData];
}

#pragma mark - EVAuthSettingTableViewCellDelegate
- (void)switchWithCell:(EVAuthSettingTableViewCell *)cell isOn:(BOOL)isOn
{
    __block EVAuthSettingModel *model = [[EVAuthSettingModel alloc] init];
    EVAuthSettingModel *currentModel = cell.authModel;
    if ( [currentModel.name isEqualToString:k_focusCellName] )
    {
        currentModel.follow = !currentModel.follow;
    }
    else if([currentModel.name isEqualToString:k_disturbCellName])
    {
        currentModel.disturb = !currentModel.disturb;
    }
    else if ([currentModel.name isEqualToString:kE_GlobalZH(@"message_remind")])
    {
        // 设置全天免打扰，设置后，您将收不到任何推送
        currentModel.personalMsgOpen = !currentModel.personalMsgOpen;
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        options.noDisturbStatus = currentModel.personalMsgOpen ? ePushNotificationNoDisturbStatusClose : ePushNotificationNoDisturbStatusDay;
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
        CCLog(@"####-----%d,----%s-----%zd---####",__LINE__,__FUNCTION__,options.noDisturbStatus);

        [self.tableView reloadData];
        return;
    }
    model = currentModel;
    
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    __weak typeof(self) weakSelf = self;
    
    [self.engine GETUserEditSettingWithFollow:self.focusModel.follow disturb:self.disturbModel.disturb live:self.liveModel.live start:^{
        
    } fail:^(NSError *error) {
        [CCProgressHUD showSuccess:kE_GlobalZH(@"motify_fail")];
        [model setWrong:YES];
        [weakSelf.tableView reloadData];
    } success:^{
        [weakSelf.tableView reloadData];
    } sessionExpire:^{
        CCRelogin(weakSelf);
    }];
    
}

#pragma mark - getter and setter

- (UITableView *)tableView
{
    if ( !_tableView )
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor evBackgroundColor];
        tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
        [self.view addSubview:tableView];
        [tableView autoPinEdgesToSuperviewEdges];
        _tableView = tableView;
    }
    return _tableView;
}


- (EVBaseToolManager *)engine
{
    if ( !_engine )
    {
        EVBaseToolManager *engine = [[EVBaseToolManager alloc] init];
        _engine = engine;
    }
    return _engine;
}

#pragma mark - 切换服务器按钮
#ifdef STARTE_SWITCH_SERVER_MANUAL
- (void)setUpServerMenu
{
    UIButton *devButton = [self menuButtonWithTitle:@"dev" tag:CCAPPServerStateDEV];
    devButton.selected = YES;
    [self.view addSubview:devButton];
    self.currentSelectButton = devButton;

    UIButton *innertestButton = [self menuButtonWithTitle:@"innertest" tag:CCAPPServerStateINNERTEST];
    [self.view addSubview:innertestButton];
    
    UIButton *rcButton = [self menuButtonWithTitle:@"rc" tag:CCAPPServerStateRC];
    [self.view addSubview:rcButton];
    
    UIButton *releaseButton = [self menuButtonWithTitle:@"release" tag:CCAPPServerStateRELEASE];
    [self.view addSubview:releaseButton];
    
    self.menuButtons = @[devButton, innertestButton, rcButton, releaseButton];
    
    CGFloat buttonHeight = 50;
    [devButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [devButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [devButton autoSetDimension:ALDimensionHeight toSize:buttonHeight];
    
    [innertestButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [innertestButton autoSetDimension:ALDimensionHeight toSize:buttonHeight];
    
    [rcButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [rcButton autoSetDimension:ALDimensionHeight toSize:buttonHeight];
    
    [releaseButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [releaseButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [releaseButton autoSetDimension:ALDimensionHeight toSize:buttonHeight];
    
    
    [devButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:innertestButton];
    
    [innertestButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:devButton];
    [innertestButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:rcButton];
    
    [rcButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:innertestButton];
    [rcButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:releaseButton];
    
    [releaseButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:rcButton];
    
    [devButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:innertestButton];
    [innertestButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:rcButton];
     [rcButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:releaseButton];
}

- (UIButton *)menuButtonWithTitle:(NSString *)title
                              tag:(NSInteger)tag
{
    UIButton *devButton = [[UIButton alloc] init];
    devButton.tag = tag;
    [devButton setTitle:title forState:UIControlStateNormal];
    [devButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [devButton addTarget:self action:@selector(menuButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    return devButton;
}

- (void)menuButtonDidClicked:(UIButton *)btn
{
    self.currentSelectButton.selected = NO;
    btn.selected = YES;
    [CCAppSetting shareInstance].serverState = btn.tag;
    self.currentSelectButton = btn;
}

#endif

@end
