//
//  EVLoginViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLoginViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVUserSettingViewController.h"
#import "EVPhoneRegistFirstController.h"
#import "AppDelegate.h"
#import "EVAlertManager.h"
#import "PureLayout.h"
#import "EVNavigationController.h"
#import "EVLoginView.h"
#import "EVPhoneLoginViewController.h"
#import "EVBugly.h"
#import "EVEaseMob.h"
#import "EV3rdPartAPIManager.h"
#import "EVTextViewController.h"
#import "EVSDKInitManager.h"

#define kGettingThirdPartUserInfo   kE_GlobalZH(@"obtain_user_three_info")
#define kSynThirdPartUserInfo       kE_GlobalZH(@"sunch_user_three_info")

#define kNotificationDefaultName @"default"

typedef NS_ENUM(NSInteger, CCLoginViewButtonType) {
    CCLoginViewRegistButton = 300,
    CCLoginViewLoginButton,
    CCLoginViewQQButton,
    CCLoginViewWeixinButton,
    CCLoginViewSinaButton
};

@interface EVLoginViewController () <UIScrollViewDelegate,CCLogWindowDelegate>

@property (nonatomic, strong) EVBaseToolManager   *engine;
@property (nonatomic, strong) UIScrollView *navSV;
@property (nonatomic, strong) UIButton     *removeNavSVBtn;

@end

@implementation EVLoginViewController 

#pragma mark - life cycle

+ (UINavigationController *)loginViewControllerWithNavigationController
{
    EVLoginViewController *con = [[EVLoginViewController alloc] init];
    return [EVNavigationController navigationWithWrapController:con];;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        [CCAppSetting shareInstance].isLogining = YES;
    }
    return self;
}

- (void)dealloc
{
    CCLog(@"%@ dealloc", [self class]);
    [CCAppSetting shareInstance].isLogining = NO;
    [_engine cancelAllOperation];
    _engine = nil;
    [CCNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self logoutIm];
    [self conFigView];
    [self setUpNotification];
    [self addThirdPartConfigForLoginVC];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/**
 * ---注销环信
 */
- (void)logoutIm
{
    [EVBaseToolManager imLogoutUnbind:NO success:^(NSDictionary *info) {
        [EVBaseToolManager setIMAccountHasLogin:NO];
     
        [[EVEaseMob cc_shareInstance] clear];

    } fail:^(EMError *error) {
        
    }];
}

- (void)conFigView
{
    EVLoginView *loginView = [[EVLoginView alloc] init];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    [loginView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    // 首次使用app，启动引导页
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ( [ud objectForKey:kFirstLoginKey] == nil )
    {
        [self.view addSubview:self.navSV];
        [self.removeNavSVBtn addTarget:self
                                action:@selector(removeNavSVBtnClick:)
                      forControlEvents:UIControlEventTouchUpInside];
        [ud setObject:kFirstLoginValue forKey:kFirstLoginKey];
    }
}

- (void)removeNavSVBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:1.0 animations:^{
        self.navSV.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.navSV removeFromSuperview];
        self.navSV = nil;
    }];
}

- (void)setUpNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(enterForeGround) name:UIApplicationWillEnterForegroundNotification object:nil];

    [CCNotificationCenter addObserver:self selector:@selector(phoneLoginSuccess) name:CCLoginViewControllerNeedToDismissNotification object:nil];
}


