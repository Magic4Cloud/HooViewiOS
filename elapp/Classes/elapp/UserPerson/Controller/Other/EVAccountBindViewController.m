//
//  EVAccountBindViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVAccountBindViewController.h"
#import "EVAccountBindTableViewCell.h"
#import "EVRelationWith3rdAccoutModel.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVAccountPhoneBindViewController.h"
#import "EVBindOrChangePhoneTableViewCell.h"
#import "EVChangePWDTableViewCell.h"
#import <PureLayout.h>
#import "EVCheckOldPhoneViewController.h"
#import "EVChangePWDViewController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EV3rdPartAPIManager.h"

static NSString *const AccountBindCellID = @"AccountBindTableViewCell";

@interface EVAccountBindViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *accounts; /**< 全部账号的数组 */
@property (strong, nonatomic) EVBaseToolManager *engine;
@property (strong, nonatomic) EVRelationWith3rdAccoutModel *oldPhoneModel;
@property (strong, nonatomic) NSMutableArray *myAuthes; /**< 本页面用的授权数据 */

@end

@implementation EVAccountBindViewController

#pragma mark - class or instance methods

+ (instancetype)instanceWithAuth:(NSArray *)auth {
    EVAccountBindViewController *accountBindVC = [[EVAccountBindViewController alloc] init];
    accountBindVC.auth = auth;
    return accountBindVC;
}

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
    
    self.title = kE_GlobalZH(@"account_binding");
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self addThirdPartConfigForBindVC];
    // 如果绑定了，提取手机号
    NSMutableArray *tempAccounts = [NSMutableArray arrayWithArray:self.accounts];
    for (EVRelationWith3rdAccoutModel *accout in self.accounts) {
        if ([accout.type isEqualToString:kAuthTypePhone]) {
            self.oldPhoneModel = accout;
            [tempAccounts removeObject:accout];
            break;
        }
    }
    self.myAuthes = tempAccounts;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self setUpUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
    [_engine cancelAllOperation];
    _engine = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ( section )
    {
        case 0:
        {
            if ( !self.oldPhoneModel.token)
            {
                return 1;
            }
            return 2;
        }
            break;
            
        default:
        {
            return self.myAuthes.count;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ( indexPath.section)
    {
        case 0:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    EVBindOrChangePhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[EVBindOrChangePhoneTableViewCell cellID]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    __weak typeof(self) weakself = self;
                    cell.model = self.oldPhoneModel;
                    cell.bindOrChangePhone = ^(EVRelationWith3rdAccoutModel *model){
                        [weakself handlePhoneOperationWithModel:model];
                    };
                    return cell;
                }
                    break;
                    
                default:
                {
                    EVChangePWDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[EVChangePWDTableViewCell cellID]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
            }
        }
            break;
            
        default:
        {
            EVAccountBindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountBindCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.myAuthes[indexPath.row];
            [self handleCell:cell];
            return cell;
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 1 )
    {
        UIView *sectionHeader_1 = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth, 30.0f)];
        
        UILabel *title = [[UILabel alloc] init];
        title.backgroundColor = [UIColor evBackgroundColor];
        title.font = EVNormalFont(14.0f);
        title.textColor = [UIColor colorWithHexString:@"#8b847e"];
        title.text = kE_GlobalZH(@"social_account_binding");
        [sectionHeader_1 addSubview:title];
        [title autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, 16.0f, .0f, .0f)];
        
        UIView *topLine = [[UIView alloc] init];
        [sectionHeader_1 addSubview:topLine];
        topLine.backgroundColor = [UIColor evGlobalSeparatorColor];
        [topLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [topLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
        
        UIView *bottomLine = [[UIView alloc] init];
        [sectionHeader_1 addSubview:bottomLine];
        bottomLine.backgroundColor = [UIColor evGlobalSeparatorColor];
        [bottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [bottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
        
        return sectionHeader_1;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 1 )
    {
        return 30.0f;
    }
    
    return .0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 && indexPath.row == 1 )
    {
        EVChangePWDViewController *changePWDVC = [[EVChangePWDViewController alloc] init];
        [self.navigationController pushViewController:changePWDVC animated:YES];
    }
}

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

#pragma mark - Notification

- (void)handle3rdPart:(NSString *)type LoginSuccessDic:(NSDictionary *)userInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:type forKey:kType];
    NSString *token = nil;
    NSString *expireTime = nil;
    NSString *note = nil;
    if ( [type isEqualToString:WEIBOTYPE] )
    {
        note = kE_GlobalZH(@"weibo_account");
        token = userInfo[@"access_token"];
        expireTime = userInfo[@"expires_in"];
        [params setValue:token forKey:@"access_token"];
        [params setValue:userInfo[@"refresh_token"] forKey:@"refresh_token"];
        [params setValue:expireTime forKey:@"expires_in"];
        [params setValue:userInfo[@"uid"] forKey:@"token"];
    }
    else if( [type isEqualToString:WEIXINTYPE] )
    {
        note = kE_GlobalZH(@"wechat_account");
        token = userInfo[@"access_token"];
        expireTime = userInfo[@"expires_in"];
        [params setValue:token forKey:@"access_token"];
        [params setValue:WEIXINTYPE forKey:kType];
        [params setValue:expireTime forKey:@"expires_in"];
        [params setValue:userInfo[@"refresh_token"] forKey:@"refresh_token"];
        [params setValue:userInfo[@"openid"] forKey:@"token"];
        [params setValue:userInfo[kUnionid] forKey:kUnionid];
    }
    else if( [type isEqualToString:QQTYPE] )
    {
        note = kE_GlobalZH(@"QQ_account");
        token = userInfo[@"accessToken"];
        expireTime = userInfo[@"expires_in"];
        [params setValue:token forKey:@"accessToken"];
        [params setValue:expireTime forKey:@"expires_in"];
        [params setValue:userInfo[@"openId"] forKey:@"token"];
    }
    note = [NSString stringWithFormat:@"正在绑定%@账号，请稍等...", note];
    
    __weak typeof(self) weakself = self;
    [self.engine GETUserBindWithParams:params start:^{
        [EVProgressHUD showMessage:note toView:weakself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:weakself.view];
        [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"fail_binding")] toView:weakself.view];
    } success:^{
        [EVProgressHUD hideHUDForView:weakself.view];
        NSMutableArray *accoutsTemp = [NSMutableArray arrayWithArray:weakself.myAuthes];
        
        for (int i = 0; i < weakself.myAuthes.count; ++i)
        {
            EVRelationWith3rdAccoutModel *model = weakself.myAuthes[i];
            if ([model.type isEqualToString:type])
            {
                EVRelationWith3rdAccoutModel *modelTemp = [[EVRelationWith3rdAccoutModel alloc] init];
                modelTemp.type = model.type;
                modelTemp.token = token;
                modelTemp.expire_time = expireTime;
                [accoutsTemp replaceObjectAtIndex:i withObject:modelTemp];
                if ( weakself.delegate && [weakself.delegate respondsToSelector:@selector(accoutBindChanged:)] )
                {
                    [weakself.delegate accoutBindChanged:modelTemp];
                }
            }
        }
        weakself.myAuthes = accoutsTemp;
        [weakself.tableView reloadData];
        [EVNotificationCenter postNotificationName:EVUpdateAuthStatusNotification object:type userInfo:userInfo];
    } sessionExpire:^{
        [EVProgressHUD hideHUDForView:weakself.view];
        EVRelogin(weakself);
    }];
}

#pragma mark - private methods 

- (void)setUpUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.separatorInset = UIEdgeInsetsMake(0, 61, 0, 0);
    tableView.separatorColor = [UIColor evGlobalSeparatorColor];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.contentInset = UIEdgeInsetsMake(13.0f, .0f, .0f, .0f);
    tableView.backgroundColor = [UIColor evBackgroundColor];
    tableView.rowHeight = 55.0f;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"EVAccountBindTableViewCell" bundle:nil] forCellReuseIdentifier:AccountBindCellID];
    [tableView registerClass:[EVBindOrChangePhoneTableViewCell class] forCellReuseIdentifier:[EVBindOrChangePhoneTableViewCell cellID]];
    [tableView registerClass:[EVChangePWDTableViewCell class] forCellReuseIdentifier:[EVChangePWDTableViewCell cellID]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)showThirdAccoutHasBeenUsedMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil];
    [alert show];
}

- (void)handlePhoneOperationWithModel:(EVRelationWith3rdAccoutModel *)model
{
    if ( model.token.length > 0 )
    {
        EVCheckOldPhoneViewController *checkVC = [[EVCheckOldPhoneViewController alloc] init];
        checkVC.oldPhone = [model.token mutableCopy];
        [self.navigationController pushViewController:checkVC animated:YES];
    }
    else
    {
        EVAccountPhoneBindViewController *phoneBindVC = [EVAccountPhoneBindViewController accountPhoneBindViewController];
        phoneBindVC.model = model;
        [self.navigationController presentViewController:phoneBindVC animated:YES completion:nil];
    }
}