- (void)addThirdPartConfigForLoginVC {
    WEAK(self);
    [[EV3rdPartAPIManager sharedManager] setQqLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself qqLoginSuccess:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setQqLoginFailure:^(NSDictionary *callBackDic) {
        [weakself loginFailed:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setWechatLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself weixinLoginSuccess:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setWechatLoginFailure:^(NSDictionary *callBackDic) {
        [weakself loginFailed:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setSinaLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself sinaLoginSuccess:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setSinaLoginFailure:^(NSDictionary *callBackDic) {
        [weakself loginFailed:callBackDic];
    }];
}

- (void)phoneLoginSuccess
{
    if ( self.autoDismiss )
    {
        [self gotoHomePage];
    }
}

- (EVBaseToolManager *)engine
{
    if ( !_engine )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (UIButton *)removeNavSVBtn
{
    if ( !_removeNavSVBtn )
    {
        _removeNavSVBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _removeNavSVBtn;
}

- (void)enterForeGround
{
    [CCProgressHUD hideHUDForView:self.view];
}

-(void)loginView:(EVLoginView *)loginView clickButtonWithTag:(EVLoginViewButtonTag)tag
{
    switch (tag)
    {
        case EVRegistButton:
        {
            EVPhoneRegistFirstController *registerVC = [EVPhoneRegistFirstController phoneRegistFirstController];
            [self.navigationController pushViewController:registerVC animated:YES];
        }                
            break;
            
        case EVLoginButton:
        {
            EVPhoneLoginViewController *loginVC = [EVPhoneLoginViewController phoneLoginViewController];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
            break;
            
        case EVQQbtn:
            [[EV3rdPartAPIManager sharedManager] qqLogin];
            break;
            
        case EVWeixinbtn:
            [[EV3rdPartAPIManager sharedManager] weixinLoginWithViewController:self];
            
            break;
            
        case EVWeibobtn:
            [[EV3rdPartAPIManager sharedManager] weiboLogin];
            break;
        default:
            break;
    }
}

#pragma mark - 第三方登录
- (void)qqLoginSuccess:(NSDictionary *)userInfo {
    NSString *accessToken = userInfo[@"accessToken"];
    NSString *expires_in = [NSString stringWithFormat:@"%@",userInfo[@"expires_in"]];
    NSString *openId = userInfo[@"openId"];
    if ( accessToken.length == 0 || expires_in.length == 0 || openId.length == 0 )
    {
       
       [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        return;
    }
    EVThirdPartUserInfo *userModel = [[EVThirdPartUserInfo alloc] init];
    userModel.type = EVThirdPartUserInfoQQ;
    userModel.access_token = accessToken;
    userModel.expires_in = expires_in;
    userModel.openID = openId;
    __weak typeof(self) wself = self;
    [[EV3rdPartAPIManager sharedManager] getTirdPartUserInfo:userModel start:^{
        [CCProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    }success:^(EVThirdPartUserInfo *userInfo) {
        [wself thirdPartUserLoginWith:userInfo];
        [CCProgressHUD hideHUDForView:wself.view];
    } fail:^(NSError *error) {
        //QQ登录失败要上传的错误
        [CCProgressHUD hideHUDForView:wself.view];
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];;
        return;
    }];
}

- (void)sinaLoginSuccess:(NSDictionary *)userInfo
{
    NSString *accessToken = userInfo[@"access_token"];
    NSString *expires_in = [NSString stringWithFormat:@"%@",userInfo[@"expires_in"]];
    NSString *refresh_token = userInfo[@"refresh_token"];
    NSString *uid = [NSString stringWithFormat:@"%@",userInfo[@"uid"]];
    
    if ( accessToken.length == 0 || expires_in.length == 0 || refresh_token.length == 0 || uid.length == 0 )
    {
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        return;
    }
    
    EVThirdPartUserInfo *userModel = [[EVThirdPartUserInfo alloc] init];
    userModel.type = EVThirdPartUserInfoSina;
    userModel.access_token = accessToken;
    userModel.expires_in = expires_in;
    userModel.refresh_token = refresh_token;
    userModel.uid = uid;
    
    __weak typeof(self) wself = self;
    [[EV3rdPartAPIManager sharedManager] getTirdPartUserInfo:userModel start:^{
        [CCProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    } success:^(EVThirdPartUserInfo *userInfo) {
        [CCProgressHUD hideHUDForView:wself.view];
        [wself thirdPartUserLoginWith:userInfo];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];;
    }];
}

- (void)weixinLoginSuccess:(NSDictionary *)userInfo
{
    NSString *accessToken = userInfo[@"access_token"];
    NSString *expires_in = [NSString stringWithFormat:@"%@",userInfo[@"expires_in"]];
    NSString *refresh_token = userInfo[@"refresh_token"];
    NSString *openID = userInfo[@"openid"];
    
    if ( accessToken.length == 0 || expires_in.length == 0 || refresh_token.length == 0 || openID.length == 0 )
    {
       [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        return;
    }
    
    EVThirdPartUserInfo *userModel = [[EVThirdPartUserInfo alloc] init];
    userModel.type = EVThirdPartUserInfoWeixin;
    userModel.access_token = accessToken;
    userModel.expires_in = expires_in;
    userModel.refresh_token = refresh_token;
    userModel.openID = openID;
    
    __weak typeof(self) wself = self;
    [[EV3rdPartAPIManager sharedManager] getTirdPartUserInfo:userModel start:^ {
        [CCProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    } success:^(EVThirdPartUserInfo *userInfo) {
        [wself thirdPartUserLoginWith:userInfo];
        [CCProgressHUD hideHUDForView:wself.view];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        [CCProgressHUD showError:kFail_login toView:wself.view];
    }];
}

//第三方登录
- (void)thirdPartUserLoginWith:(EVThirdPartUserInfo *)userInfo
{
    CCUseLoginAuthtype type = (CCUseLoginAuthtype)userInfo.type;
    __weak typeof(self) wself = self;
    __weak typeof(wself.navigationController) wnav = wself.navigationController;
    NSDictionary *loginDic = [userInfo userLoginParams];
    [self.engine GETThirdPartLoginWithType:type params:loginDic  start:^{
        [CCProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    } fail:^(NSError *error) {
        NSString *errorStr = [error errorInfoWithPlacehold:kFail_login];
        [[EVAlertManager shareInstance] performComfirmTitle:errorStr message:nil comfirmTitle:kOK WithComfirm:nil];
        [CCProgressHUD hideHUDForView:wself.view];
    } success:^(EVLoginInfo *loginInfo) {
        [CCProgressHUD hideHUDForView:wself.view];
        [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
        [EVBugly setUserId:loginInfo.name];
        if ( loginInfo.hasLogin )
        {
            [loginInfo synchronized];
            if ( wself.autoDismiss )
            {
                if ( wnav )
                {
                    [wnav dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [wself dismissViewControllerAnimated:YES completion:nil];
                }
                [EVBaseToolManager notifyLoginViewDismiss];
                return ;
            }
            [wself gotoHomePage];
            return ;
        }
        [wself gotoUserSettingWithLoginInfo:loginInfo];
    }];
}

- (void)attributedLabelButton
{
    EVTextViewController *tvc = [[EVTextViewController alloc] init];
    tvc.type = CCTermOfService;
    [self.navigationController presentViewController:tvc
                                            animated:YES
                                          completion:nil];
}

- (void) gotoUserSettingWithLoginInfo:(EVLoginInfo *)info
{
    EVUserSettingViewController *settingVC = [EVUserSettingViewController userSettingViewController];
    settingVC.title = kEdit_user_info;
    settingVC.userInfo = info;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)gotoHomePage
{
    if ( self.navigationController )
    {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate setUpHomeController];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate setUpHomeController];
    }
    [EVBaseToolManager notifyLoginViewDismiss];
}

- (void)loginFailed:(NSDictionary *)userInfo
{
    
    NSString *errorInfo = userInfo[kErrorInfo];
    if ( [errorInfo isEqualToString:kQQAuthFail] )
    {
        // TODO
    }
    else if ( [errorInfo isEqualToString:kQQAuthCancel] )
    {
        // TODO
    }
    else if ( [errorInfo isEqualToString:kQQAuthNoNetWork] )
    {
        // TODO
    } else if ( [errorInfo isEqualToString:kWeixinAuthFail] )
    {
        // TODO
    }
    else if ( [errorInfo isEqualToString:kWeiXinAuthCancel] )
    {
        // TODO
    }
    else if ( [errorInfo isEqualToString:kWeiBoAuthCancel] )
    {
        // TODO
    }
    else if ( [errorInfo isEqualToString:kWeiBoAuthDeny] )
    {
        // TODO
    }
    else if ( [errorInfo isEqualToString:kWeiBoAuthFail] )
    {
        // TODO
    }
}

@end