- (void)handleCell:(EVAccountBindTableViewCell *)cell
{
    // 判断有授权的账号是否大于1，如果=1 && 当前账号为唯一账号,则隐藏解绑按钮，否则显示(这个地方只告诉他是否)
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (EVRelationWith3rdAccoutModel *thirdModel in self.myAuthes)
    {
        if ( thirdModel.token )
        {
            [tempArrM addObject:thirdModel];
        }
    }
    
    if ( [cell.model.type isEqualToString:kAuthTypePhone] && [tempArrM containsObject:cell.model] )
    {
        cell.canShowBindButton = NO;
    }
    else if ( tempArrM.count <= 1 && [tempArrM containsObject:cell.model] && self.oldPhoneModel.token.length == 0 )
    {
        cell.canShowBindButton = NO;
    }
    else
    {
        cell.canShowBindButton = YES;
    }
    
    // 操作绑定
    __weak typeof(self) weakself = self;
    __weak EVAccountBindTableViewCell *weakcell = cell;
    cell.bindBlock = ^(NSString *type){
        __strong typeof(weakself) strongSelf = weakself;
        if ([type isEqualToString:QQTYPE])
        {
            [[EV3rdPartAPIManager sharedManager] qqLogin];
        }
        else if ([type isEqualToString:WEIXINTYPE])
        {
            //            [[CCShareManager shareInstance] weixinLogin];
            [[EV3rdPartAPIManager sharedManager] weixinLoginWithViewController:strongSelf];
        }
        else if ([type isEqualToString:WEIBOTYPE])
        {
            [[EV3rdPartAPIManager sharedManager] weiboLogin];
        }
        else if ([type isEqualToString:PHONETYPE])
        {
            EVAccountPhoneBindViewController *phoneBindVC = [EVAccountPhoneBindViewController accountPhoneBindViewController];
            phoneBindVC.model = weakcell.model;
            [strongSelf.navigationController presentViewController:phoneBindVC animated:YES completion:nil];
        }
    };
    
    // 操作解绑
    cell.undoBindBlock = ^(NSString *type){
        EVUnbundlingAuthtype unbindType = -1;
        
        if ([type isEqualToString:QQTYPE])
        {
            unbindType = EVAccountQQ;
        }
        else if ([type isEqualToString:WEIXINTYPE])
        {
            unbindType = EVAccountWeixin;
        }
        else if ([type isEqualToString:WEIBOTYPE])
        {
            unbindType = EVAccountSina;
        }
        
        [weakself.engine GETUnbundlingtype:unbindType start:^{
            [EVProgressHUD showMessage:kE_GlobalZH(@"remove_binding") toView:weakself.view];
        } fail:^(NSError *error) {
            [EVProgressHUD hideHUDForView:weakself.view];
            [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"fail_remove_binding")] toView:weakself.view];
        } success:^(id success) {
            [EVProgressHUD hideHUDForView:weakself.view];
            [EVProgressHUD showSuccess:kE_GlobalZH(@"unbinding_success") toView:weakself.view];
            weakcell.model.token = nil;
            if ( weakself.delegate && [weakself.delegate respondsToSelector:@selector(accoutBindChanged:)] )
            {
                [weakself.delegate accoutBindChanged:weakcell.model];
            }
            [weakself.tableView reloadData];
        } essionExpire:^{
            
        }];
    };
}

#pragma mark - getters and setters

- (NSMutableArray *)accounts {
    if (!_accounts)
    {
        _accounts = [NSMutableArray array];
        [_accounts addObjectsFromArray:self.auth];
        NSArray *accountType = @[@"qq", @"weixin", @"sina", @"phone"];
        NSMutableArray *accountsTemp = [NSMutableArray arrayWithArray:accountType];
        for (EVRelationWith3rdAccoutModel *thirdAccout in _accounts)
        {
            for (NSString *typeTemp in accountType)
            {
                if ([typeTemp isEqualToString:thirdAccout.type])
                {
                    [accountsTemp removeObject:typeTemp];
                }
            }
        }
        
        for (NSString *typeTemp in accountsTemp)
        {
            EVRelationWith3rdAccoutModel *thirdAccout = [[EVRelationWith3rdAccoutModel alloc] init];
            thirdAccout.type = [typeTemp copy];
            [_accounts addObject:thirdAccout];
        }
    }
    return _accounts;
}

- (void)addThirdPartConfigForBindVC {
    WEAK(self);
    [[EV3rdPartAPIManager sharedManager] setQqLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself handle3rdPart:QQTYPE LoginSuccessDic:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setQqLoginFailure:^(NSDictionary *callBackDic) {
        EVLog(@"%s %@", __FUNCTION__, callBackDic);
    }];
    [[EV3rdPartAPIManager sharedManager] setWechatLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself handle3rdPart:WEIXINTYPE LoginSuccessDic:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setWechatLoginFailure:^(NSDictionary *callBackDic) {
        EVLog(@"%s %@", __FUNCTION__, callBackDic);
    }];
    [[EV3rdPartAPIManager sharedManager] setSinaLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself handle3rdPart:WEIBOTYPE LoginSuccessDic:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setSinaLoginFailure:^(NSDictionary *callBackDic) {
        EVLog(@"%s %@", __FUNCTION__, callBackDic);
    }];
}

- (NSIndexPath *)getIndexPathWithType:(NSString *)type {
    NSIndexPath *indexPath = nil;
    
    for (int i = 0; i < self.accounts.count; ++i)
    {
        EVRelationWith3rdAccoutModel *model = self.accounts[i];
        if ([model.type isEqualToString:type])
        {
            indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        }
    }
    return indexPath;
}

#pragma getters and setters

- (EVBaseToolManager *)engine {
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

@end
